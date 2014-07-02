From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport disconnect
Date: Wed, 2 Jul 2014 15:40:28 -0400
Message-ID: <C9B761DF-7960-4346-949E-17A9BDD357DB@oracle.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623223942.1634.89063.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD3FE0C540@CMEXMB1.ad.emulex.com> <53B45D7B.4020705@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B45D7B.4020705-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 2, 2014, at 3:28 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wr=
ote:

> On 7/2/2014 2:06 PM, Devesh Sharma wrote:
>> This change is very much prone to generate poll_cq errors because of=
 un-cleaned completions which still
>> point to the non-existent QPs. On the new connection when these comp=
letions are polled, the poll_cq will
>> fail because old QP pointer is already NULL.
>> Did anyone hit this situation during their testing?

I tested this aggressively with a fault injector that triggers regular =
connection
disruption.

> Hey Devesh,
>=20
> iw_cxgb4 will silently toss CQEs if the QP is not active.

xprtrdma relies on getting a completion (either successful or in error)=
 for every
WR it has posted. The goal of this patch is to avoid throwing away queu=
ed
completions after a transport disconnect so we don't lose track of FRMR=
 rkey
updates (FAST_REG_MR and LOCAL_INV completions) and we can capture all =
RPC
replies posted before the connection was lost.

Sounds like we also need to keep the QP around, even in error state, un=
til all
known WRs on that QP have completed?


>=20
>=20
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>>> Sent: Tuesday, June 24, 2014 4:10 AM
>>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport di=
sconnect
>>>=20
>>> CQs are not destroyed until unmount. By draining CQs on transport
>>> disconnect, successful completions that can change the r.frmr.state=
 field can
>>> be missed.
>>>=20
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  net/sunrpc/xprtrdma/verbs.c |    5 -----
>>>  1 file changed, 5 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verb=
s.c
>>> index 3c7f904..451e100 100644
>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>> @@ -873,9 +873,6 @@ retry:
>>>  			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>>>  				" status %i\n", __func__, rc);
>>>=20
>>> -		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>>> -		rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>> -
>>>  		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>>>  		id =3D rpcrdma_create_id(xprt, ia,
>>>  				(struct sockaddr *)&xprt->rx_data.addr);
>>> @@ -985,8 +982,6 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep,
>>> struct rpcrdma_ia *ia)  {
>>>  	int rc;
>>>=20
>>> -	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>>> -	rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>>  	rc =3D rdma_disconnect(ia->ri_id);
>>>  	if (!rc) {
>>>  		/* returns without wait if not connected */
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in the
>>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info =
at
>>> http://vger.kernel.org/majordomo-info.html
>> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD=EF=BF=BD^n=EF=BF=BDr=EF=BF=BD=EF=BF=BD=EF=BF=
=BDz=EF=BF=BD=1A=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
&=EF=BF=BD=EF=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=03=
(=EF=BF=BD=E9=9A=8E=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD=1A=EF=BF=BD=1Bm=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=EF=
=BF=BDmml=3D=3D
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
