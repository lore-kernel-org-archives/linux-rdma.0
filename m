From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport disconnect
Date: Wed, 2 Jul 2014 14:46:06 -0500
Message-ID: <005a01cf962e$43d44300$cb7cc900$@opengridcomputing.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623223942.1634.89063.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD3FE0C540@CMEXMB1.ad.emulex.com> <53B45D7B.4020705@opengridcomputing.com> <C9B761DF-7960-4346-949E-17A9BDD357DB@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C9B761DF-7960-4346-949E-17A9BDD357DB-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Linux NFS Mailing List' <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, July 02, 2014 2:40 PM
> To: Steve Wise; Devesh Sharma
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux NFS Mailing List
> Subject: Re: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport =
disconnect
>=20
>=20
> On Jul 2, 2014, at 3:28 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:
>=20
> > On 7/2/2014 2:06 PM, Devesh Sharma wrote:
> >> This change is very much prone to generate poll_cq errors because =
of un-cleaned
> completions which still
> >> point to the non-existent QPs. On the new connection when these co=
mpletions are polled,
> the poll_cq will
> >> fail because old QP pointer is already NULL.
> >> Did anyone hit this situation during their testing?
>=20
> I tested this aggressively with a fault injector that triggers regula=
r connection
> disruption.
>=20
> > Hey Devesh,
> >
> > iw_cxgb4 will silently toss CQEs if the QP is not active.
>=20
> xprtrdma relies on getting a completion (either successful or in erro=
r) for every
> WR it has posted. The goal of this patch is to avoid throwing away qu=
eued
> completions after a transport disconnect so we don't lose track of FR=
MR rkey
> updates (FAST_REG_MR and LOCAL_INV completions) and we can capture al=
l RPC
> replies posted before the connection was lost.
>=20
> Sounds like we also need to keep the QP around, even in error state, =
until all
> known WRs on that QP have completed?
>

Perhaps.
=20
>=20
> >
> >
> >>> -----Original Message-----
> >>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> >>> Sent: Tuesday, June 24, 2014 4:10 AM
> >>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Subject: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport =
disconnect
> >>>
> >>> CQs are not destroyed until unmount. By draining CQs on transport
> >>> disconnect, successful completions that can change the r.frmr.sta=
te field can
> >>> be missed.
> >>>
> >>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>> ---
> >>>  net/sunrpc/xprtrdma/verbs.c |    5 -----
> >>>  1 file changed, 5 deletions(-)
> >>>
> >>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/ve=
rbs.c
> >>> index 3c7f904..451e100 100644
> >>> --- a/net/sunrpc/xprtrdma/verbs.c
> >>> +++ b/net/sunrpc/xprtrdma/verbs.c
> >>> @@ -873,9 +873,6 @@ retry:
> >>>  			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
> >>>  				" status %i\n", __func__, rc);
> >>>
> >>> -		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
> >>> -		rpcrdma_clean_cq(ep->rep_attr.send_cq);
> >>> -
> >>>  		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
> >>>  		id =3D rpcrdma_create_id(xprt, ia,
> >>>  				(struct sockaddr *)&xprt->rx_data.addr);
> >>> @@ -985,8 +982,6 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep,
> >>> struct rpcrdma_ia *ia)  {
> >>>  	int rc;
> >>>
> >>> -	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
> >>> -	rpcrdma_clean_cq(ep->rep_attr.send_cq);
> >>>  	rc =3D rdma_disconnect(ia->ri_id);
> >>>  	if (!rc) {
> >>>  		/* returns without wait if not connected */
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in the
> >>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo inf=
o at
> >>> http://vger.kernel.org/majordomo-info.html
> >> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=
=EF=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD=
^=EF=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=
=BD=EF=BF=BD=EF=BF=BD"=EF=BF=BD=EF=BF=BD^n=EF=BF=BDr=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=1A=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD&=EF=BF=BD=EF=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=
=03(=EF=BF=BD=E9=9A=8E
> =EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD=1A=EF=BF=BD=1Bm=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD=EF=BF=BDf=
=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=EF=BF=BDmml=3D=
=3D
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs=
" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
