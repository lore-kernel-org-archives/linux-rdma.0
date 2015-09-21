From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 05/18] xprtrdma: Replace send and receive arrays
Date: Mon, 21 Sep 2015 16:04:28 -0700
Message-ID: <B217F6DC-F6B6-4544-91DB-B4CF2370617C@oracle.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net> <20150917204452.19671.66113.stgit@manet.1015granger.net> <55FE8FEE.1010006@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55FE8FEE.1010006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Sep 20, 2015, at 3:52 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>=20
> On 9/17/2015 11:44 PM, Chuck Lever wrote:
>> The rb_send_bufs and rb_recv_bufs arrays are used to implement a
>> pair of stacks for keeping track of free rpcrdma_req and rpcrdma_rep
>> structs. Replace those arrays with free lists.
>>=20
>> To allow more than 512 RPCs in-flight at once, each of these arrays
>> would be larger than a page (assuming 8-byte addresses and 4KB
>> pages). Allowing up to 64K in-flight RPCs (as TCP now does), each
>> buffer array would have to be 128 pages. That's an order-6
>> allocation. (Not that we're going there.)
>>=20
>> A list is easier to expand dynamically. Instead of allocating a
>> larger array of pointers and copying the existing pointers to the
>> new array, simply append more buffers to each list.
>>=20
>> This also makes it simpler to manage receive buffers that might
>> catch backwards-direction calls, or to post receive buffers in
>> bulk to amortize the overhead of ib_post_recv.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Hi Chuck,
>=20
> I get the idea of this patch, but it is a bit confusing (to a
> non-educated reader).

OK, let=E2=80=99s see if there=E2=80=99s room for additional improvemen=
t.


> Can you explain why sometimes you call put/get_locked routines
> and sometimes you open-code them?

Are you talking about the later patch that adds support for
receiving backwards calls? That probably should use the
existing helpers, shouldn=E2=80=99t it.


> And is it mandatory to have
> the callers lock before calling get/put? Perhaps the code would
> be simpler if the get/put routines would take care of locking
> since rb_lock looks dedicated to them.

Not sure I understand this comment, I thought that the helpers
were already doing the locking.


>=20
>> ---
>>  net/sunrpc/xprtrdma/verbs.c     |  141 +++++++++++++++++-----------=
-----------
>>  net/sunrpc/xprtrdma/xprt_rdma.h |    9 +-
>>  2 files changed, 66 insertions(+), 84 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index ac1345b..8d99214 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -962,44 +962,18 @@ rpcrdma_buffer_create(struct rpcrdma_xprt *r_x=
prt)
>>  {
>>  	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>>  	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> -	struct rpcrdma_create_data_internal *cdata =3D &r_xprt->rx_data;
>> -	char *p;
>> -	size_t len;
>>  	int i, rc;
>>=20
>> -	buf->rb_max_requests =3D cdata->max_requests;
>> +	buf->rb_max_requests =3D r_xprt->rx_data.max_requests;
>>  	spin_lock_init(&buf->rb_lock);
>>=20
>> -	/* Need to allocate:
>> -	 *   1.  arrays for send and recv pointers
>> -	 *   2.  arrays of struct rpcrdma_req to fill in pointers
>> -	 *   3.  array of struct rpcrdma_rep for replies
>> -	 * Send/recv buffers in req/rep need to be registered
>> -	 */
>> -	len =3D buf->rb_max_requests *
>> -		(sizeof(struct rpcrdma_req *) + sizeof(struct rpcrdma_rep *));
>> -
>> -	p =3D kzalloc(len, GFP_KERNEL);
>> -	if (p =3D=3D NULL) {
>> -		dprintk("RPC:       %s: req_t/rep_t/pad kzalloc(%zd) failed\n",
>> -			__func__, len);
>> -		rc =3D -ENOMEM;
>> -		goto out;
>> -	}
>> -	buf->rb_pool =3D p;	/* for freeing it later */
>> -
>> -	buf->rb_send_bufs =3D (struct rpcrdma_req **) p;
>> -	p =3D (char *) &buf->rb_send_bufs[buf->rb_max_requests];
>> -	buf->rb_recv_bufs =3D (struct rpcrdma_rep **) p;
>> -	p =3D (char *) &buf->rb_recv_bufs[buf->rb_max_requests];
>> -
>>  	rc =3D ia->ri_ops->ro_init(r_xprt);
>>  	if (rc)
>>  		goto out;
>>=20
>> +	INIT_LIST_HEAD(&buf->rb_send_bufs);
>>  	for (i =3D 0; i < buf->rb_max_requests; i++) {
>>  		struct rpcrdma_req *req;
>> -		struct rpcrdma_rep *rep;
>>=20
>>  		req =3D rpcrdma_create_req(r_xprt);
>>  		if (IS_ERR(req)) {
>> @@ -1008,7 +982,12 @@ rpcrdma_buffer_create(struct rpcrdma_xprt *r_x=
prt)
>>  			rc =3D PTR_ERR(req);
>>  			goto out;
>>  		}
>> -		buf->rb_send_bufs[i] =3D req;
>> +		list_add(&req->rl_free, &buf->rb_send_bufs);
>> +	}
>> +
>> +	INIT_LIST_HEAD(&buf->rb_recv_bufs);
>> +	for (i =3D 0; i < buf->rb_max_requests + 2; i++) {
>> +		struct rpcrdma_rep *rep;
>>=20
>>  		rep =3D rpcrdma_create_rep(r_xprt);
>>  		if (IS_ERR(rep)) {
>> @@ -1017,7 +996,7 @@ rpcrdma_buffer_create(struct rpcrdma_xprt *r_xp=
rt)
>>  			rc =3D PTR_ERR(rep);
>>  			goto out;
>>  		}
>> -		buf->rb_recv_bufs[i] =3D rep;
>> +		list_add(&rep->rr_list, &buf->rb_recv_bufs);
>>  	}
>>=20
>>  	return 0;
>> @@ -1051,25 +1030,26 @@ void
>>  rpcrdma_buffer_destroy(struct rpcrdma_buffer *buf)
>>  {
>>  	struct rpcrdma_ia *ia =3D rdmab_to_ia(buf);
>> -	int i;
>>=20
>> -	/* clean up in reverse order from create
>> -	 *   1.  recv mr memory (mr free, then kfree)
>> -	 *   2.  send mr memory (mr free, then kfree)
>> -	 *   3.  MWs
>> -	 */
>> -	dprintk("RPC:       %s: entering\n", __func__);
>> +	while (!list_empty(&buf->rb_recv_bufs)) {
>> +		struct rpcrdma_rep *rep =3D list_entry(buf->rb_recv_bufs.next,
>> +						     struct rpcrdma_rep,
>> +						     rr_list);
>>=20
>> -	for (i =3D 0; i < buf->rb_max_requests; i++) {
>> -		if (buf->rb_recv_bufs)
>> -			rpcrdma_destroy_rep(ia, buf->rb_recv_bufs[i]);
>> -		if (buf->rb_send_bufs)
>> -			rpcrdma_destroy_req(ia, buf->rb_send_bufs[i]);
>> +		list_del(&rep->rr_list);
>> +		rpcrdma_destroy_rep(ia, rep);
>>  	}
>>=20
>> -	ia->ri_ops->ro_destroy(buf);
>> +	while (!list_empty(&buf->rb_send_bufs)) {
>> +		struct rpcrdma_req *req =3D list_entry(buf->rb_send_bufs.next,
>> +						     struct rpcrdma_req,
>> +						     rl_free);
>>=20
>> -	kfree(buf->rb_pool);
>> +		list_del(&req->rl_free);
>> +		rpcrdma_destroy_req(ia, req);
>> +	}
>> +
>> +	ia->ri_ops->ro_destroy(buf);
>>  }
>>=20
>>  struct rpcrdma_mw *
>> @@ -1102,24 +1082,27 @@ rpcrdma_put_mw(struct rpcrdma_xprt *r_xprt, =
struct rpcrdma_mw *mw)
>>  }
>>=20
>>  static void
>> -rpcrdma_buffer_put_sendbuf(struct rpcrdma_req *req, struct rpcrdma_=
buffer *buf)
>> +rpcrdma_buffer_put_locked(struct rpcrdma_rep *rep, struct rpcrdma_b=
uffer *buf)
>>  {
>> -	buf->rb_send_bufs[--buf->rb_send_index] =3D req;
>> -	req->rl_niovs =3D 0;
>> -	if (req->rl_reply) {
>> -		buf->rb_recv_bufs[--buf->rb_recv_index] =3D req->rl_reply;
>> -		req->rl_reply =3D NULL;
>> -	}
>> +	list_add_tail(&rep->rr_list, &buf->rb_recv_bufs);
>> +}
>> +
>> +static struct rpcrdma_rep *
>> +rpcrdma_buffer_get_locked(struct rpcrdma_buffer *buf)
>> +{
>> +	struct rpcrdma_rep *rep;
>> +
>> +	rep =3D list_first_entry(&buf->rb_recv_bufs,
>> +			       struct rpcrdma_rep, rr_list);
>> +	list_del(&rep->rr_list);
>> +
>> +	return rep;
>>  }
>=20
> There seems to be a distinction between send/recv buffers. Would it
> make sense to have a symmetric handling for both send/recv buffers?

Or maybe the same helpers could handle both. I=E2=80=99ll have a look
when I get back from SNIA SDC.


>>  /*
>>   * Get a set of request/reply buffers.
>>   *
>> - * Reply buffer (if needed) is attached to send buffer upon return.
>> - * Rule:
>> - *    rb_send_index and rb_recv_index MUST always be pointing to th=
e
>> - *    *next* available buffer (non-NULL). They are incremented afte=
r
>> - *    removing buffers, and decremented *before* returning them.
>> + * Reply buffer (if available) is attached to send buffer upon retu=
rn.
>>   */
>>  struct rpcrdma_req *
>>  rpcrdma_buffer_get(struct rpcrdma_buffer *buffers)
>> @@ -1129,25 +1112,22 @@ rpcrdma_buffer_get(struct rpcrdma_buffer *bu=
ffers)
>>=20
>>  	spin_lock_irqsave(&buffers->rb_lock, flags);
>>=20
>> -	if (buffers->rb_send_index =3D=3D buffers->rb_max_requests) {
>> +	if (list_empty(&buffers->rb_send_bufs)) {
>>  		spin_unlock_irqrestore(&buffers->rb_lock, flags);
>> -		dprintk("RPC:       %s: out of request buffers\n", __func__);
>> -		return ((struct rpcrdma_req *)NULL);
>> -	}
>> -
>> -	req =3D buffers->rb_send_bufs[buffers->rb_send_index];
>> -	if (buffers->rb_send_index < buffers->rb_recv_index) {
>> -		dprintk("RPC:       %s: %d extra receives outstanding (ok)\n",
>> -			__func__,
>> -			buffers->rb_recv_index - buffers->rb_send_index);
>> -		req->rl_reply =3D NULL;
>> -	} else {
>> -		req->rl_reply =3D buffers->rb_recv_bufs[buffers->rb_recv_index];
>> -		buffers->rb_recv_bufs[buffers->rb_recv_index++] =3D NULL;
>> +		pr_warn("RPC:       %s: out of request buffers\n", __func__);
>> +		return NULL;
>>  	}
>> -	buffers->rb_send_bufs[buffers->rb_send_index++] =3D NULL;
>> +	req =3D list_first_entry(&buffers->rb_send_bufs,
>> +			       struct rpcrdma_req, rl_free);
>> +	list_del(&req->rl_free);
>>=20
>> +	req->rl_reply =3D NULL;
>> +	if (!list_empty(&buffers->rb_recv_bufs))
>> +		req->rl_reply =3D rpcrdma_buffer_get_locked(buffers);
>=20
> Would it make sense to check !list_empty() inside _get_locked and han=
dle
> a possible NULL return?
>=20
>>  	spin_unlock_irqrestore(&buffers->rb_lock, flags);
>> +
>> +	if (!req->rl_reply)
>> +		pr_warn("RPC:       %s: out of reply buffers\n", __func__);
>>  	return req;
>>  }
>>=20
>> @@ -1159,17 +1139,22 @@ void
>>  rpcrdma_buffer_put(struct rpcrdma_req *req)
>>  {
>>  	struct rpcrdma_buffer *buffers =3D req->rl_buffer;
>> +	struct rpcrdma_rep *rep =3D req->rl_reply;
>>  	unsigned long flags;
>>=20
>> +	req->rl_niovs =3D 0;
>> +	req->rl_reply =3D NULL;
>> +
>>  	spin_lock_irqsave(&buffers->rb_lock, flags);
>> -	rpcrdma_buffer_put_sendbuf(req, buffers);
>> +	list_add_tail(&req->rl_free, &buffers->rb_send_bufs);
>> +	if (rep)
>> +		rpcrdma_buffer_put_locked(rep, buffers);
>>  	spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>  }
>>=20
>>  /*
>>   * Recover reply buffers from pool.
>> - * This happens when recovering from error conditions.
>> - * Post-increment counter/array index.
>> + * This happens when recovering from disconnect.
>>   */
>>  void
>>  rpcrdma_recv_buffer_get(struct rpcrdma_req *req)
>> @@ -1178,10 +1163,8 @@ rpcrdma_recv_buffer_get(struct rpcrdma_req *r=
eq)
>>  	unsigned long flags;
>>=20
>>  	spin_lock_irqsave(&buffers->rb_lock, flags);
>> -	if (buffers->rb_recv_index < buffers->rb_max_requests) {
>> -		req->rl_reply =3D buffers->rb_recv_bufs[buffers->rb_recv_index];
>> -		buffers->rb_recv_bufs[buffers->rb_recv_index++] =3D NULL;
>> -	}
>> +	if (!list_empty(&buffers->rb_recv_bufs))
>> +		req->rl_reply =3D rpcrdma_buffer_get_locked(buffers);
>>  	spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>  }
>>=20
>> @@ -1196,7 +1179,7 @@ rpcrdma_recv_buffer_put(struct rpcrdma_rep *re=
p)
>>  	unsigned long flags;
>>=20
>>  	spin_lock_irqsave(&buffers->rb_lock, flags);
>> -	buffers->rb_recv_bufs[--buffers->rb_recv_index] =3D rep;
>> +	rpcrdma_buffer_put_locked(rep, buffers);
>>  	spin_unlock_irqrestore(&buffers->rb_lock, flags);
>>  }
>>=20
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index a13508b..e6a358f 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -252,6 +252,7 @@ struct rpcrdma_mr_seg {		/* chunk descriptors */
>>  #define RPCRDMA_MAX_IOVS	(2)
>>=20
>>  struct rpcrdma_req {
>> +	struct list_head	rl_free;
>>  	unsigned int		rl_niovs;
>>  	unsigned int		rl_nchunks;
>>  	unsigned int		rl_connect_cookie;
>> @@ -285,12 +286,10 @@ struct rpcrdma_buffer {
>>  	struct list_head	rb_all;
>>  	char			*rb_pool;
>>=20
>> -	spinlock_t		rb_lock;	/* protect buf arrays */
>> +	spinlock_t		rb_lock;	/* protect buf lists */
>> +	struct list_head	rb_send_bufs;
>> +	struct list_head	rb_recv_bufs;
>>  	u32			rb_max_requests;
>> -	int			rb_send_index;
>> -	int			rb_recv_index;
>> -	struct rpcrdma_req	**rb_send_bufs;
>> -	struct rpcrdma_rep	**rb_recv_bufs;
>>  };
>>  #define rdmab_to_ia(b) (&container_of((b), struct rpcrdma_xprt, rx_=
buf)->rx_ia)
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
