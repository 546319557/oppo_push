-module(oppo_push).

%%API

-export([
        get_token/2,
        single_send/3,
        single_send/5,
        batch_send/3,
        batch_send/1,
        general_app_msg/5,
        general_notification/5
        ]).

-include_lib("eutil/include/eutil.hrl").

-define(SUCCESS, 0).

general_notification(AppKey, AppSecret, RegIds, Title, Content)->
  single_send(AppKey, AppSecret, RegIds, Title, Content).

general_app_msg(AppKey, AppSecret, RegIds, Title, Content)->
  single_send(AppKey, AppSecret, RegIds, Title, Content).

get_conf_app_key() ->
  {ok, AppKey} = application:get_env(oppo_push, app_key),
  AppKey.

get_conf_app_secret() ->
  {ok, AppSecret} = application:get_env(oppo_push, app_secret),
  AppSecret.

batch_send(Maps) ->
  AppKey = get_conf_app_key(),
  AppSecret = get_conf_app_secret(),
  batch_send(AppKey, AppSecret, Maps).

batch_send(AppKey, AppSecret, MapList) ->
  case get_token(AppKey, AppSecret) of
    {ok, Token} ->
      F =  fun(#{<<"regIds">> := RegIds, <<"title">> := Title, <<"content">> := Content}, Acc) ->
        Notification = #{<<"title">> => unicode:characters_to_binary(Title), <<"content">> => unicode:characters_to_binary(Content)},
        Message = #{<<"target_type">> => 2, <<"target_value">> => RegIds, <<"notification">> => eutil:json_encode(Notification)},
        [Message | Acc]
          end,
      MsgMap = #{<<"message">> => eutil:json_encode(lists:fold(F, [], MapList))},
      URL = <<"https://api.push.oppomobile.com/server/v1/message/notification/unicast_batch">>,
      send(Token, URL, MsgMap);
    _ ->
      {error, #{<<"code">> => 28, <<"message">> => <<"get token error">>}}
  end.

single_send(RegIds, Title, Desc) ->
  AppKey = get_conf_app_key(),
  AppSecret = get_conf_app_secret(),
  single_send(AppKey, AppSecret, RegIds, Title, Desc).

single_send(AppKey, AppSecret, RegIds, Title, Desc) ->
  case get_token(AppKey, AppSecret) of
    {ok, Token} ->
      Notification = #{<<"title">> => unicode:characters_to_binary(Title), <<"content">> => unicode:characters_to_binary(Desc)},
      Message = #{<<"target_type">> => 2, <<"target_value">> => RegIds, <<"notification">> => eutil:json_encode(Notification)},
      MsgMap = #{<<"message">> =>eutil:json_encode(Message)},
      URL = <<"https://api.push.oppomobile.com/server/v1/message/notification/unicast">>,
      send(Token, URL, MsgMap);
    _ ->
      {error, #{<<"code">> => 28, <<"message">> => <<"get token error">>}}
  end.

gen_headers(Token) ->
  [?URLENCEDED_HEAD, {<<"auth_token">>, Token}].

send(Token, URL, MsgMap) ->
  Headers = gen_headers(Token),
  send_for_headers(Headers, URL, MsgMap).

send_for_headers(Headers, URL, MsgMaps) ->
  case eutil:http_post(URL, Headers, MsgMaps, [{pool, oppo}]) of
  #{<<"code">> := ?SUCCESS} = Result ->
      {ok, Result};
    Other ->
      error_logger:error_msg("epush oppo error, URL: ~p, MsgMaps: ~p, Result: ~p", [URL, MsgMaps, Other]),
      {error, Other}
  end.

get_token(AppKey, AppSecret) ->
  Timestamp = erlang:system_time(second) * 1000,
  crypto:start(),
  Sign = base64:encode_to_string(crypto:hash(sha256, lists:concat([eutil:to_list(AppKey), Timestamp, eutil:to_list(AppSecret)]))),
  MsgMap = #{<<"app_key">> => AppKey, <<"sign">> => Sign, <<"timestamp">> => Timestamp},
  URL = <<"https://api.push.oppomobile.com/server/v1/auth">>,
  case eutil:http_post(URL, [?URLENCEDED_HEAD], MsgMap, [{pool, oppo}]) of
    #{<<"code">> := ?SUCCESS, <<"data">> := #{<<"auth_token">> := Token}} ->
      {ok, Token};
    Other ->
      error_logger:error_msg("epush oppo get token error, URL: ~p, MsgMaps: ~p, Result: ~p", [URL, MsgMap, Other]),
      {error, Other}
  end.
