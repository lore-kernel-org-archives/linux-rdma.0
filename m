From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 08/16] xprtrdma: Add "reset MRs" memreg op
Date: Tue, 24 Mar 2015 11:10:35 -0400
Message-ID: <C167EA9F-74B3-4725-92B9-3F195D0960DE@oracle.com>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212747.22783.98300.stgit@manet.1015granger.net> <EE7902D3F51F404C82415C4803930ACD5DC3A9E3@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD5DC3A9E3-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mar 24, 2015, at 7:27 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> w=
rote:

>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>> Sent: Saturday, March 14, 2015 2:58 AM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH v1 08/16] xprtrdma: Add "reset MRs" memreg op
>>=20
>> This method is invoked when a transport instance is about to be reco=
nnected.
>> Each Memory Region object is reset to its initial state.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/fmr_ops.c      |   23 ++++++++
>> net/sunrpc/xprtrdma/frwr_ops.c     |   46 ++++++++++++++++
>> net/sunrpc/xprtrdma/physical_ops.c |    6 ++
>> net/sunrpc/xprtrdma/verbs.c        |  103 +-------------------------=
----------
>> net/sunrpc/xprtrdma/xprt_rdma.h    |    1
>> 5 files changed, 78 insertions(+), 101 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index 1501db0..1ccb3de 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -156,10 +156,33 @@ fmr_op_unmap(struct rpcrdma_xprt *r_xprt, stru=
ct
>> rpcrdma_req *req,
>> 		i +=3D __fmr_unmap(r_xprt, &req->rl_segments[i]);  }
>>=20
>> +/* After a disconnect, unmap all FMRs.
>> + *
>> + * This is invoked only in the transport connect worker in order
>> + * to serialize with rpcrdma_register_fmr_external().
>> + */
>> +static void
>> +fmr_op_reset(struct rpcrdma_xprt *r_xprt) {
>> +	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> +	struct rpcrdma_mw *r;
>> +	LIST_HEAD(list);
>> +	int rc;
>> +
>> +	list_for_each_entry(r, &buf->rb_all, mw_all)
>> +		list_add(&r->r.fmr->list, &list);
>> +
>> +	rc =3D ib_unmap_fmr(&list);
>> +	if (rc)
>> +		dprintk("RPC:       %s: ib_unmap_fmr failed %i\n",
>> +			__func__, rc);
>> +}
>> +
>> const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops =3D {
>> 	.ro_map				=3D fmr_op_map,
>> 	.ro_unmap			=3D fmr_op_unmap,
>> 	.ro_maxpages			=3D fmr_op_maxpages,
>> 	.ro_init			=3D fmr_op_init,
>> +	.ro_reset			=3D fmr_op_reset,
>> 	.ro_displayname			=3D "fmr",
>> };
>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/fr=
wr_ops.c
>> index 975372c..b4ce0e5 100644
>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>> @@ -81,6 +81,18 @@ out_err:
>> 	return nsegs;
>> }
>>=20
>> +static void
>> +__frwr_release(struct rpcrdma_mw *r)
>> +{
>> +	int rc;
>> +
>> +	rc =3D ib_dereg_mr(r->r.frmr.fr_mr);
>> +	if (rc)
>> +		dprintk("RPC:       %s: ib_dereg_mr status %i\n",
>> +			__func__, rc);
>> +	ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
>> +}
>> +
>> /* FRWR mode conveys a list of pages per chunk segment. The
>>  * maximum length of that list is the FRWR page list depth.
>>  */
>> @@ -226,10 +238,44 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, str=
uct
>> rpcrdma_req *req,
>> 		i +=3D __frwr_unmap(r_xprt, &req->rl_segments[i]);  }
>>=20
>> +/* After a disconnect, a flushed FAST_REG_MR can leave an FRMR in
>> + * an unusable state. Find FRMRs in this state and dereg / reg
>> + * each.  FRMRs that are VALID and attached to an rpcrdma_req are
>> + * also torn down.
>> + *
>> + * This gives all in-use FRMRs a fresh rkey and leaves them INVALID=
=2E
>> + *
>> + * This is invoked only in the transport connect worker in order
>> + * to serialize with rpcrdma_register_frmr_external().
>> + */
>> +static void
>> +frwr_op_reset(struct rpcrdma_xprt *r_xprt) {
>> +	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> +	struct ib_device *device =3D r_xprt->rx_ia.ri_id->device;
>> +	unsigned int depth =3D r_xprt->rx_ia.ri_max_frmr_depth;
>> +	struct ib_pd *pd =3D r_xprt->rx_ia.ri_pd;
>> +	struct rpcrdma_mw *r;
>> +	int rc;
>> +
>> +	list_for_each_entry(r, &buf->rb_all, mw_all) {
>> +		if (r->r.frmr.fr_state =3D=3D FRMR_IS_INVALID)
>> +			continue;
>> +
>> +		__frwr_release(r);
>> +		rc =3D __frwr_init(r, pd, device, depth);
>> +		if (rc)
>> +			continue;
>=20
> Should we print something here e.g. "failed to allocate frmr, mount w=
ill work with less number of frmr, performance hit is expected=94?

I can=92t remember why we skip the FRWR in this case. I think the
transport will eventually recover it (if needed, by a second
reconnect).

>> +
>> +		r->r.frmr.fr_state =3D FRMR_IS_INVALID;
>> +	}
>> +}
>> +
>> const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops =3D {
>> 	.ro_map				=3D frwr_op_map,
>> 	.ro_unmap			=3D frwr_op_unmap,
>> 	.ro_maxpages			=3D frwr_op_maxpages,
>> 	.ro_init			=3D frwr_op_init,
>> +	.ro_reset			=3D frwr_op_reset,
>> 	.ro_displayname			=3D "frwr",
>> };
>> diff --git a/net/sunrpc/xprtrdma/physical_ops.c
>> b/net/sunrpc/xprtrdma/physical_ops.c
>> index ae2b0bc..0afc691 100644
>> --- a/net/sunrpc/xprtrdma/physical_ops.c
>> +++ b/net/sunrpc/xprtrdma/physical_ops.c
>> @@ -62,10 +62,16 @@ physical_op_unmap(struct rpcrdma_xprt *r_xprt, s=
truct
>> rpcrdma_req *req,
>> 		rpcrdma_unmap_one(&r_xprt->rx_ia, &req->rl_segments[i]);  }
>>=20
>> +static void
>> +physical_op_reset(struct rpcrdma_xprt *r_xprt) { }
>> +
>> const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops =3D {
>> 	.ro_map				=3D physical_op_map,
>> 	.ro_unmap			=3D physical_op_unmap,
>> 	.ro_maxpages			=3D physical_op_maxpages,
>> 	.ro_init			=3D physical_op_init,
>> +	.ro_reset			=3D physical_op_reset,
>> 	.ro_displayname			=3D "physical",
>> };
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec index
>> d7810d6..e17d91a 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -63,9 +63,6 @@
>> # define RPCDBG_FACILITY	RPCDBG_TRANS
>> #endif
>>=20
>> -static void rpcrdma_reset_frmrs(struct rpcrdma_ia *); -static void
>> rpcrdma_reset_fmrs(struct rpcrdma_ia *);
>> -
>> /*
>>  * internal functions
>>  */
>> @@ -944,21 +941,9 @@ retry:
>> 		rpcrdma_ep_disconnect(ep, ia);
>> 		rpcrdma_flush_cqs(ep);
>>=20
>> -		switch (ia->ri_memreg_strategy) {
>> -		case RPCRDMA_FRMR:
>> -			rpcrdma_reset_frmrs(ia);
>> -			break;
>> -		case RPCRDMA_MTHCAFMR:
>> -			rpcrdma_reset_fmrs(ia);
>> -			break;
>> -		case RPCRDMA_ALLPHYSICAL:
>> -			break;
>> -		default:
>> -			rc =3D -EIO;
>> -			goto out;
>> -		}
>> -
>> 		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>> +		ia->ri_ops->ro_reset(xprt);
>> +
>> 		id =3D rpcrdma_create_id(xprt, ia,
>> 				(struct sockaddr *)&xprt->rx_data.addr);
>> 		if (IS_ERR(id)) {
>> @@ -1288,90 +1273,6 @@ rpcrdma_buffer_destroy(struct rpcrdma_buffer
>> *buf)
>> 	kfree(buf->rb_pool);
>> }
>>=20
>> -/* After a disconnect, unmap all FMRs.
>> - *
>> - * This is invoked only in the transport connect worker in order
>> - * to serialize with rpcrdma_register_fmr_external().
>> - */
>> -static void
>> -rpcrdma_reset_fmrs(struct rpcrdma_ia *ia) -{
>> -	struct rpcrdma_xprt *r_xprt =3D
>> -				container_of(ia, struct rpcrdma_xprt, rx_ia);
>> -	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> -	struct list_head *pos;
>> -	struct rpcrdma_mw *r;
>> -	LIST_HEAD(l);
>> -	int rc;
>> -
>> -	list_for_each(pos, &buf->rb_all) {
>> -		r =3D list_entry(pos, struct rpcrdma_mw, mw_all);
>> -
>> -		INIT_LIST_HEAD(&l);
>> -		list_add(&r->r.fmr->list, &l);
>> -		rc =3D ib_unmap_fmr(&l);
>> -		if (rc)
>> -			dprintk("RPC:       %s: ib_unmap_fmr failed %i\n",
>> -				__func__, rc);
>> -	}
>> -}
>> -
>> -/* After a disconnect, a flushed FAST_REG_MR can leave an FRMR in
>> - * an unusable state. Find FRMRs in this state and dereg / reg
>> - * each.  FRMRs that are VALID and attached to an rpcrdma_req are
>> - * also torn down.
>> - *
>> - * This gives all in-use FRMRs a fresh rkey and leaves them INVALID=
=2E
>> - *
>> - * This is invoked only in the transport connect worker in order
>> - * to serialize with rpcrdma_register_frmr_external().
>> - */
>> -static void
>> -rpcrdma_reset_frmrs(struct rpcrdma_ia *ia) -{
>> -	struct rpcrdma_xprt *r_xprt =3D
>> -				container_of(ia, struct rpcrdma_xprt, rx_ia);
>> -	struct rpcrdma_buffer *buf =3D &r_xprt->rx_buf;
>> -	struct list_head *pos;
>> -	struct rpcrdma_mw *r;
>> -	int rc;
>> -
>> -	list_for_each(pos, &buf->rb_all) {
>> -		r =3D list_entry(pos, struct rpcrdma_mw, mw_all);
>> -
>> -		if (r->r.frmr.fr_state =3D=3D FRMR_IS_INVALID)
>> -			continue;
>> -
>> -		rc =3D ib_dereg_mr(r->r.frmr.fr_mr);
>> -		if (rc)
>> -			dprintk("RPC:       %s: ib_dereg_mr failed %i\n",
>> -				__func__, rc);
>> -		ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
>> -
>> -		r->r.frmr.fr_mr =3D ib_alloc_fast_reg_mr(ia->ri_pd,
>> -					ia->ri_max_frmr_depth);
>> -		if (IS_ERR(r->r.frmr.fr_mr)) {
>> -			rc =3D PTR_ERR(r->r.frmr.fr_mr);
>> -			dprintk("RPC:       %s: ib_alloc_fast_reg_mr"
>> -				" failed %i\n", __func__, rc);
>> -			continue;
>> -		}
>> -		r->r.frmr.fr_pgl =3D ib_alloc_fast_reg_page_list(
>> -					ia->ri_id->device,
>> -					ia->ri_max_frmr_depth);
>> -		if (IS_ERR(r->r.frmr.fr_pgl)) {
>> -			rc =3D PTR_ERR(r->r.frmr.fr_pgl);
>> -			dprintk("RPC:       %s: "
>> -				"ib_alloc_fast_reg_page_list "
>> -				"failed %i\n", __func__, rc);
>> -
>> -			ib_dereg_mr(r->r.frmr.fr_mr);
>> -			continue;
>> -		}
>> -		r->r.frmr.fr_state =3D FRMR_IS_INVALID;
>> -	}
>> -}
>> -
>> /* "*mw" can be NULL when rpcrdma_buffer_get_mrs() fails, leaving
>>  * some req segments uninitialized.
>>  */
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h
>> b/net/sunrpc/xprtrdma/xprt_rdma.h index 4fe3c38..cdf6763 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -342,6 +342,7 @@ struct rpcrdma_memreg_ops {
>> 				    struct rpcrdma_req *, unsigned int);
>> 	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
>> 	int		(*ro_init)(struct rpcrdma_xprt *);
>> +	void		(*ro_reset)(struct rpcrdma_xprt *);
>> 	const char	*ro_displayname;
>> };
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
