-module(oppo_push_example).
-compile(export_all).

-define(AppKey, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(AppSecret, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(REGID, "go6VssZlTDDypm+hxYdaxycXtqM7M9NsTPbCjzyIyh0=").
-define(TITLE, "Title标题").
-define(DESC, "DESC内容").

single_send_test()->
  oppo_push:single_send(?AppKey, ?AppSecret, ?REGID, ?TITLE, ?DESC).

batch_send_test()->
  MapList = [#{<<"regIds">> => ?REGID, <<"title">> => ?TITLE, <<"content">> => ?DESC}],
  oppo_push:batch_send(?AppKey, ?AppSecret, MapList).


%%get_token(AppKey, AppSecret) ->
%%%%  crypto:start(),
%%%%  Type = sha,
%%%%  Context = crypto:hmac_init(Type, Key),
%%%%  NewContext = crypto:hmac_update(Context, erlang:list_to_binary(String)),
%%%%  Mac = crypto:hmac_final(NewContext),
%%%%  url_encode(base64:encode_to_string(Mac)).
%%%%  Sign = crypto:hmac(sha256, AppSecret, lists:c) -> Mac
%%%%  Timestamp = erlang:system_time(second) * 1000,
%%  Timestamp = erlang:system_time(second) * 1000,
%%  crypto:start(),
%%  Sign = base64:encode_to_string(crypto:hash(sha256, lists:concat([eutil:to_list(AppKey), Timestamp, eutil:to_list(AppSecret)]))),
%%  MsgMap = #{<<"app_key">> => AppKey, <<"sign">> => Sign, <<"timestamp">> => Timestamp},
%%  URL = <<"https://api.push.oppomobile.com/server/v1/auth">>,
%%  case eutil:http_post(URL, [?URLENCEDED_HEAD], MsgMap, [{pool, oppo}]) of
%%    #{<<"code">> := ?SUCCESS, <<"data">> := #{<<"auth_token">> := Token}} ->
%%      {ok, Token};
%%    Other ->
%%      error_logger:error_msg("epush oppo get token error, URL: ~p, MsgMaps: ~p, Result: ~p", [URL, MsgMap, Other]),
%%      {error, Other}
%%  end.

%%do_send(PayloadMaps) ->
%%  Method = post,
%%  Payload = eutil:urlencode(PayloadMaps),
%%  Options = [{pool, hms}],
%%  {ok, _Code, _Headers, ClientRef} = hackney:request(Method, ?HMS_API_URL, ?URLENCEDED_HEADS,
%%    Payload, Options),
%%  {ok, ResultBin} = hackney:body(ClientRef),
%%  eutil:json_decode(ResultBin).
%%
%%send(PayloadMaps) ->
%%  ResultOri = do_send(PayloadMaps),
%%  Result = case erlang:is_map(ResultOri) of
%%             true -> ResultOri;
%%             false -> eutil:json_decode(ResultOri)
%%           end,
%%  Code = case maps:get(<<"resultcode">>, Result, undefined) of
%%           undefined -> maps:get(<<"result_code">>, Result);
%%           Other -> Other
%%         end,
%%  case Code of
%%    ?SUCCESS ->
%%      {ok, Result};
%%%%    ?ACCESS_TOKEN_EXPIRE ->
%%%%      {access_token_expire, Result};
%%    _ ->
%%      error_logger:error_msg("huawei_push error, PayloadMaps: ~p, Result: ~p", [PayloadMaps, Result]),
%%      {error, Result}
%%  end.