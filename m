From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Patches for fine-grained rsocket preloading
Date: Thu, 4 Sep 2014 18:07:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DC1580@ORSMSX109.amr.corp.intel.com>
References: <17f3d712c0ef986a2cfe8eb11d99f66d@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <17f3d712c0ef986a2cfe8eb11d99f66d-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Could you please go through the provided changes and ensure that
> they are part of the regular rsocket head stream.

It would be helpful to separate patches into different email messages.
 
> Subject: [patch 1/3] subsystem: RDMA CM
> commit 725d209ea390c643447c337b178442e5ef7b8b50
> Author: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Date:   Tue Aug 5 16:18:58 2014 +0530
> 
>      By default the R-Sockets pre-loading library intercepts all the
> stream
>      and datagram sockets belonging to a launched program processes and
> threads.
> 
>      However, distributed application and database servers may require
> fine
>      grained interception to ensure that only the processes which are
> listening
>      for remote connections on the RDMA transport need to be enabled with
> RDMA
>      while remaining can continue to use TCP as before.  This allows
> proper
>      communication happening between various server components locally.
> 
>      A configuration file based mechanism is introduced to facilitate
> this
>      fine grained interception mechanism.  As part of preload
> initialization,
>      the configuration file is scanned and an in-memory record store is
> created
>      with all the entries found.  When a request is made to intercept a
> socket,
>      its attributes are cross checked with stored records to see whether
> we
>      should proceed with rsocket switch over.
> 
>      Note: Right now, the fine grained interception mechanism is enabled
> only
>            for newly created sockets.  Going forward, this can be extened
> to
>            select connections based on the specified host/IP addresses
> and
>            ports as well.
> 
>      "preload_config" is the name of the configuration file which should
> exist
>      in the default configuration location (usually the full path to this
>      configuration file is:
> <install-root>/etc/rdma/rsocket/preload_config)
>      of an installed rsocket library.
>      The sample format for this configuration file is shown below:
> 
>      @#
>      @# Sample config file for preloading in a program specific way
>      @#
>      @# Each line entry should have the following format:
>      @#
>      @#   prog_name <space> dom_spec <space> type_spec <space> proto_spec
>      @#
>      @# where,
>      @#
>      @# prog_name  - program or command name (string without spaces)
>      @# dom_spec   - one or more socket domain strings separated by
> commas
>      @#            - format: {*|domain,[,domain,...]}
>      @#            - '*' means any valid domain
>      @#            - valid domains: inet/inet6/ib
>      @# type_spec  - one or more socket type strings separated by commas
>      @#            - format: {*|type[,type,...]}
>      @#            - '*' means any valid type
>      @#            - valid types: stream/dgram
>      @# proto_spec - one or more socket protocol strings separated by
> commas
>      @#            - format: {*|protocol[,protocol,...]}
>      @#            - '*' means any valid protocol
>      @#            - valid protocols: tcp/udp
>      @# <space>    - one ore more tab or space characters
>      @#
>      @# Note:
>      @#  Lines beginning with '#' character are treated as comments.
>      @#  Comments at the end of an entry are allowed and should be
> preceded
>      @#  by '#' character.
>      @#  Blank lines are ignored.
>      @
>      @progA inet stream tcp # intercept progA's internet stream sockets
>      @progB inet6 dgram udp # intercept progB's ipv6 datagram sockets
>      @progC * * * # intercept progC's sockets
> 
>      Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Overall, the patch concepts look reasonable.  See comments below.

>      ---
> diff --git a/src/preload.c b/src/preload.c
> index fb2149b..8c043aa 100644
> --- a/src/preload.c
> +++ b/src/preload.c
> @@ -50,6 +50,8 @@
>   #include <netinet/tcp.h>
>   #include <unistd.h>
>   #include <semaphore.h>
> +#include <ctype.h>
> +#include <stdlib.h>
> 
>   #include <rdma/rdma_cma.h>
>   #include <rdma/rdma_verbs.h>
> @@ -57,6 +59,10 @@
>   #include "cma.h"
>   #include "indexer.h"
> 
> +#ifndef LINE_MAX
> +#define LINE_MAX 2048
> +#endif /* LINE_MAX */

Any reason why this can't just be an enum and a smaller value?

> +static config_entry_t *entryp = NULL;
> +static int16_t nentries = 0;
> +static int16_t config_scanned = 0;
> +static int16_t config_avail = 0;
> +extern char *program_invocation_short_name;

Static variables are initialized to 0 by default (C standard).

> +/* free in-memory config store
> + * should be called only once during finalization
> + */
> +static void free_preload_config(void)
> +{
> +   int i;
> +
> +   if (entryp) {
> +       for (i = 0; i < nentries; i++) {
> +           if (entryp[i].name) {
> +               free(entryp[i].name);
> +           }
> +       }
> +       free(entryp);
> +   }
> +
> +   return;
> +}
> +
> +/* check whether interception is required for this socket
> + * compares the provided attributes with that available in the
> in-memory
> + * data store for the current process
> + * sets-up in-memory config store if it's already not done
> + */
> +static int intercept_socket(int domain, int type, int protocol)
> +{
> +   int i;
> +
> +   if (!config_scanned) {
> +       pthread_mutex_lock(&mut);
> +       if (scan_preload_config() == 0) {
> +           config_avail = 1;
> +       }
> +       if (entryp) {
> +           atexit(free_preload_config);
> +       }
> +       config_scanned = 1;
> +       pthread_mutex_unlock(&mut);

There's already an init_preload() function that handles all initialization.  Please move the scanning of the file there.  You can then drop the config_scanned variable.

> +   }
> +
> +   if (!config_avail) {
> +       return -1;
> +   }

This can probably go.  I'm not sure why the return value is -1, versus just 1 or 0.

> +
> +   /* locate the config entry */
> +   for (i = 0; i < nentries; i++) {
> +       if (strncmp(entryp[i].name, program_invocation_short_name,
> strlen(entryp[i].name)) == 0) {
> +           break;
> +       }
> +   }
> +   if (i == nentries) {
> +       return 0;
> +   }
> +
> +   /* match domain field */
> +   if (!(entryp[i].domain & (1 << domain))) {
> +       return 0;
> +   }
> +
> +   /* match type field */
> +   if (!(entryp[i].type & (1 << type))) {
> +       return 0;
> +   }
> +
> +   /* match protocol field only if protocol is specified */
> +   if (protocol && !(entryp[i].protocol & (1 << protocol))) {
> +       return 0;
> +   }
> +
> +   /* entry matched */
> +   return 1;
> +}
> +
>   static int fd_open(void)
>   {
>      struct fd_info *fdi;
> @@ -404,6 +631,10 @@ int socket(int domain, int type, int protocol)
>      static __thread int recursive;
>      int index, ret;
> 
> +   if (intercept_socket(domain, type, protocol) == 0) {
> +       goto real;
> +   }
> +
>      if (recursive)
>          goto real;
> 
> 
> Subject: [patch 2/3] subsystem: RDMA CM
> commit bf77b79be41b9ed288be6c7e858d463838febc84
> Author: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Date:   Tue Aug 5 16:38:05 2014 +0530
> 
>      Some complex server class applications start multiple listening
> threads
>      to receive client connection requests simultaneously from different
> sources.
>      When rsocket tries to intercept sockets belonging to such
> applications,
>      the listen() call made multiple times from different listening
> threads
>      should not result in error on par with the corresponding TCP
> behavior.
> 
>      The return value of rlisten() is modified to ensure that it wouldn't
>      bail out when it is invoked more than once with the same socket
> attributes
>      from different listening threads.  This behavior is gated by a
> runtime
>      parameter 'multi_listeners' with the associated configuration file
> so it
>      does not affect in any way the rest of rsocket applications.

I didn't follow this.  If rsocket is behaving differently than normal sockets, I'm fine updating it so that it matches the desired behavior.  It doesn't need to be an option.

That said, can you provide more details on what the desired behavior should be and what rsockets is doing differently?

> 
>      Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      ---
> 
> diff --git a/src/rsocket.c b/src/rsocket.c
> index 7007897..3879a70 100644
> --- a/src/rsocket.c
> +++ b/src/rsocket.c
> @@ -115,6 +115,7 @@ static uint16_t def_rqsize = 384;
>   static uint32_t def_mem = (1 << 17);
>   static uint32_t def_wmem = (1 << 17);
>   static uint32_t polling_time = 10;
> +static uint16_t multi_listeners = 0;
> 
>   /*
>    * Immediate data format is determined by the upper bits
> @@ -542,6 +543,11 @@ void rs_configure(void)
>          def_iomap_size = (uint8_t) rs_value_to_scale(
>              (uint16_t) rs_scale_to_value(def_iomap_size, 8), 8);
>      }
> +
> +   if ((f = fopen(RS_CONF_DIR "/multi_listeners", "r"))) {
> +       (void) fscanf(f, "%hu", &multi_listeners);
> +       fclose(f);
> +   }
>      init = 1;
>   out:
>      pthread_mutex_unlock(&mut);
> @@ -1175,8 +1181,12 @@ int rlisten(int socket, int backlog)
>      if (!rs)
>          return ERR(EBADF);
>      ret = rdma_listen(rs->cm_id, backlog);
> -   if (!ret)
> +   if (!ret) {
> +       rs->state = rs_listening;
> +   } else if (multi_listeners == 1 && errno == EINVAL) {
>          rs->state = rs_listening;

This is what I don't get.  The listen called failed, but we want to mark that the rsocket is in the listening state anyway?

> +       ret = 0;
> +   }
>      return ret;
>   }
> 
> 
> Subject: [patch 3/3] subsystem: RDMA CM
> commit 275aafe76c98718ad6989cbe1cf35fb82e36cd2c
> Author: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Date:   Tue Aug 5 16:45:41 2014 +0530
> 
>      While waiting for a completion queue event, rsocket's logic by
> default
>      bails out when interrupted.  Because of this, on the passive side
>      ongoing connection establishments are abruptly terminated without
>      fully accepting the incoming connection requests.
> 
>      The solution is to modify the completion event waiting logic to
> ensure
>      that it retries for the event upon interruption instead of returning
>      with an error.  This behavior is gated by a runtime parameter
>      'restart_onintr' with the associated configuration file so it does
>      not affect in any way the rest of rsocket applications.
> 
>      Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>      ---
> 
> diff --git a/src/rsocket.c b/src/rsocket.c
> index 3879a70..c7e5b11 100644
> --- a/src/rsocket.c
> +++ b/src/rsocket.c
> @@ -116,6 +116,7 @@ static uint32_t def_mem = (1 << 17);
>   static uint32_t def_wmem = (1 << 17);
>   static uint32_t polling_time = 10;
>   static uint16_t multi_listeners = 0;
> +static uint16_t restart_onintr = 0;
> 
>   /*
>    * Immediate data format is determined by the upper bits
> @@ -548,6 +549,11 @@ void rs_configure(void)
>          (void) fscanf(f, "%hu", &multi_listeners);
>          fclose(f);
>      }
> +
> +   if ((f = fopen(RS_CONF_DIR "/restart_onintr", "r"))) {
> +       (void) fscanf(f, "%hu", &restart_onintr);
> +       fclose(f);
> +   }
>      init = 1;
>   out:
>      pthread_mutex_unlock(&mut);
> @@ -1973,10 +1979,14 @@ static int rs_get_cq_event(struct rsocket *rs)
>      if (!rs->cq_armed)
>          return 0;
> 
> +resume_get_cq_event:
>      ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
>      if (!ret) {
>          ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
>          rs->cq_armed = 0;
> +   } else if (restart_onintr == 1 && errno == EINTR) {
> +       errno = 0;
> +       goto resume_get_cq_event;

Could this lead to the thread blocking forever?  Is there a reason to make this a conditional check? 

>      } else if (errno != EAGAIN) {
>          rs->state = rs_error;
>      }

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
