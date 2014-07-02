From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport disconnect
Date: Wed, 02 Jul 2014 14:28:59 -0500
Message-ID: <53B45D7B.4020705@opengridcomputing.com>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net> <20140623223942.1634.89063.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD3FE0C540@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FE0C540-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/2/2014 2:06 PM, Devesh Sharma wrote:
> This change is very much prone to generate poll_cq errors because of =
un-cleaned completions which still
> point to the non-existent QPs. On the new connection when these compl=
etions are polled, the poll_cq will
> fail because old QP pointer is already NULL.
> Did anyone hit this situation during their testing?

Hey Devesh,

iw_cxgb4 will silently toss CQEs if the QP is not active.


>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>> Sent: Tuesday, June 24, 2014 4:10 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH v1 05/13] xprtrdma: Don't drain CQs on transport dis=
connect
>>
>> CQs are not destroyed until unmount. By draining CQs on transport
>> disconnect, successful completions that can change the r.frmr.state =
field can
>> be missed.
>>
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   net/sunrpc/xprtrdma/verbs.c |    5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 3c7f904..451e100 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -873,9 +873,6 @@ retry:
>>   			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>>   				" status %i\n", __func__, rc);
>>
>> -		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>> -		rpcrdma_clean_cq(ep->rep_attr.send_cq);
>> -
>>   		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>>   		id =3D rpcrdma_create_id(xprt, ia,
>>   				(struct sockaddr *)&xprt->rx_data.addr);
>> @@ -985,8 +982,6 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep,
>> struct rpcrdma_ia *ia)  {
>>   	int rc;
>>
>> -	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>> -	rpcrdma_clean_cq(ep->rep_attr.send_cq);
>>   	rc =3D rdma_disconnect(ia->ri_id);
>>   	if (!rc) {
>>   		/* returns without wait if not connected */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info a=
t
>> http://vger.kernel.org/majordomo-info.html
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD=EF=BF=BD^n=EF=BF=BDr=EF=BF=BD=EF=BF=BD=EF=BF=
=BDz=EF=BF=BD=1A=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
&=EF=BF=BD=EF=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=03=
(=EF=BF=BD=E9=9A=8E=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD=1A=EF=BF=BD=1Bm=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=EF=
=BF=BDmml=3D=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
