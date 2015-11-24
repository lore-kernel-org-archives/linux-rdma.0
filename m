From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/9] xprtrdma: Add a safety margin for receive buffers
Date: Mon, 23 Nov 2015 20:16:42 -0500
Message-ID: <D946BAC3-26D5-4801-BD50-9F026EEF6551@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net> <20151123221357.32702.59922.stgit@manet.1015granger.net> <5653B586.705@talpey.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5653B586.705-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 23, 2015, at 7:55 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 11/23/2015 5:13 PM, Chuck Lever wrote:
>> Rarely, senders post a Send that is larger than the client's inline
>> threshold. That can be due to a bug, or the client and server may
>> not have communicated about their inline limits. RPC-over-RDMA
>> currently doesn't specify any particular limit on inline size, so
>> peers have to guess what it is.
>>=20
>> It is fatal to the connection if the size of a Send is larger than
>> the client's receive buffer. The sender is likely to retry with the
>> same message size, so the workload is stuck at that point.
>>=20
>> Follow Postel's robustness principal: Be conservative in what you
>> do, be liberal in what you accept from others. Increase the size of
>> client receive buffers by a safety margin, and add a warning when
>> the inline threshold is exceeded during receive.
>=20
> Safety is good, but how do know the chosen value is enough?
> Isn't it better to fail the badly-composed request and be done
> with it? Even if the stupid sender loops, which it will do
> anyway.

It=E2=80=99s good enough to compensate for the most common sender bug,
which is that the sender did not account for the 28 bytes of
the RPC-over-RDMA header when it built the send buffer. The
additional 100 byte margin is gravy.

The loop occurs because the server gets a completion error.
The client just sees a connection loss. There=E2=80=99s no way for it
to know it should fail the RPC, so it keeps trying.

Perhaps the server could remember that the reply failed, and
when the client retransmits, it can simply return that XID
with an RDMA_ERROR.


>> Note the Linux server's receive buffers are already page-sized.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/rpc_rdma.c  |    7 +++++++
>>  net/sunrpc/xprtrdma/verbs.c     |    6 +++++-
>>  net/sunrpc/xprtrdma/xprt_rdma.h |    5 +++++
>>  3 files changed, 17 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index c10d969..a169252 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -776,6 +776,7 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
>>  	int rdmalen, status;
>>  	unsigned long cwnd;
>>  	u32 credits;
>> +	RPC_IFDEBUG(struct rpcrdma_create_data_internal *cdata);
>>=20
>>  	dprintk("RPC:       %s: incoming rep %p\n", __func__, rep);
>>=20
>> @@ -783,6 +784,12 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
>>  		goto out_badstatus;
>>  	if (rep->rr_len < RPCRDMA_HDRLEN_MIN)
>>  		goto out_shortreply;
>> +#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
>> +	cdata =3D &r_xprt->rx_data;
>> +	if (rep->rr_len > cdata->inline_rsize)
>> +		pr_warn("RPC: %u byte reply exceeds inline threshold\n",
>> +			rep->rr_len);
>> +#endif
>>=20
>>  	headerp =3D rdmab_to_msg(rep->rr_rdmabuf);
>>  	if (headerp->rm_vers !=3D rpcrdma_version)
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index eadd1655..e3f12e2 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -924,7 +924,11 @@ rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt)
>>  	if (rep =3D=3D NULL)
>>  		goto out;
>>=20
>> -	rep->rr_rdmabuf =3D rpcrdma_alloc_regbuf(ia, cdata->inline_rsize,
>> +	/* The actual size of our receive buffers is increased slightly
>> +	 * to prevent small receive overruns from killing our connection.
>> +	 */
>> +	rep->rr_rdmabuf =3D rpcrdma_alloc_regbuf(ia, cdata->inline_rsize +
>> +					       RPCRDMA_RECV_MARGIN,
>>  					       GFP_KERNEL);
>>  	if (IS_ERR(rep->rr_rdmabuf)) {
>>  		rc =3D PTR_ERR(rep->rr_rdmabuf);
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index ac7f8d4..1b72ab1 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -337,6 +337,11 @@ struct rpcrdma_create_data_internal {
>>  #define RPCRDMA_INLINE_PAD_VALUE(rq)\
>>  	rpcx_to_rdmad(rq->rq_xprt).padding
>>=20
>> +/* To help prevent spurious connection shutdown, allow senders to
>> + * overrun our receive inline threshold by a small bit.
>> + */
>> +#define RPCRDMA_RECV_MARGIN	(128)
>> +
>>  /*
>>   * Statistics for RPCRDMA
>>   */
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>>=20

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
