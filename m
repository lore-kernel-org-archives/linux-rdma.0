From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport disconnect
Date: Wed, 2 Jul 2014 14:50:32 -0500
Message-ID: <006001cf962e$e20df020$a629d060$@opengridcomputing.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623223942.1634.89063.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD3FE0C540@CMEXMB1.ad.emulex.com> <53B45D7B.4020705@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE0C57A@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE0C57A-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Devesh Sharma [mailto:Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, July 02, 2014 2:43 PM
> To: Steve Wise; Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs@vg=
er.kernel.org
> Subject: RE: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport =
disconnect
>=20
> > -----Original Message-----
> > From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> > Sent: Thursday, July 03, 2014 12:59 AM
> > To: Devesh Sharma; Chuck Lever; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> > nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transpor=
t
> > disconnect
> >
> > On 7/2/2014 2:06 PM, Devesh Sharma wrote:
> > > This change is very much prone to generate poll_cq errors because=
 of
> > > un-cleaned completions which still point to the non-existent QPs.=
 On
> > > the new connection when these completions are polled, the poll_cq=
 will fail
> > because old QP pointer is already NULL.
> > > Did anyone hit this situation during their testing?
> >
> > Hey Devesh,
> >
> > iw_cxgb4 will silently toss CQEs if the QP is not active.
>=20
> Ya, just now checked that in mlx and cxgb4 driver code. On the other =
hand ocrdma is asserting
> a BUG-ON for such CQEs causing system panic.
> Out of curiosity I am asking, how this change is useful here, is it r=
educing the re-connection
> time...Anyhow rpcrdma_clean_cq was discarding the completions (flush/=
successful both)
>

Well, I don't think there is anything restricting an application from d=
estroying the QP with pending CQEs on its CQs.   So it definitely shoul=
dn't cause a BUG_ON() I think.   I'll have to read up in the Verbs spec=
s if destroying a QP kills all the pending CQEs...

=20
> >
> >
> > >> -----Original Message-----
> > >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> > >> Sent: Tuesday, June 24, 2014 4:10 AM
> > >> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >> Subject: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport
> > >> disconnect
> > >>
> > >> CQs are not destroyed until unmount. By draining CQs on transpor=
t
> > >> disconnect, successful completions that can change the r.frmr.st=
ate
> > >> field can be missed.
>=20
> Still those are missed isn=E2=80=99t it....Since those successful com=
pletions will still be dropped after re-
> connection. Am I missing something to
> understanding the motivation...
>=20
> > >>
> > >> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >> ---
> > >>   net/sunrpc/xprtrdma/verbs.c |    5 -----
> > >>   1 file changed, 5 deletions(-)
> > >>
> > >> diff --git a/net/sunrpc/xprtrdma/verbs.c
> > >> b/net/sunrpc/xprtrdma/verbs.c index 3c7f904..451e100 100644
> > >> --- a/net/sunrpc/xprtrdma/verbs.c
> > >> +++ b/net/sunrpc/xprtrdma/verbs.c
> > >> @@ -873,9 +873,6 @@ retry:
> > >>   			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
> > >>   				" status %i\n", __func__, rc);
> > >>
> > >> -		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
> > >> -		rpcrdma_clean_cq(ep->rep_attr.send_cq);
> > >> -
> > >>   		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
> > >>   		id =3D rpcrdma_create_id(xprt, ia,
> > >>   				(struct sockaddr *)&xprt->rx_data.addr);
> > @@ -985,8 +982,6 @@
> > >> rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, struct rpcrdma_ia *=
ia)
> > >> {
> > >>   	int rc;
> > >>
> > >> -	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
> > >> -	rpcrdma_clean_cq(ep->rep_attr.send_cq);
> > >>   	rc =3D rdma_disconnect(ia->ri_id);
> > >>   	if (!rc) {
> > >>   		/* returns without wait if not connected */
> > >>
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-=
rdma"
> > >> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> > majordomo
> > >> info at http://vger.kernel.org/majordomo-info.html
> > > N     r  y   b X  =C7=A7v ^ )=DE=BA{.n +    {   "  ^n r   z =1A  =
h    &  =1E G   h =03
> > > ( =E9=9A=8E =DD=A2j"  =1A =1Bm     z =DE=96   f   h   ~ mml=3D=3D


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
