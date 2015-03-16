From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 12/16] xprtrdma: Acquire FMRs in rpcrdma_fmr_register_external()
Date: Mon, 16 Mar 2015 10:03:34 -0700
Message-ID: <B60B5333-7A78-4A11-8070-C1AC7C9E3F7A@oracle.com>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212825.22783.51384.stgit@manet.1015granger.net> <5506CC6C.8090106@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5506CC6C.8090106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mar 16, 2015, at 5:28 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 3/13/2015 11:28 PM, Chuck Lever wrote:
>> Acquiring 64 FMRs in rpcrdma_buffer_get() while holding the buffer
>> pool lock is expensive, and unnecessary because FMR mode can
>> transfer up to a 1MB payload using just a single ib_fmr.
>>=20
>> Instead, acquire ib_fmrs one-at-a-time as chunks are registered, and
>> return them to rb_mws immediately during deregistration.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/fmr_ops.c   |   41 ++++++++++++++++++++++++++++=
++++++++---
>>  net/sunrpc/xprtrdma/verbs.c     |   41 ++++++++++++++--------------=
-----------
>>  net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
>>  3 files changed, 54 insertions(+), 29 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index 96e6cd3..9c6c2e8 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -28,10 +28,11 @@ __fmr_unmap(struct rpcrdma_xprt *r_xprt, struct =
rpcrdma_mr_seg *seg)
>>  {
>>  	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>  	struct rpcrdma_mr_seg *seg1 =3D seg;
>> +	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>>  	int rc, nsegs =3D seg->mr_nsegs;
>>  	LIST_HEAD(l);
>>=20
>> -	list_add(&seg1->rl_mw->r.fmr->list, &l);
>> +	list_add(&mw->r.fmr->list, &l);
>>  	rc =3D ib_unmap_fmr(&l);
>>  	read_lock(&ia->ri_qplock);
>>  	while (seg1->mr_nsegs--)
>> @@ -39,11 +40,14 @@ __fmr_unmap(struct rpcrdma_xprt *r_xprt, struct =
rpcrdma_mr_seg *seg)
>>  	read_unlock(&ia->ri_qplock);
>>  	if (rc)
>>  		goto out_err;
>> +out:
>> +	seg1->rl_mw =3D NULL;
>> +	rpcrdma_put_mw(r_xprt, mw);
>>  	return nsegs;
>>=20
>>  out_err:
>>  	dprintk("RPC:       %s: ib_unmap_fmr status %i\n", __func__, rc);
>> -	return nsegs;
>> +	goto out;
>>  }
>>=20
>>  static int
>> @@ -117,6 +121,27 @@ out_fmr_err:
>>  	return rc;
>>  }
>>=20
>> +static struct rpcrdma_mw *
>> +__fmr_get_mw(struct rpcrdma_xprt *r_xprt)
>=20
> This introduces an asymmetric approach where you have fmr/frwr get_mw
> routines but have a single rpcrdma_put_mw. I noticed that the
> frwr_get_mw (next patch) is almost completely different - but I wande=
r
> if that should really be that different?

=46MR doesn=92t need to deal with asynchronous LOCAL_INV getting flushe=
d
when the transport disconnects.

I will explain this further in response to 13/16.

> Just raising the question.
>=20
>> +{
>> +	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> +	struct rpcrdma_mw *mw =3D NULL;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&buf->rb_lock, flags);
>> +
>> +	if (!list_empty(&buf->rb_mws)) {
>> +		mw =3D list_entry(buf->rb_mws.next,
>> +				struct rpcrdma_mw, mw_list);
>> +		list_del_init(&mw->mw_list);
>> +	} else {
>> +		pr_err("RPC:       %s: no MWs available\n", __func__);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&buf->rb_lock, flags);
>> +	return mw;
>> +}
>> +
>>  /* Use the ib_map_phys_fmr() verb to register a memory region
>>   * for remote access via RDMA READ or RDMA WRITE.
>>   */
>> @@ -126,10 +151,18 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct=
 rpcrdma_mr_seg *seg,
>>  {
>>  	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>  	struct rpcrdma_mr_seg *seg1 =3D seg;
>> -	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>> +	struct rpcrdma_mw *mw;
>>  	u64 physaddrs[RPCRDMA_MAX_DATA_SEGS];
>>  	int len, pageoff, i, rc;
>>=20
>> +	mw =3D __fmr_get_mw(r_xprt);
>> +	if (!mw)
>> +		return -ENOMEM;
>> +	if (seg1->rl_mw) {
>> +		rpcrdma_put_mw(r_xprt, seg1->rl_mw);
>> +		seg1->rl_mw =3D NULL;
>> +	}
>> +
>=20
> How can this happen? getting to op_map with existing rl_mw? and
> wouldn't it be better to use rl_mw instead of getting a new mw and
> putting seg1->rl_mw?
>=20
>>  	pageoff =3D offset_in_page(seg1->mr_offset);
>>  	seg1->mr_offset -=3D pageoff;	/* start of page */
>>  	seg1->mr_len +=3D pageoff;
>> @@ -152,6 +185,7 @@ fmr_op_map(struct rpcrdma_xprt *r_xprt, struct r=
pcrdma_mr_seg *seg,
>>  	if (rc)
>>  		goto out_maperr;
>>=20
>> +	seg1->rl_mw =3D mw;
>>  	seg1->mr_rkey =3D mw->r.fmr->rkey;
>>  	seg1->mr_base =3D seg1->mr_dma + pageoff;
>>  	seg1->mr_nsegs =3D i;
>> @@ -164,6 +198,7 @@ out_maperr:
>>  		pageoff, i, rc);
>>  	while (i--)
>>  		rpcrdma_unmap_one(ia, --seg);
>> +	rpcrdma_put_mw(r_xprt, mw);
>>  	return rc;
>>  }
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index f108a57..f2316d8 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -1171,6 +1171,21 @@ rpcrdma_buffer_destroy(struct rpcrdma_buffer =
*buf)
>>  	kfree(buf->rb_pool);
>>  }
>>=20
>> +void
>> +rpcrdma_put_mw(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
>> +{
>> +	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> +	unsigned long flags;
>> +
>> +	if (!list_empty(&mw->mw_list))
>> +		pr_warn("RPC:       %s: mw %p still on a list!\n",
>> +			__func__, mw);
>> +
>> +	spin_lock_irqsave(&buf->rb_lock, flags);
>> +	list_add_tail(&mw->mw_list, &buf->rb_mws);
>> +	spin_unlock_irqrestore(&buf->rb_lock, flags);
>> +}
>> +
>>  /* "*mw" can be NULL when rpcrdma_buffer_get_mrs() fails, leaving
>>   * some req segments uninitialized.
>>   */
>> @@ -1292,28 +1307,6 @@ rpcrdma_buffer_get_frmrs(struct rpcrdma_req *=
req, struct rpcrdma_buffer *buf,
>>  	return NULL;
>>  }
>>=20
>> -static struct rpcrdma_req *
>> -rpcrdma_buffer_get_fmrs(struct rpcrdma_req *req, struct rpcrdma_buf=
fer *buf)
>> -{
>> -	struct rpcrdma_mw *r;
>> -	int i;
>> -
>> -	i =3D RPCRDMA_MAX_SEGS - 1;
>> -	while (!list_empty(&buf->rb_mws)) {
>> -		r =3D list_entry(buf->rb_mws.next,
>> -			       struct rpcrdma_mw, mw_list);
>> -		list_del(&r->mw_list);
>> -		req->rl_segments[i].rl_mw =3D r;
>> -		if (unlikely(i-- =3D=3D 0))
>> -			return req;	/* Success */
>> -	}
>> -
>> -	/* Not enough entries on rb_mws for this req */
>> -	rpcrdma_buffer_put_sendbuf(req, buf);
>> -	rpcrdma_buffer_put_mrs(req, buf);
>> -	return NULL;
>> -}
>> -
>>  /*
>>   * Get a set of request/reply buffers.
>>   *
>> @@ -1355,9 +1348,6 @@ rpcrdma_buffer_get(struct rpcrdma_buffer *buff=
ers)
>>  	case RPCRDMA_FRMR:
>>  		req =3D rpcrdma_buffer_get_frmrs(req, buffers, &stale);
>>  		break;
>> -	case RPCRDMA_MTHCAFMR:
>> -		req =3D rpcrdma_buffer_get_fmrs(req, buffers);
>> -		break;
>>  	default:
>>  		break;
>>  	}
>> @@ -1382,7 +1372,6 @@ rpcrdma_buffer_put(struct rpcrdma_req *req)
>>  	rpcrdma_buffer_put_sendbuf(req, buffers);
>>  	switch (ia->ri_memreg_strategy) {
>>  	case RPCRDMA_FRMR:
>> -	case RPCRDMA_MTHCAFMR:
>>  		rpcrdma_buffer_put_mrs(req, buffers);
>>  		break;
>>  	default:
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index 40a0ee8..d5aa5b4 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -426,6 +426,7 @@ void rpcrdma_free_regbuf(struct rpcrdma_ia *,
>>  unsigned int rpcrdma_max_segments(struct rpcrdma_xprt *);
>>  void rpcrdma_map_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *, =
bool);
>>  void rpcrdma_unmap_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *=
);
>> +void rpcrdma_put_mw(struct rpcrdma_xprt *, struct rpcrdma_mw *);
>>=20
>>  /*
>>   * RPC/RDMA connection management calls - xprtrdma/rpc_rdma.c
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
