%%%-------------------------------------------------------------------
%% @doc oppo_push top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(oppo_push_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
%%    Info = #{<<"title">> => unicode:characters_to_binary("78878"),
%%             <<"content">> => unicode:characters_to_binary("6776")},
%%    B = eutil:json_encode(Info),
%%    error_logger:error_msg("epush oppo error, URL: ~p, MsgMaps: ~p, Result: ~p", [B, 1, 1]),
%%
%%    C = #{<<"target_type">> => 2,
%%        <<"target_value">> => "3434",
%%        <<"notification">> => B},
%%    C1 = eutil:json_encode(C),
%%    error_logger:error_msg("epush oppo error, URL: ~p, MsgMaps: ~p, Result: ~p", [C1, 1, 1]),
%%
%%
%%    %%eutil:json_encode
%%    error_logger:error_msg("epush oppo error, URL: ~p, MsgMaps: ~p, Result: ~p", [B, 1, 1]),
%%    MsgMap = #{<<"message">> =>C1},
%%    A = eutil:urlencode(MsgMap),
%%    error_logger:error_msg("epush oppo error, URL: ~p, MsgMaps: ~p, Result: ~p", [A, 1, 1]),

%%    oppo_push:general_notification(<<"63bece657e514f6f99f440a5705a67ef">>,
%%        <<"8cc6f44d48ef4e60bdb81ff013574873">>, <<"435455435">>, <<"Title">>, <<"Desc">>),
    oppo_push:get_token(<<"63bece657e514f6f99f440a5705a67ef">>, <<"8cc6f44d48ef4e60bdb81ff013574873">>),
    {ok, { {one_for_all, 0, 1}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================
