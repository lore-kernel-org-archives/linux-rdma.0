From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Wed, 20 Mar 2013 01:27:39 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com>
References: <5140E1A3.9070706@oracle.com> <51427819.7000505@oracle.com>
 <514278CA.8010809@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514278CA.8010809-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
> Sent: Thursday, March 14, 2013 9:27 PM
> To: Boris Chiu; iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Pramod Gunjikar
> Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
> of HCA are connected]
> 
> On 03/15/13 01:23 AM, brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> >
> > So, here is the history...
> >
> > There is an oracle application used to monitor the health of a node by
> > calling ib_resolve_portid_str_via(node GUID).
> >
> > We observed that a call to ib_resolve_portid_str_via() which specified
> > the use of an unconnected port to issue the query was returning -1
> > with errno as 0.

Again the library is not documented to set errno upon failure.  While this is unfortunate for your application I don't really want to go down this path.

> > The application interpreted this as the query
> > succeeded but no paths to the specified node were found and assumed
> > the node was dead. This obviously was not the case, we could not send
> > the query because the port was down which is very different to the
> > queried node being down. But the API does not provide a means to
> > distinguish between these two failure modes. Hence the reason for
> > updating errno to allow these two failure modes to be distinguished.

There are other, better, ways to tell if a port is up.  umad_get_port for example.

> >
> > Now in terms of the detail of the failure and the reason for the other
> > changes. The call to ib_resolve_portid_str_via() did not specify an
> > smid, so ib_resolve_portid_str_via() calls ib_resolve_guid_via() which
> > first tries to resolve the SM LID using the unconnected port:
> >
> > if (!sm_id) {
> >                 sm_id = &sm_portid;
> >                 if (ib_resolve_smlid_via(sm_id, timeout, srcport) < 0)
> >                         return -1;
> >         }
> >
> > The call to this succeeds (return value is not -1) and indicates that
> > the SM LID is 0, which is of course wrong. 

Again this is not wrong.  The fact there is no SM controlling that port is a side effect of you querying a port which is down and the unfortunate fact that this library makes generous use of SMP's where it should not.

> > Even though  port 2 is not
> > connected, it's SMA is still operational, It receives the get
> > PORT_INFO SMP (sent as a result of the ib_resolve_smlid_via()) , and
> > returns it successfully as the value it reads from the adapters
> > PORT_INFO which happens to be 0. ib_resolve_smlid_via() assumes
> > everything is OK, it does not bother to check the value of the SM LID
> > returned. We then try and contact the SM at LID 0!
> >
> > if ((portid->lid =
> >              ib_path_query_via(srcport, selfgid, portid->gid, sm_id,
> > buf)) < 0)
> >                 return -1;
> >
> > And this obviously fails, and so ib_resolve_portid_str_via() returns
> > -1 errno 0, and the app thinks the node is down. You could argue that
> > we should not specify an unconnected port in the call to
> > ib_resolve_portid_str_via(), but the changes harden the code, and
> > allow us to distinguish between no path to the node or could not issue
> > the SA query.

I feel bad that this code has lead you down this path.  However, these calls were never intended to be used on ports which are down.  The entire umad/mad stack attempts to chose the first active port for just this reason.  I believe you should look at issuing SA NodeRecord queries rather than rely on the internals of libibmad to do this functionality.

Sorry,
Ira

> >
> > Rdgs
> >
> > Brendan
> >
> >
> >
> >
> > On 03/13/13 08:29 PM, Boris Chiu wrote:
> >> fyi,
> >>
> >> Boris
> >>
> >>
> >> -------- Original Message --------
> >> Subject: 	Re: [PATCH] libibmad: Fixes for failures when not all ports
> >> of HCA are connected
> >> Date: 	Wed, 13 Mar 2013 12:36:05 -0700
> >> From: 	Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> To: 	Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> CC: 	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> References: 	<513F83FD.1090106-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>
> >>
> >>
> >> Your commit message does not seem to have anything to do with the
> >> patch.  Could you explain how returning errno from these functions
> >> "Fixes for failures when not all ports of HCA are connected"?
> >>
> >> Furthermore, I'm reluctant to modify errno in this library.  It is
> >> not documented and in general is poor form.  I realize that the
> >> interface does not currently allow for an alternative.  :-(
> >>
> >> More comments below.
> >>
> >> On Tue, Mar 12, 2013 at 12:37 PM, Boris Chiu<boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> wrote:
> >> >  From: Brendan Doyle<brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> >
> >> >  Signed-off-by: Brendan Doyle<brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> >  ---
> >> >  src/resolve.c |   22 ++++++++++++++++++----
> >> >  src/rpc.c     |    1 +
> >> >  src/sa.c      |    2 ++
> >> >  3 files changed, 21 insertions(+), 4 deletions(-)
> >> >
> >> >  diff --git a/src/resolve.c b/src/resolve.c  index f866bf4..ab24c79
> >> > 100644
> >> >  --- a/src/resolve.c
> >> >  +++ b/src/resolve.c
> >> >  @@ -40,6 +40,7 @@
> >> >  #include<stdlib.h>
> >> >  #include<string.h>
> >> >  #include<arpa/inet.h>
> >> >  +#include<errno.h>
> >> >
> >> >  #include<infiniband/umad.h>
> >> >  #include<infiniband/mad.h>
> >> >  @@ -57,10 +58,18 @@ int ib_resolve_smlid_via(ib_portid_t * sm_id,
> >> > int  timeout,
> >> >
> >> >          memset(sm_id, 0, sizeof(*sm_id));
> >> >
> >> >  -       if (!smp_query_via(portinfo,&self, IB_ATTR_PORT_INFO, 0, 0,
> >> >  srcport))
> >> >  +       if (!smp_query_via(portinfo,&self, IB_ATTR_PORT_INFO, 0, 0,
> >> >  srcport)) {
> >> >  +               if (!errno)
> >> >  +                       errno = EIO;
> >> >                  return -1;
> >> >  +       }
> >> >
> >> >          mad_decode_field(portinfo, IB_PORT_SMLID_F,&lid);
> >> >  +       if (lid == 0) {
> >> >  +               if (!errno)
> >> >  +                       errno = EIO;
> >> >  +               return -1;
> >> >  +       }
> >>
> >> This may not be an error.  A port which is down only requires
> >> PortState and PortPhyState to be valid.
> >>
> >> >          mad_decode_field(portinfo, IB_PORT_SMSL_F,&sm_id->sl);
> >> >
> >> >          return ib_portid_set(sm_id, lid, 0, 0);  @@ -95,21 +104,26
> >> > @@ int ib_resolve_guid_via(ib_portid_t * portid, uint64_t
> >> >  * guid,
> >> >                          ib_portid_t * sm_id, int timeout,
> >> >                          const struct ibmad_port *srcport)  {
> >> >  -       ib_portid_t sm_portid;
> >> >  +       ib_portid_t sm_portid = { 0 };
> >> >          uint8_t buf[IB_SA_DATA_SIZE] = { 0 };
> >> >          ib_portid_t self = { 0 };
> >> >          uint64_t selfguid, prefix;
> >> >          ibmad_gid_t selfgid;
> >> >          uint8_t nodeinfo[64];
> >> >
> >> >  -       if (!sm_id) {
> >> >  +       if (!sm_id)
> >> >                  sm_id =&sm_portid;  +
> >> >  +       if (!sm_id->lid) {
> >> >                  if (ib_resolve_smlid_via(sm_id, timeout, srcport)<  0)
> >> >                          return -1;
> >> >          }
> >>
> >> If you want ib_resolve_guid_via to resolve the SM for you, sm_id
> >> should be set to NULL.  I don't see a reason to support an "invalid"
> >> sm_id port id.
> >>
> >> Another note is that I have converted the diags to use internal
> >> functions which used umad* and SA queries to resolve GUID's.  This is
> >> more appropriate in the long term.
> >>
> >> Ira
> >>
> >> >
> >> >  -       if (!smp_query_via(nodeinfo,&self, IB_ATTR_NODE_INFO, 0, 0,
> >> >  srcport))
> >> >  +       if (!smp_query_via(nodeinfo,&self, IB_ATTR_NODE_INFO, 0, 0,
> >> >  srcport)) {
> >> >  +               if (!errno)
> >> >  +                       errno = EIO;
> >> >                  return -1;
> >> >  +       }
> >> >          mad_decode_field(nodeinfo, IB_NODE_PORT_GUID_F,&selfguid);
> >> >          mad_set_field64(selfgid, 0, IB_GID_PREFIX_F,
> >> > IB_DEFAULT_SUBN_PREFIX);
> >> >          mad_set_field64(selfgid, 0, IB_GID_GUID_F, selfguid);
> >> > diff --git a/src/rpc.c b/src/rpc.c  index 6312d42..cf2b60d 100644
> >> >  --- a/src/rpc.c
> >> >  +++ b/src/rpc.c
> >> >  @@ -178,6 +178,7 @@ _do_madrpc(int port_id, void *sndbuf, void
> >> > *rcvbuf, int  agentid, int len,
> >> >                                           IB_MAD_TRID_F) != trid);
> >> >
> >> >                  status = umad_status(rcvbuf);
> >> >  +               errno = status;
> >> >                  if (!status)
> >> >                          return length;  /* done */
> >> >                  if (status == ENOMEM)  diff --git a/src/sa.c
> >> > b/src/sa.c  index 352ed9f..367da2a 100644
> >> >  --- a/src/sa.c
> >> >  +++ b/src/sa.c
> >> >  @@ -38,6 +38,7 @@
> >> >  #include<stdio.h>
> >> >  #include<stdlib.h>
> >> >  #include<string.h>
> >> >  +#include<errno.h>
> >> >
> >> >  #include<infiniband/mad.h>
> >> >  #include "mad_internal.h"
> >> >  @@ -56,6 +57,7 @@ uint8_t *sa_rpc_call(const struct ibmad_port
> >> > *ibmad_port,  void *rcvbuf,
> >> >
> >> >          if (portid->lid<= 0) {
> >> >                  IBWARN("only lid routes are supported");
> >> >  +               errno = EIO;
> >> >                  return NULL;
> >> >          }
> >> >
> >> >  --
> >> >  1.7.1
> >> >
> >> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
