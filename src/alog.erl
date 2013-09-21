%% ----------------------------------------------------------------------
%% Copyright 2011-2013 alogger project
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% @doc
%% This module is a main alog module. It serves start/0 and
%% stop/0 functions as a user API and implements appication behaviour.
%% It also contains runtime logging API that mimics macroses defined in
%% alog.hrl. There are 7 log levels (emergency, alert, critical, error,
%% warning, notice, info and debug) and 3 functions for each log
%% level - the one that accepts format string, arguments and list of tags,
%% the one without tags and the one with string only.
%% @end
%% ----------------------------------------------------------------------

-module(alog).
-behaviour(application).
-include_lib("alog.hrl").

%% API
-export([start/0, stop/0]).
%% Application callbacks
-export([start/2, stop/1]).
%% Runtime logging API
-export([log/4]).
-export([dbg/3, dbg/2, dbg/1]).
-export([info/3, info/2, info/1]).
-export([notice/3, notice/2, notice/1]).
-export([warning/3, warning/2, warning/1]).
-export([error/3, error/2, error/1]).
-export([critical/3, critical/2, critical/1]).
-export([alert/3, alert/2, alert/1]).
-export([emergency/3, emergency/2, emergency/1]).
%% Short control api aliases
-export([on/0, off/0, inv/0]).

%%% API
%% @doc Starts alog application
start() ->
    application:start(alog).

%% @doc Stops alog application
stop() ->
    application:stop(alog).

%%% Application callbacks
%% @private
start(_StartType, _StartArgs) ->
    Link = alog_sup:start_link(),
    ok = alog_control:init_loggers(),
    Link.

%% @private
stop(_State) ->
    ok.

%%% Runtime logging API
-spec log(nonempty_string(), list(), integer(), list(atom())) -> ok.
log(Format, Args, Level, Tags) ->
    ?LOGMOD:?LOGFUN(Format, Args, Level, Tags, runtime, 0, self()).

%% @doc stop logging on all flows, without any change flows values.
off() -> alog_control:power_off().
%% @doc inverse operation to off.
on()  -> alog_control:power_on().
%% @doc inverse current state from on to off and vice versa.
inv() -> alog_control:power_invers().

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec dbg(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
dbg(Format, Args, Tag) -> log(Format, Args, ?debug, Tag).

-spec dbg(Format :: nonempty_string(), Args :: list()) -> ok.
dbg(Format, Args)      -> log(Format, Args, ?debug, []).

-spec dbg(Format :: nonempty_string()) -> ok.
dbg(Format)            -> log(Format, [], ?debug, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec info(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
info(Format, Args, Tag) -> log(Format, Args, ?info, Tag).

-spec info(Format :: nonempty_string(), Args :: list()) -> ok.
info(Format, Args)      -> log(Format, Args, ?info, []).

-spec info(Format :: nonempty_string()) -> ok.
info(Format)            -> log(Format, [], ?info, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec notice(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
notice(Format, Args, Tag) -> log(Format, Args, ?notice, Tag).

-spec notice(Format :: nonempty_string(), Args :: list()) -> ok.
notice(Format, Args)      -> log(Format, Args, ?notice, []).

-spec notice(Format :: nonempty_string()) -> ok.
notice(Format)            -> log(Format, [], ?notice, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec warning(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
warning(Format, Args, Tag) -> log(Format, Args, ?warning, Tag).

-spec warning(Format :: nonempty_string(), Args :: list()) -> ok.
warning(Format, Args)      -> log(Format, Args, ?warning, []).

-spec warning(Format :: nonempty_string()) -> ok.
warning(Format)            -> log(Format, [], ?warning, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec error(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
error(Format, Args, Tag) -> log(Format, Args, ?error, Tag).

-spec error(Format :: nonempty_string(), Args :: list()) -> ok.
error(Format, Args)      -> log(Format, Args, ?error, []).

-spec error(Format :: nonempty_string()) -> ok.
error(Format)            -> log(Format, [], ?error, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec critical(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
critical(Format, Args, Tag) -> log(Format, Args, ?critical, Tag).

-spec critical(Format :: nonempty_string(), Args :: list()) -> ok.
critical(Format, Args)      -> log(Format, Args, ?critical, []).

-spec critical(Format :: nonempty_string()) -> ok.
critical(Format)            -> log(Format, [], ?critical, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec alert(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
alert(Format, Args, Tag) -> log(Format, Args, ?alert, Tag).

-spec alert(Format :: nonempty_string(), Args :: list()) -> ok.
alert(Format, Args)      -> log(Format, Args, ?alert, []).

-spec alert(Format :: nonempty_string()) -> ok.
alert(Format)            -> log(Format, [], ?alert, []).

%%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-spec emergency(Format :: nonempty_string(), Args :: list(), Tag :: list(atom())) -> ok.
emergency(Format, Args, Tag) -> log(Format, Args, ?emergency, Tag).

-spec emergency(Format :: nonempty_string(), Args :: list()) -> ok.
emergency(Format, Args)      -> log(Format, Args, ?emergency, []).

-spec emergency(Format :: nonempty_string()) -> ok.
emergency(Format)            -> log(Format, [], ?emergency, []).
