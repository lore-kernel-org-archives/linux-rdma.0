From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/21] xprtrdma: Update rkeys after transport reconnect
Date: Thu, 24 Jul 2014 16:03:48 -0400
Message-ID: <2656B3EB-0063-4EAE-BDE0-DCAB955A7697@oracle.com>
References: <20140722144459.6010.99389.stgit@manet.1015granger.net> <20140722145133.6010.52757.stgit@manet.1015granger.net> <53CEB038.5090901@netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53CEB038.5090901-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 22, 2014, at 2:40 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>=
 wrote:

> On 07/22/2014 10:51 AM, Chuck Lever wrote:
>> Various reports of:
>>=20
>>  rpcrdma_qp_async_error_upcall: QP error 3 on device mlx4_0
>> 		ep ffff8800bfd3e848
>>=20
>> Ensure that rkeys in already-marshalled RPC/RDMA headers are
>> refreshed after the QP has been replaced by a reconnect.
>>=20
>> BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D249
>> Suggested-by: Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/rpc_rdma.c  |   75 ++++++++++++++++++++---------=
----------
>> net/sunrpc/xprtrdma/transport.c |   11 +++---
>> net/sunrpc/xprtrdma/xprt_rdma.h |   10 +++++
>> 3 files changed, 54 insertions(+), 42 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index 693966d..54422f7 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -53,14 +53,6 @@
>> # define RPCDBG_FACILITY	RPCDBG_TRANS
>> #endif
>>=20
>> -enum rpcrdma_chunktype {
>> -	rpcrdma_noch =3D 0,
>> -	rpcrdma_readch,
>> -	rpcrdma_areadch,
>> -	rpcrdma_writech,
>> -	rpcrdma_replych
>> -};
>> -
>> #ifdef RPC_DEBUG
>> static const char transfertypes[][12] =3D {
>> 	"pure inline",	/* no chunks */
>> @@ -286,6 +278,28 @@ out:
>> }
>>=20
>> /*
>> + * Marshal chunks. This routine returns the header length
>> + * consumed by marshaling.
>> + *
>> + * Returns positive RPC/RDMA header size, or negative errno.
>> + */
>> +
>> +ssize_t
>> +rpcrdma_marshal_chunks(struct rpc_rqst *rqst, ssize_t result)
>> +{
>> +	struct rpcrdma_req *req =3D rpcr_to_rdmar(rqst);
>> +	struct rpcrdma_msg *headerp =3D (struct rpcrdma_msg *)req->rl_base=
;
>> +
>> +	if (req->rl_rtype !=3D rpcrdma_noch)
>> +		result =3D rpcrdma_create_chunks(rqst, &rqst->rq_snd_buf,
>> +					       headerp, req->rl_rtype);
>> +	else if (req->rl_wtype !=3D rpcrdma_noch)
>> +		result =3D rpcrdma_create_chunks(rqst, &rqst->rq_rcv_buf,
>> +					       headerp, req->rl_wtype);
>> +	return result;
>> +}
>> +
>> +/*
>>  * Copy write data inline.
>>  * This function is used for "small" requests. Data which is passed
>>  * to RPC via iovecs (or page list) is copied directly into the
>> @@ -377,7 +391,6 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 	char *base;
>> 	size_t rpclen, padlen;
>> 	ssize_t hdrlen;
>> -	enum rpcrdma_chunktype rtype, wtype;
>> 	struct rpcrdma_msg *headerp;
>>=20
>> 	/*
>> @@ -415,13 +428,13 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 	 * into pages; otherwise use reply chunks.
>> 	 */
>> 	if (rqst->rq_rcv_buf.buflen <=3D RPCRDMA_INLINE_READ_THRESHOLD(rqst=
))
>> -		wtype =3D rpcrdma_noch;
>> +		req->rl_wtype =3D rpcrdma_noch;
>> 	else if (rqst->rq_rcv_buf.page_len =3D=3D 0)
>> -		wtype =3D rpcrdma_replych;
>> +		req->rl_wtype =3D rpcrdma_replych;
>> 	else if (rqst->rq_rcv_buf.flags & XDRBUF_READ)
>> -		wtype =3D rpcrdma_writech;
>> +		req->rl_wtype =3D rpcrdma_writech;
>> 	else
>> -		wtype =3D rpcrdma_replych;
>> +		req->rl_wtype =3D rpcrdma_replych;
>>=20
>> 	/*
>> 	 * Chunks needed for arguments?
>> @@ -438,16 +451,16 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 	 * TBD check NFSv4 setacl
>> 	 */
>> 	if (rqst->rq_snd_buf.len <=3D RPCRDMA_INLINE_WRITE_THRESHOLD(rqst))
>> -		rtype =3D rpcrdma_noch;
>> +		req->rl_rtype =3D rpcrdma_noch;
>> 	else if (rqst->rq_snd_buf.page_len =3D=3D 0)
>> -		rtype =3D rpcrdma_areadch;
>> +		req->rl_rtype =3D rpcrdma_areadch;
>> 	else
>> -		rtype =3D rpcrdma_readch;
>> +		req->rl_rtype =3D rpcrdma_readch;
>>=20
>> 	/* The following simplification is not true forever */
>> -	if (rtype !=3D rpcrdma_noch && wtype =3D=3D rpcrdma_replych)
>> -		wtype =3D rpcrdma_noch;
>> -	if (rtype !=3D rpcrdma_noch && wtype !=3D rpcrdma_noch) {
>> +	if (req->rl_rtype !=3D rpcrdma_noch && req->rl_wtype =3D=3D rpcrdm=
a_replych)
>> +		req->rl_wtype =3D rpcrdma_noch;
>> +	if (req->rl_rtype !=3D rpcrdma_noch && req->rl_wtype !=3D rpcrdma_=
noch) {
>> 		dprintk("RPC:       %s: cannot marshal multiple chunk lists\n",
>> 			__func__);
>=20
> Is this still a simplification,

Yes.

I asked Tom Talpey for some clarification of his shorthand.

Generic RPC/RDMA allows an RPC/RDMA header to contain multiple chunk
lists. A chunk list is a vector of memory locations used during an
RDMA READ or WRITE. Only RPC operations that might carry a large
payload would use chunk lists.

However, NFSv2 and NFSv3 operations (particularly READ and WRITE,
which potentially carry large payloads) never need more than a single
chunk list. This is because there are no NFS operations that ever
move large amounts of data in both directions at once: either the
NFS call is large and the NFS reply is small, or vice versa.

This logic ensures there is no more than one chunk list in each
RPC/RDMA header, since NFS is the only RPC consumer that uses the
kernel=92s RPC/RDMA transport and that might require chunk lists.

That simplifies the marshaling logic, but it is no longer generic;
it works specifically for our in-kernel NFS client implementation.

> and is it still "not true forever=94?

Yes.

NFSv4 so far has been modeled after NFSv2 and NFSv3, in that compounds
that do reads and writes bear only one READ or WRITE operation (either
of which would use a single chunk list). If someday the NFS client was
modified to perform multiple READ or WRITE operations per compound,
this simplification would no longer be valid for NFSv4, since a
compound could employ more than one chunk list (one for each READ or
WRITE operation in the compound).


> Anna
>=20
>> 		return -EIO;
>> @@ -461,7 +474,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 	 * When padding is in use and applies to the transfer, insert
>> 	 * it and change the message type.
>> 	 */
>> -	if (rtype =3D=3D rpcrdma_noch) {
>> +	if (req->rl_rtype =3D=3D rpcrdma_noch) {
>>=20
>> 		padlen =3D rpcrdma_inline_pullup(rqst,
>> 						RPCRDMA_INLINE_PAD_VALUE(rqst));
>> @@ -476,7 +489,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 			headerp->rm_body.rm_padded.rm_pempty[1] =3D xdr_zero;
>> 			headerp->rm_body.rm_padded.rm_pempty[2] =3D xdr_zero;
>> 			hdrlen +=3D 2 * sizeof(u32); /* extra words in padhdr */
>> -			if (wtype !=3D rpcrdma_noch) {
>> +			if (req->rl_wtype !=3D rpcrdma_noch) {
>> 				dprintk("RPC:       %s: invalid chunk list\n",
>> 					__func__);
>> 				return -EIO;
>> @@ -497,30 +510,18 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 			 * on receive. Therefore, we request a reply chunk
>> 			 * for non-writes wherever feasible and efficient.
>> 			 */
>> -			if (wtype =3D=3D rpcrdma_noch)
>> -				wtype =3D rpcrdma_replych;
>> +			if (req->rl_wtype =3D=3D rpcrdma_noch)
>> +				req->rl_wtype =3D rpcrdma_replych;
>> 		}
>> 	}
>>=20
>> -	/*
>> -	 * Marshal chunks. This routine will return the header length
>> -	 * consumed by marshaling.
>> -	 */
>> -	if (rtype !=3D rpcrdma_noch) {
>> -		hdrlen =3D rpcrdma_create_chunks(rqst,
>> -					&rqst->rq_snd_buf, headerp, rtype);
>> -		wtype =3D rtype;	/* simplify dprintk */
>> -
>> -	} else if (wtype !=3D rpcrdma_noch) {
>> -		hdrlen =3D rpcrdma_create_chunks(rqst,
>> -					&rqst->rq_rcv_buf, headerp, wtype);
>> -	}
>> +	hdrlen =3D rpcrdma_marshal_chunks(rqst, hdrlen);
>> 	if (hdrlen < 0)
>> 		return hdrlen;
>>=20
>> 	dprintk("RPC:       %s: %s: hdrlen %zd rpclen %zd padlen %zd"
>> 		" headerp 0x%p base 0x%p lkey 0x%x\n",
>> -		__func__, transfertypes[wtype], hdrlen, rpclen, padlen,
>> +		__func__, transfertypes[req->rl_wtype], hdrlen, rpclen, padlen,
>> 		headerp, base, req->rl_iov.lkey);
>>=20
>> 	/*
>> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/t=
ransport.c
>> index 4185102..f6d280b 100644
>> --- a/net/sunrpc/xprtrdma/transport.c
>> +++ b/net/sunrpc/xprtrdma/transport.c
>> @@ -597,13 +597,14 @@ xprt_rdma_send_request(struct rpc_task *task)
>> 	struct rpc_xprt *xprt =3D rqst->rq_xprt;
>> 	struct rpcrdma_req *req =3D rpcr_to_rdmar(rqst);
>> 	struct rpcrdma_xprt *r_xprt =3D rpcx_to_rdmax(xprt);
>> -	int rc;
>> +	int rc =3D 0;
>>=20
>> -	if (req->rl_niovs =3D=3D 0) {
>> +	if (req->rl_niovs =3D=3D 0)
>> 		rc =3D rpcrdma_marshal_req(rqst);
>> -		if (rc < 0)
>> -			goto failed_marshal;
>> -	}
>> +	else if (r_xprt->rx_ia.ri_memreg_strategy =3D=3D RPCRDMA_FRMR)
>> +		rc =3D rpcrdma_marshal_chunks(rqst, 0);
>> +	if (rc < 0)
>> +		goto failed_marshal;
>>=20
>> 	if (req->rl_reply =3D=3D NULL) 		/* e.g. reconnection */
>> 		rpcrdma_recv_buffer_get(req);
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index f3d86b2..c270e59 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -99,6 +99,14 @@ struct rpcrdma_ep {
>> #define INIT_CQCOUNT(ep) atomic_set(&(ep)->rep_cqcount, (ep)->rep_cq=
init)
>> #define DECR_CQCOUNT(ep) atomic_sub_return(1, &(ep)->rep_cqcount)
>>=20
>> +enum rpcrdma_chunktype {
>> +	rpcrdma_noch =3D 0,
>> +	rpcrdma_readch,
>> +	rpcrdma_areadch,
>> +	rpcrdma_writech,
>> +	rpcrdma_replych
>> +};
>> +
>> /*
>>  * struct rpcrdma_rep -- this structure encapsulates state required =
to recv
>>  * and complete a reply, asychronously. It needs several pieces of
>> @@ -192,6 +200,7 @@ struct rpcrdma_req {
>> 	unsigned int	rl_niovs;	/* 0, 2 or 4 */
>> 	unsigned int	rl_nchunks;	/* non-zero if chunks */
>> 	unsigned int	rl_connect_cookie;	/* retry detection */
>> +	enum rpcrdma_chunktype	rl_rtype, rl_wtype;
>> 	struct rpcrdma_buffer *rl_buffer; /* home base for this structure *=
/
>> 	struct rpcrdma_rep	*rl_reply;/* holder for reply buffer */
>> 	struct rpcrdma_mr_seg rl_segments[RPCRDMA_MAX_SEGS];/* chunk segmen=
ts */
>> @@ -347,6 +356,7 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *)=
;
>> /*
>>  * RPC/RDMA protocol calls - xprtrdma/rpc_rdma.c
>>  */
>> +ssize_t rpcrdma_marshal_chunks(struct rpc_rqst *, ssize_t);
>> int rpcrdma_marshal_req(struct rpc_rqst *);
>> size_t rpcrdma_max_payload(struct rpcrdma_xprt *);
>>=20
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
