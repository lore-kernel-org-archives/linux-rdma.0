From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: make loopback console compile on by default.
Date: Wed, 3 Aug 2011 15:42:25 -0700
Message-ID: <20110803154225.929fc118.weiny2@llnl.gov>
References: <20110706155435.ada5fbb6.weiny2@llnl.gov>
	<20110710091410.GB8520@localhost.localdomain>
	<5033C751-5B39-4F08-AB35-C595F17F6B6B@llnl.gov>
	<20110711175442.GF2084@localhost.localdomain>
	<20110713181730.6941e29a.weiny2@llnl.gov>
	<20110724120859.GA17166@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724120859.GA17166-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 24 Jul 2011 05:08:59 -0700
Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> One small issue bellow.
> 

[snip]

> >
> > diff --git a/config/osmvsel.m4 b/config/osmvsel.m4
> > index 2c91f63..87335e3 100644
> > --- a/config/osmvsel.m4
> > +++ b/config/osmvsel.m4
> > @@ -178,28 +178,50 @@ fi
> >  # --- END OPENIB_APP_OSMV_CHECK_HEADER ---
> >  ]) dnl OPENIB_APP_OSMV_CHECK_HEADER
> >
> > -dnl Check if they want the socket console
> > +dnl Check for socket console support
> >  AC_DEFUN([OPENIB_OSM_CONSOLE_SOCKET_SEL], [
> >  # --- BEGIN OPENIB_OSM_CONSOLE_SOCKET_SEL ---
> >
> > +dnl Console over a loopback socket is default if libwrap is available
> > +AC_ARG_ENABLE(console-loopback,
> > +[  --enable-console-loopback Enable a console socket on the loopback interface, requires tcp_wrappers (default yes)],
> > +[case $enableval in
> > +     yes) console_loopback=yes ;;
> > +     no)  console_loopback=no ;;
> > +   esac],
> > +   console_loopback=yes)
> > +
> > +if test $console_loopback = yes; then
> > +AC_CHECK_LIB(wrap, request_init, [], [console_loopback=no])
> 
> I think it's better to print a warning in case -lwrap is missing. Specially
> when you try to compile with --enable-console-socket and the configure fails
> telling you that it requires --enable-console-loopback which is on by default.
> So I suggest something like:
> 
> +AC_CHECK_LIB(wrap, request_init, [], [console_loopback=no
> +                                      AC_MSG_WARN(libwrap is missing. console_loopback=no)])
> 

Ok, v3 is on it's way,
Ira

> > +fi
> > +if test $console_loopback = yes; then
> > +  AC_DEFINE(ENABLE_OSM_CONSOLE_LOOPBACK,
> > +         1,
> > +         [Define as 1 if you want to enable a loopback console])
> > +fi
> > +
> >  dnl Console over a socket connection
> >  AC_ARG_ENABLE(console-socket,
> > -[  --enable-console-socket Enable a console socket, requires tcp_wrappers (default no)],
> > +[  --enable-console-socket Enable a console socket, requires --enable-console-loopback (default no)],
> >  [case $enableval in
> >       yes) console_socket=yes ;;
> >       no)  console_socket=no ;;
> >     esac],
> >     console_socket=no)
> >  if test $console_socket = yes; then
> > -  AC_CHECK_LIB(wrap, request_init, [],
> > -     AC_MSG_ERROR([request_init() not found. console-socket requires libwrap.]))
> > +  if test $console_loopback = no; then
> > +    AC_MSG_ERROR([--enable-console-socket requires --enable-console-loopback])
> > +  fi
> >    AC_DEFINE(ENABLE_OSM_CONSOLE_SOCKET,
> >           1,
> >           [Define as 1 if you want to enable a console on a socket connection])
> >  fi
> > +
> >  # --- END OPENIB_OSM_CONSOLE_SOCKET_SEL ---
> >  ]) dnl OPENIB_OSM_CONSOLE_SOCKET_SEL
> >
> > +
> > +
> >  dnl Check if they want the PerfMgr
> >  AC_DEFUN([OPENIB_OSM_PERF_MGR_SEL], [
> >  # --- BEGIN OPENIB_OSM_PERF_MGR_SEL ---
> > diff --git a/include/opensm/osm_console_io.h b/include/opensm/osm_console_io.h
> > index b51cbf7..7bf1313 100644
> > --- a/include/opensm/osm_console_io.h
> > +++ b/include/opensm/osm_console_io.h
> > @@ -45,8 +45,12 @@
> >
> >  #define OSM_DISABLE_CONSOLE      "off"
> >  #define OSM_LOCAL_CONSOLE        "local"
> > +#ifdef ENABLE_OSM_CONSOLE_SOCKET
> >  #define OSM_REMOTE_CONSOLE       "socket"
> > +#endif
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  #define OSM_LOOPBACK_CONSOLE     "loopback"
> > +#endif
> >  #define OSM_CONSOLE_NAME         "OSM Console"
> >
> >  #define OSM_DEFAULT_CONSOLE      OSM_DISABLE_CONSOLE
> > @@ -81,7 +85,7 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
> >  void osm_console_exit(osm_console_t * p_oct, osm_log_t * p_log);
> >  int is_console_enabled(osm_subn_opt_t *p_opt);
> >
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  int cio_open(osm_console_t * p_oct, int new_fd, osm_log_t * p_log);
> >  int cio_close(osm_console_t * p_oct, osm_log_t * p_log);
> >  int is_authorized(osm_console_t * p_oct);
> > diff --git a/man/opensm.8.in b/man/opensm.8.in
> > index f360739..042bee3 100644
> > --- a/man/opensm.8.in
> > +++ b/man/opensm.8.in
> > @@ -266,10 +266,13 @@ SMPs.
> >  Without -maxsmps, OpenSM defaults to a maximum of
> >  4 outstanding SMPs.
> >  .TP
> > -\fB\-console [off | local | socket | loopback]\fR
> > -This option brings up the OpenSM console (default off).
> > -Note that the socket and loopback options will only be available
> > -if OpenSM was built with --enable-console-socket.
> > +\fB\-console [off | local | loopback | socket]\fR
> > +This option brings up the OpenSM console (default off).  Note, loopback and
> > +socket open a socket which can be connected to WITHOUT CREDENTIALS.  Loopback
> > +is safer if access to your SM host is controlled.  tcp_wrappers
> > +(hosts.[allow|deny]) is used with loopback and socket.  loopback and socket
> > +will only be available if OpenSM was built with --enable-console-loopback
> > +(default yes) and --enable-console-socket (default no) respectively.
> >  .TP
> >  \fB\-console-port\fR <port>
> >  Specify an alternate telnet port for the socket console (default 10000).
> > diff --git a/opensm/main.c b/opensm/main.c
> > index 798cb20..51c8291 100644
> > --- a/opensm/main.c
> > +++ b/opensm/main.c
> > @@ -270,11 +270,14 @@ static void show_usage(void)
> >              "          Without --maxsmps, OpenSM defaults to a maximum of\n"
> >              "          4 outstanding SMPs.\n\n");
> >       printf("--console, -q [off|local"
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> > +            "|loopback"
> > +#endif
> >  #ifdef ENABLE_OSM_CONSOLE_SOCKET
> > -            "|socket|loopback"
> > +            "|socket"
> >  #endif
> >              "]\n          This option activates the OpenSM console (default off).\n\n");
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >       printf("--console-port, -C <port>\n"
> >              "          Specify an alternate telnet port for the console (default %d).\n\n",
> >              OSM_DEFAULT_CONSOLE_PORT);
> > @@ -621,7 +624,7 @@ int main(int argc, char *argv[])
> >               {"guid_routing_order_file", 1, NULL, 'X'},
> >               {"stay_on_fatal", 0, NULL, 'y'},
> >               {"honor_guid2lid", 0, NULL, 'x'},
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >               {"console-port", 1, NULL, 'C'},
> >  #endif
> >               {"daemon", 0, NULL, 'B'},
> > @@ -788,6 +791,8 @@ int main(int argc, char *argv[])
> >                           || strcmp(optarg, OSM_LOCAL_CONSOLE) == 0
> >  #ifdef ENABLE_OSM_CONSOLE_SOCKET
> >                           || strcmp(optarg, OSM_REMOTE_CONSOLE) == 0
> > +#endif
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >                           || strcmp(optarg, OSM_LOOPBACK_CONSOLE) == 0
> >  #endif
> >                           )
> > @@ -797,7 +802,7 @@ int main(int argc, char *argv[])
> >                                      optarg);
> >                       break;
> >
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >               case 'C':
> >                       opt.console_port = strtol(optarg, NULL, 0);
> >                       break;
> > diff --git a/opensm/osm_console.c b/opensm/osm_console.c
> > index 684d6ee..82a9b48 100644
> > --- a/opensm/osm_console.c
> > +++ b/opensm/osm_console.c
> > @@ -45,7 +45,7 @@
> >  #include <sys/socket.h>
> >  #include <netdb.h>
> >  #include <regex.h>
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  #include <arpa/inet.h>
> >  #endif
> >  #include <unistd.h>
> > @@ -1620,7 +1620,7 @@ int osm_console(osm_opensm_t * p_osm)
> >       if (poll(fds, nfds, 1000) <= 0)
> >               return 0;
> >
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >       if (pollfd[0].revents & POLLIN) {
> >               int new_fd = 0;
> >               struct sockaddr_in sin;
> > @@ -1678,7 +1678,7 @@ int osm_console(osm_opensm_t * p_osm)
> >       }
> >       /* input fd is closed (hanged up) */
> >       if (pollfd[1].revents & POLLHUP) {
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >               /* If we are using a socket, we close the current connection */
> >               if (p_oct->socket >= 0) {
> >                       cio_close(p_oct, &p_osm->log);
> > diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
> > index 0614c7f..da07a0b 100644
> > --- a/opensm/osm_console_io.c
> > +++ b/opensm/osm_console_io.c
> > @@ -46,7 +46,7 @@
> >  #endif                               /* HAVE_CONFIG_H */
> >
> >  #define _GNU_SOURCE          /* for getline */
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  #include <tcpd.h>
> >  #include <arpa/inet.h>
> >  #include <netinet/in.h>
> > @@ -66,6 +66,7 @@ static int is_local(char *str)
> >       return 0;
> >  }
> >
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  static int is_loopback(char *str)
> >  {
> >       /* convenience - checks if socket based connection */
> > @@ -73,7 +74,11 @@ static int is_loopback(char *str)
> >               return (strcmp(str, OSM_LOOPBACK_CONSOLE) == 0);
> >       return 0;
> >  }
> > +#else
> > +#define is_loopback is_local
> > +#endif
> >
> > +#ifdef ENABLE_OSM_CONSOLE_SOCKET
> >  static int is_remote(char *str)
> >  {
> >       /* convenience - checks if socket based connection */
> > @@ -81,6 +86,9 @@ static int is_remote(char *str)
> >               return strcmp(str, OSM_REMOTE_CONSOLE) == 0 || is_loopback(str);
> >       return 0;
> >  }
> > +#else
> > +#define is_remote is_loopback
> > +#endif
> >
> >  int is_console_enabled(osm_subn_opt_t * p_opt)
> >  {
> > @@ -92,7 +100,7 @@ int is_console_enabled(osm_subn_opt_t * p_opt)
> >  }
> >
> >
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >  int cio_close(osm_console_t * p_oct, osm_log_t * p_log)
> >  {
> >       int rtnval = -1;
> > @@ -181,9 +189,12 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
> >               p_oct->out_fd = fileno(stdout);
> >
> >               osm_console_prompt(p_oct->out);
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> > +     } else if (strcmp(opt->console, OSM_LOOPBACK_CONSOLE) == 0
> >  #ifdef ENABLE_OSM_CONSOLE_SOCKET
> > -     } else if (strcmp(opt->console, OSM_REMOTE_CONSOLE) == 0
> > -                || strcmp(opt->console, OSM_LOOPBACK_CONSOLE) == 0) {
> > +                || strcmp(opt->console, OSM_REMOTE_CONSOLE) == 0
> > +#endif
> > +                ) {
> >               struct sockaddr_in sin;
> >               int optval = 1;
> >
> > @@ -197,9 +208,11 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
> >                          &optval, sizeof(optval));
> >               sin.sin_family = AF_INET;
> >               sin.sin_port = htons(opt->console_port);
> > +#ifdef ENABLE_OSM_CONSOLE_SOCKET
> >               if (strcmp(opt->console, OSM_REMOTE_CONSOLE) == 0)
> >                       sin.sin_addr.s_addr = htonl(INADDR_ANY);
> >               else
> > +#endif
> >                       sin.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> >               if (bind(p_oct->socket, &sin, sizeof(sin)) < 0) {
> >                       OSM_LOG(p_log, OSM_LOG_ERROR,
> > @@ -230,7 +243,7 @@ int osm_console_init(osm_subn_opt_t * opt, osm_console_t * p_oct, osm_log_t * p_
> >  /* clean up and release resources */
> >  void osm_console_exit(osm_console_t * p_oct, osm_log_t * p_log)
> >  {
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >       cio_close(p_oct, p_log);
> >       if (p_oct->socket > 0) {
> >               OSM_LOG(p_log, OSM_LOG_INFO, "Closing console socket\n");
> > diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> > index 0b79d3a..3ba1f81 100644
> > --- a/opensm/osm_subnet.c
> > +++ b/opensm/osm_subnet.c
> > @@ -1118,8 +1118,10 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
> >
> >       if (strcmp(p_opts->console, OSM_DISABLE_CONSOLE)
> >           && strcmp(p_opts->console, OSM_LOCAL_CONSOLE)
> > -#ifdef ENABLE_OSM_CONSOLE_SOCKET
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> >           && strcmp(p_opts->console, OSM_LOOPBACK_CONSOLE)
> > +#endif
> > +#ifdef ENABLE_OSM_CONSOLE_SOCKET
> >           && strcmp(p_opts->console, OSM_REMOTE_CONSOLE)
> >  #endif
> >           ) {
> > @@ -1634,8 +1636,11 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
> >               "disable_multicast %s\n\n"
> >               "# If TRUE opensm will exit on fatal initialization issues\n"
> >               "exit_on_fatal %s\n\n" "# console [off|local"
> > +#ifdef ENABLE_OSM_CONSOLE_LOOPBACK
> > +             "|loopback"
> > +#endif
> >  #ifdef ENABLE_OSM_CONSOLE_SOCKET
> > -             "|loopback|socket]\n"
> > +             "|socket]\n"
> >  #else
> >               "]\n"
> >  #endif
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> 
> -- Alex


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
