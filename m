From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/15] xprtrdma: Clean up rpcrdma_ia_open()
Date: Sun, 26 Jul 2015 14:21:23 -0400
Message-ID: <B8761105-FE4E-4DD4-8E3D-77F30B170ADD@oracle.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190320.10997.40165.stgit@manet.1015granger.net> <20150726165337.GC9273@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150726165337.GC9273-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph-


On Jul 26, 2015, at 12:53 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wro=
te:

> Jason has patches that provide a local_dma_lkey in the PD that is alw=
ays
> available.  Do you need this clean up for the next merge window?  If =
not
> it might be worth to postponed it to avoid merge conflicts, specially
> as I assume the NFS changes will go in through Trond.

No, this patch is not strictly needed in 4.3, but my read of
Jason=92s series is that he does not touch xprtrdma. I don=92t
believe there will be a merge conflict.

The goal of this patch is to move xprtrdma forward so it will
be straightforward to use pd->local_dma_key for RPC send and
receive buffers. That=92s a change that can be added after both
this patch and Jason=92s series is merged.

I prefer keeping this patch separate, because that makes it
simpler to review and test this refactor. I don=92t see a reason
to delay it, but I can do that if it is needed.


> On Mon, Jul 20, 2015 at 03:03:20PM -0400, Chuck Lever wrote:
>> Untangle the end of rpcrdma_ia_open() by moving DMA MR set-up, which
>> is different for each registration method, to the .ro_open functions=
=2E
>>=20
>> This is refactoring only. No behavior change is expected.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/fmr_ops.c      |   19 +++++++++++
>> net/sunrpc/xprtrdma/frwr_ops.c     |    5 +++
>> net/sunrpc/xprtrdma/physical_ops.c |   25 ++++++++++++++-
>> net/sunrpc/xprtrdma/verbs.c        |   60 +++++++++++---------------=
----------
>> net/sunrpc/xprtrdma/xprt_rdma.h    |    3 +-
>> 5 files changed, 67 insertions(+), 45 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index f1e8daf..cb25c89 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -39,6 +39,25 @@ static int
>> fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
>> 	    struct rpcrdma_create_data_internal *cdata)
>> {
>> +	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	struct ib_mr *mr;
>> +
>> +	/* Obtain an lkey to use for the regbufs, which are
>> +	 * protected from remote access.
>> +	 */
>> +	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
>> +		ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
>> +	} else {
>> +		mr =3D ib_get_dma_mr(ia->ri_pd, IB_ACCESS_LOCAL_WRITE);
>> +		if (IS_ERR(mr)) {
>> +			pr_err("%s: ib_get_dma_mr for failed with %lX\n",
>> +			       __func__, PTR_ERR(mr));
>> +			return -ENOMEM;
>> +		}
>> +		ia->ri_dma_lkey =3D ia->ri_dma_mr->lkey;
>> +		ia->ri_dma_mr =3D mr;
>> +	}
>> +
>> 	return 0;
>> }
>>=20
>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/fr=
wr_ops.c
>> index 04ea914..63f282e 100644
>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>> @@ -189,6 +189,11 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcr=
dma_ep *ep,
>> 	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> 	int depth, delta;
>>=20
>> +	/* Obtain an lkey to use for the regbufs, which are
>> +	 * protected from remote access.
>> +	 */
>> +	ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
>> +
>> 	ia->ri_max_frmr_depth =3D
>> 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
>> 			      devattr->max_fast_reg_page_list_len);
>> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdm=
a/physical_ops.c
>> index 41985d0..72cf8b1 100644
>> --- a/net/sunrpc/xprtrdma/physical_ops.c
>> +++ b/net/sunrpc/xprtrdma/physical_ops.c
>> @@ -23,6 +23,29 @@ static int
>> physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
>> 		 struct rpcrdma_create_data_internal *cdata)
>> {
>> +	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	struct ib_mr *mr;
>> +
>> +	/* Obtain an rkey to use for RPC data payloads.
>> +	 */
>> +	mr =3D ib_get_dma_mr(ia->ri_pd,
>> +			   IB_ACCESS_LOCAL_WRITE |
>> +			   IB_ACCESS_REMOTE_WRITE |
>> +			   IB_ACCESS_REMOTE_READ);
>> +	if (IS_ERR(mr)) {
>> +		pr_err("%s: ib_get_dma_mr for failed with %lX\n",
>> +		       __func__, PTR_ERR(mr));
>> +		return -ENOMEM;
>> +	}
>> +	ia->ri_dma_mr =3D mr;
>> +
>> +	/* Obtain an lkey to use for regbufs.
>> +	 */
>> +	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
>> +		ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
>> +	else
>> +		ia->ri_dma_lkey =3D ia->ri_dma_mr->lkey;
>> +
>> 	return 0;
>> }
>>=20
>> @@ -51,7 +74,7 @@ physical_op_map(struct rpcrdma_xprt *r_xprt, struc=
t rpcrdma_mr_seg *seg,
>> 	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>=20
>> 	rpcrdma_map_one(ia->ri_device, seg, rpcrdma_data_dir(writing));
>> -	seg->mr_rkey =3D ia->ri_bind_mem->rkey;
>> +	seg->mr_rkey =3D ia->ri_dma_mr->rkey;
>> 	seg->mr_base =3D seg->mr_dma;
>> 	seg->mr_nsegs =3D 1;
>> 	return 1;
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index da184f9..8516d98 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -493,9 +493,11 @@ rpcrdma_clean_cq(struct ib_cq *cq)
>> int
>> rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, in=
t memreg)
>> {
>> -	int rc, mem_priv;
>> 	struct rpcrdma_ia *ia =3D &xprt->rx_ia;
>> 	struct ib_device_attr *devattr =3D &ia->ri_devattr;
>> +	int rc;
>> +
>> +	ia->ri_dma_mr =3D NULL;
>>=20
>> 	ia->ri_id =3D rpcrdma_create_id(xprt, ia, addr);
>> 	if (IS_ERR(ia->ri_id)) {
>> @@ -519,11 +521,6 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, stru=
ct sockaddr *addr, int memreg)
>> 		goto out3;
>> 	}
>>=20
>> -	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
>> -		ia->ri_have_dma_lkey =3D 1;
>> -		ia->ri_dma_lkey =3D ia->ri_device->local_dma_lkey;
>> -	}
>> -
>> 	if (memreg =3D=3D RPCRDMA_FRMR) {
>> 		/* Requires both frmr reg and local dma lkey */
>> 		if (((devattr->device_cap_flags &
>> @@ -543,38 +540,15 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, str=
uct sockaddr *addr, int memreg)
>> 		}
>> 	}
>>=20
>> -	/*
>> -	 * Optionally obtain an underlying physical identity mapping in
>> -	 * order to do a memory window-based bind. This base registration
>> -	 * is protected from remote access - that is enabled only by bindi=
ng
>> -	 * for the specific bytes targeted during each RPC operation, and
>> -	 * revoked after the corresponding completion similar to a storage
>> -	 * adapter.
>> -	 */
>> 	switch (memreg) {
>> 	case RPCRDMA_FRMR:
>> 		ia->ri_ops =3D &rpcrdma_frwr_memreg_ops;
>> 		break;
>> 	case RPCRDMA_ALLPHYSICAL:
>> 		ia->ri_ops =3D &rpcrdma_physical_memreg_ops;
>> -		mem_priv =3D IB_ACCESS_LOCAL_WRITE |
>> -				IB_ACCESS_REMOTE_WRITE |
>> -				IB_ACCESS_REMOTE_READ;
>> -		goto register_setup;
>> +		break;
>> 	case RPCRDMA_MTHCAFMR:
>> 		ia->ri_ops =3D &rpcrdma_fmr_memreg_ops;
>> -		if (ia->ri_have_dma_lkey)
>> -			break;
>> -		mem_priv =3D IB_ACCESS_LOCAL_WRITE;
>> -	register_setup:
>> -		ia->ri_bind_mem =3D ib_get_dma_mr(ia->ri_pd, mem_priv);
>> -		if (IS_ERR(ia->ri_bind_mem)) {
>> -			printk(KERN_ALERT "%s: ib_get_dma_mr for "
>> -				"phys register failed with %lX\n",
>> -				__func__, PTR_ERR(ia->ri_bind_mem));
>> -			rc =3D -ENOMEM;
>> -			goto out3;
>> -		}
>> 		break;
>> 	default:
>> 		printk(KERN_ERR "RPC: Unsupported memory "
>> @@ -606,15 +580,7 @@ out1:
>> void
>> rpcrdma_ia_close(struct rpcrdma_ia *ia)
>> {
>> -	int rc;
>> -
>> 	dprintk("RPC:       %s: entering\n", __func__);
>> -	if (ia->ri_bind_mem !=3D NULL) {
>> -		rc =3D ib_dereg_mr(ia->ri_bind_mem);
>> -		dprintk("RPC:       %s: ib_dereg_mr returned %i\n",
>> -			__func__, rc);
>> -	}
>> -
>> 	if (ia->ri_id !=3D NULL && !IS_ERR(ia->ri_id)) {
>> 		if (ia->ri_id->qp)
>> 			rdma_destroy_qp(ia->ri_id);
>> @@ -661,8 +627,10 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct=
 rpcrdma_ia *ia,
>> 	if (cdata->padding) {
>> 		ep->rep_padbuf =3D rpcrdma_alloc_regbuf(ia, cdata->padding,
>> 						      GFP_KERNEL);
>> -		if (IS_ERR(ep->rep_padbuf))
>> -			return PTR_ERR(ep->rep_padbuf);
>> +		if (IS_ERR(ep->rep_padbuf)) {
>> +			rc =3D PTR_ERR(ep->rep_padbuf);
>> +			goto out0;
>> +		}
>> 	} else
>> 		ep->rep_padbuf =3D NULL;
>>=20
>> @@ -749,6 +717,9 @@ out2:
>> 			__func__, err);
>> out1:
>> 	rpcrdma_free_regbuf(ia, ep->rep_padbuf);
>> +out0:
>> +	if (ia->ri_dma_mr)
>> +		ib_dereg_mr(ia->ri_dma_mr);
>> 	return rc;
>> }
>>=20
>> @@ -788,6 +759,12 @@ rpcrdma_ep_destroy(struct rpcrdma_ep *ep, struc=
t rpcrdma_ia *ia)
>> 	if (rc)
>> 		dprintk("RPC:       %s: ib_destroy_cq returned %i\n",
>> 			__func__, rc);
>> +
>> +	if (ia->ri_dma_mr) {
>> +		rc =3D ib_dereg_mr(ia->ri_dma_mr);
>> +		dprintk("RPC:       %s: ib_dereg_mr returned %i\n",
>> +			__func__, rc);
>> +	}
>> }
>>=20
>> /*
>> @@ -1262,8 +1239,7 @@ rpcrdma_alloc_regbuf(struct rpcrdma_ia *ia, si=
ze_t size, gfp_t flags)
>> 		goto out_free;
>>=20
>> 	iov->length =3D size;
>> -	iov->lkey =3D ia->ri_have_dma_lkey ?
>> -				ia->ri_dma_lkey : ia->ri_bind_mem->lkey;
>> +	iov->lkey =3D ia->ri_dma_lkey;
>> 	rb->rg_size =3D size;
>> 	rb->rg_owner =3D NULL;
>> 	return rb;
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index ce4e79e..8219011 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -65,9 +65,8 @@ struct rpcrdma_ia {
>> 	struct ib_device	*ri_device;
>> 	struct rdma_cm_id 	*ri_id;
>> 	struct ib_pd		*ri_pd;
>> -	struct ib_mr		*ri_bind_mem;
>> +	struct ib_mr		*ri_dma_mr;
>> 	u32			ri_dma_lkey;
>> -	int			ri_have_dma_lkey;
>> 	struct completion	ri_done;
>> 	int			ri_async_rc;
>> 	unsigned int		ri_max_frmr_depth;

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
