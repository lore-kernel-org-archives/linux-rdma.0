From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibmad: Fixes for failures when not all ports of HCA
 are connected
Date: Wed, 13 Mar 2013 12:36:05 -0700
Message-ID: <CAMLCd9+a5=dnXPHJHYuoODho0aLRp8Vb35sMk0GvRxBgqvx0xQ@mail.gmail.com>
References: <513F83FD.1090106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513F83FD.1090106-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Your commit message does not seem to have anything to do with the
patch.  Could you explain how returning errno from these functions
"Fixes for failures when not all ports of HCA are connected"?

Furthermore, I'm reluctant to modify errno in this library.  It is not
documented and in general is poor form.  I realize that the interface
does not currently allow for an alternative.  :-(

More comments below.

On Tue, Mar 12, 2013 at 12:37 PM, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> src/resolve.c |   22 ++++++++++++++++++----
> src/rpc.c     |    1 +
> src/sa.c      |    2 ++
> 3 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/src/resolve.c b/src/resolve.c
> index f866bf4..ab24c79 100644
> --- a/src/resolve.c
> +++ b/src/resolve.c
> @@ -40,6 +40,7 @@
> #include <stdlib.h>
> #include <string.h>
> #include <arpa/inet.h>
> +#include <errno.h>
>
> #include <infiniband/umad.h>
> #include <infiniband/mad.h>
> @@ -57,10 +58,18 @@ int ib_resolve_smlid_via(ib_portid_t * sm_id, int
> timeout,
>
>         memset(sm_id, 0, sizeof(*sm_id));
>
> -       if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0,
> srcport))
> +       if (!smp_query_via(portinfo, &self, IB_ATTR_PORT_INFO, 0, 0,
> srcport)) {
> +               if (!errno)
> +                       errno = EIO;
>                 return -1;
> +       }
>
>         mad_decode_field(portinfo, IB_PORT_SMLID_F, &lid);
> +       if (lid == 0) {
> +               if (!errno)
> +                       errno = EIO;
> +               return -1;
> +       }

This may not be an error.  A port which is down only requires
PortState and PortPhyState to be valid.

>         mad_decode_field(portinfo, IB_PORT_SMSL_F, &sm_id->sl);
>
>         return ib_portid_set(sm_id, lid, 0, 0);
> @@ -95,21 +104,26 @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t
> * guid,
>                         ib_portid_t * sm_id, int timeout,
>                         const struct ibmad_port *srcport)
> {
> -       ib_portid_t sm_portid;
> +       ib_portid_t sm_portid = { 0 };
>         uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
>         ib_portid_t self = { 0 };
>         uint64_t selfguid, prefix;
>         ibmad_gid_t selfgid;
>         uint8_t nodeinfo[64];
>
> -       if (!sm_id) {
> +       if (!sm_id)
>                 sm_id = &sm_portid;
> +
> +       if (!sm_id->lid) {
>                 if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
>                         return -1;
>         }

If you want ib_resolve_guid_via to resolve the SM for you, sm_id
should be set to NULL.  I don't see a reason to support an "invalid"
sm_id port id.

Another note is that I have converted the diags to use internal
functions which used umad* and SA queries to resolve GUID's.  This is
more appropriate in the long term.

Ira

>
> -       if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0,
> srcport))
> +       if (!smp_query_via(nodeinfo, &self, IB_ATTR_NODE_INFO, 0, 0,
> srcport)) {
> +               if (!errno)
> +                       errno = EIO;
>                 return -1;
> +       }
>         mad_decode_field(nodeinfo, IB_NODE_PORT_GUID_F, &selfguid);
>         mad_set_field64(selfgid, 0, IB_GID_PREFIX_F,
> IB_DEFAULT_SUBN_PREFIX);
>         mad_set_field64(selfgid, 0, IB_GID_GUID_F, selfguid);
> diff --git a/src/rpc.c b/src/rpc.c
> index 6312d42..cf2b60d 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -178,6 +178,7 @@ _do_madrpc(int port_id, void *sndbuf, void *rcvbuf, int
> agentid, int len,
>                                          IB_MAD_TRID_F) != trid);
>
>                 status = umad_status(rcvbuf);
> +               errno = status;
>                 if (!status)
>                         return length;  /* done */
>                 if (status == ENOMEM)
> diff --git a/src/sa.c b/src/sa.c
> index 352ed9f..367da2a 100644
> --- a/src/sa.c
> +++ b/src/sa.c
> @@ -38,6 +38,7 @@
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> +#include <errno.h>
>
> #include <infiniband/mad.h>
> #include "mad_internal.h"
> @@ -56,6 +57,7 @@ uint8_t *sa_rpc_call(const struct ibmad_port *ibmad_port,
> void *rcvbuf,
>
>         if (portid->lid <= 0) {
>                 IBWARN("only lid routes are supported");
> +               errno = EIO;
>                 return NULL;
>         }
>
> --
> 1.7.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
