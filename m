From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 05/16] xprtrdma: Add a "register_external" op for each memreg mode
Date: Mon, 16 Mar 2015 09:48:31 -0700
Message-ID: <982A021D-1B85-4AAF-89A3-302A21CF2B36@oracle.com>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212718.22783.10096.stgit@manet.1015granger.net> <5506B036.1040905@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5506B036.1040905-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mar 16, 2015, at 3:28 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 3/13/2015 11:27 PM, Chuck Lever wrote:
>> There is very little common processing among the different external
>> memory registration functions. Have rpcrdma_create_chunks() call
>> the registration method directly. This removes a stack frame and a
>> switch statement from the external registration path.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/fmr_ops.c      |   51 +++++++++++
>>  net/sunrpc/xprtrdma/frwr_ops.c     |   88 ++++++++++++++++++
>>  net/sunrpc/xprtrdma/physical_ops.c |   17 ++++
>>  net/sunrpc/xprtrdma/rpc_rdma.c     |    5 +
>>  net/sunrpc/xprtrdma/verbs.c        |  172 +------------------------=
-----------
>>  net/sunrpc/xprtrdma/xprt_rdma.h    |    6 +
>>  6 files changed, 166 insertions(+), 173 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr=
_ops.c
>> index eec2660..45fb646 100644
>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>> @@ -29,7 +29,58 @@ fmr_op_maxpages(struct rpcrdma_xprt *r_xprt)
>>  		     rpcrdma_max_segments(r_xprt) * RPCRDMA_MAX_FMR_SGES);
>>  }
>>=20
>> +/* Use the ib_map_phys_fmr() verb to register a memory region
>> + * for remote access via RDMA READ or RDMA WRITE.
>> + */
>> +static int
>> +fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
>> +	   int nsegs, bool writing)
>> +{
>> +	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> +	struct rpcrdma_mr_seg *seg1 =3D seg;
>> +	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>> +	u64 physaddrs[RPCRDMA_MAX_DATA_SEGS];
>> +	int len, pageoff, i, rc;
>> +
>> +	pageoff =3D offset_in_page(seg1->mr_offset);
>> +	seg1->mr_offset -=3D pageoff;	/* start of page */
>> +	seg1->mr_len +=3D pageoff;
>> +	len =3D -pageoff;
>> +	if (nsegs > RPCRDMA_MAX_FMR_SGES)
>> +		nsegs =3D RPCRDMA_MAX_FMR_SGES;
>> +	for (i =3D 0; i < nsegs;) {
>> +		rpcrdma_map_one(ia, seg, writing);
>> +		physaddrs[i] =3D seg->mr_dma;
>> +		len +=3D seg->mr_len;
>> +		++seg;
>> +		++i;
>> +		/* Check for holes */
>> +		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
>> +		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>> +			break;
>> +	}
>> +
>> +	rc =3D ib_map_phys_fmr(mw->r.fmr, physaddrs, i, seg1->mr_dma);
>> +	if (rc)
>> +		goto out_maperr;
>> +
>> +	seg1->mr_rkey =3D mw->r.fmr->rkey;
>> +	seg1->mr_base =3D seg1->mr_dma + pageoff;
>> +	seg1->mr_nsegs =3D i;
>> +	seg1->mr_len =3D len;
>> +	return i;
>> +
>> +out_maperr:
>> +	dprintk("RPC:       %s: ib_map_phys_fmr %u@0x%llx+%i (%d) status %=
i\n",
>> +		__func__, len, (unsigned long long)seg1->mr_dma,
>> +		pageoff, i, rc);
>> +	while (i--)
>> +		rpcrdma_unmap_one(ia, --seg);
>> +	return rc;
>> +}
>> +
>>  const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops =3D {
>> +	.ro_map				=3D fmr_op_map,
>>  	.ro_maxpages			=3D fmr_op_maxpages,
>>  	.ro_displayname			=3D "fmr",
>>  };
>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/fr=
wr_ops.c
>> index 73a5ac8..2b5ccb0 100644
>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>> @@ -29,7 +29,95 @@ frwr_op_maxpages(struct rpcrdma_xprt *r_xprt)
>>  		     rpcrdma_max_segments(r_xprt) * ia->ri_max_frmr_depth);
>>  }
>>=20
>> +/* Post a FAST_REG Work Request to register a memory region
>> + * for remote access via RDMA READ or RDMA WRITE.
>> + */
>> +static int
>> +frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg=
,
>> +	    int nsegs, bool writing)
>> +{
>> +	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> +	struct rpcrdma_mr_seg *seg1 =3D seg;
>> +	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>> +	struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
>> +	struct ib_mr *mr =3D frmr->fr_mr;
>> +	struct ib_send_wr fastreg_wr, *bad_wr;
>> +	u8 key;
>> +	int len, pageoff;
>> +	int i, rc;
>> +	int seg_len;
>> +	u64 pa;
>> +	int page_no;
>> +
>> +	pageoff =3D offset_in_page(seg1->mr_offset);
>> +	seg1->mr_offset -=3D pageoff;	/* start of page */
>> +	seg1->mr_len +=3D pageoff;
>> +	len =3D -pageoff;
>> +	if (nsegs > ia->ri_max_frmr_depth)
>> +		nsegs =3D ia->ri_max_frmr_depth;
>> +	for (page_no =3D i =3D 0; i < nsegs;) {
>> +		rpcrdma_map_one(ia, seg, writing);
>> +		pa =3D seg->mr_dma;
>> +		for (seg_len =3D seg->mr_len; seg_len > 0; seg_len -=3D PAGE_SIZE=
) {
>> +			frmr->fr_pgl->page_list[page_no++] =3D pa;
>> +			pa +=3D PAGE_SIZE;
>> +		}
>> +		len +=3D seg->mr_len;
>> +		++seg;
>> +		++i;
>> +		/* Check for holes */
>> +		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
>> +		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>> +			break;
>> +	}
>> +	dprintk("RPC:       %s: Using frmr %p to map %d segments\n",
>> +		__func__, mw, i);
>> +
>> +	frmr->fr_state =3D FRMR_IS_VALID;
>> +
>> +	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>> +	fastreg_wr.wr_id =3D (unsigned long)(void *)mw;
>> +	fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
>> +	fastreg_wr.wr.fast_reg.iova_start =3D seg1->mr_dma;
>> +	fastreg_wr.wr.fast_reg.page_list =3D frmr->fr_pgl;
>> +	fastreg_wr.wr.fast_reg.page_shift =3D PAGE_SHIFT;
>> +	fastreg_wr.wr.fast_reg.page_list_len =3D page_no;
>> +	fastreg_wr.wr.fast_reg.length =3D page_no << PAGE_SHIFT;
>=20
> Umm, is this necessarily true? will the region length be full pages?
> Why don't you assign fast_reg.length =3D len?
> I might be missing something here=85

Don=92t know. This goes back to when FRWR was introduced in this code,
with commit 3197d309 in 2008.


>=20
>> +	if (fastreg_wr.wr.fast_reg.length < len) {
>> +		rc =3D -EIO;
>> +		goto out_err;
>> +	}
>> +	fastreg_wr.wr.fast_reg.access_flags =3D writing ?
>> +				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>> +				IB_ACCESS_REMOTE_READ;
>> +	key =3D (u8)(mr->rkey & 0x000000FF);
>> +	ib_update_fast_reg_key(mr, ++key);
>> +	fastreg_wr.wr.fast_reg.rkey =3D mr->rkey;
>> +
>> +	DECR_CQCOUNT(&r_xprt->rx_ep);
>> +	rc =3D ib_post_send(ia->ri_id->qp, &fastreg_wr, &bad_wr);
>> +	if (rc)
>> +		goto out_senderr;
>> +
>> +	seg1->mr_rkey =3D mr->rkey;
>> +	seg1->mr_base =3D seg1->mr_dma + pageoff;
>> +	seg1->mr_nsegs =3D i;
>> +	seg1->mr_len =3D len;
>> +	return i;
>> +
>> +out_senderr:
>> +	dprintk("RPC:       %s: ib_post_send status %i\n", __func__, rc);
>> +	ib_update_fast_reg_key(mr, --key);
>> +
>> +out_err:
>> +	frmr->fr_state =3D FRMR_IS_INVALID;
>> +	while (i--)
>> +		rpcrdma_unmap_one(ia, --seg);
>> +	return rc;
>> +}
>> +
>>  const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops =3D {
>> +	.ro_map				=3D frwr_op_map,
>>  	.ro_maxpages			=3D frwr_op_maxpages,
>>  	.ro_displayname			=3D "frwr",
>>  };
>> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdm=
a/physical_ops.c
>> index 28ade19..5a284ee 100644
>> --- a/net/sunrpc/xprtrdma/physical_ops.c
>> +++ b/net/sunrpc/xprtrdma/physical_ops.c
>> @@ -28,7 +28,24 @@ physical_op_maxpages(struct rpcrdma_xprt *r_xprt)
>>  		     rpcrdma_max_segments(r_xprt));
>>  }
>>=20
>> +/* The client's physical memory is already exposed for
>> + * remote access via RDMA READ or RDMA WRITE.
>> + */
>> +static int
>> +physical_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg =
*seg,
>> +		int nsegs, bool writing)
>> +{
>> +	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> +
>> +	rpcrdma_map_one(ia, seg, writing);
>> +	seg->mr_rkey =3D ia->ri_bind_mem->rkey;
>> +	seg->mr_base =3D seg->mr_dma;
>> +	seg->mr_nsegs =3D 1;
>> +	return 1;
>> +}
>> +
>>  const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops =3D {
>> +	.ro_map				=3D physical_op_map,
>>  	.ro_maxpages			=3D physical_op_maxpages,
>>  	.ro_displayname			=3D "physical",
>>  };
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index 41456d9..6ab1d03 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -187,6 +187,7 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, str=
uct xdr_buf *target,
>>  	struct rpcrdma_write_array *warray =3D NULL;
>>  	struct rpcrdma_write_chunk *cur_wchunk =3D NULL;
>>  	__be32 *iptr =3D headerp->rm_body.rm_chunks;
>> +	int (*map)(struct rpcrdma_xprt *, struct rpcrdma_mr_seg *, int, bo=
ol);
>>=20
>>  	if (type =3D=3D rpcrdma_readch || type =3D=3D rpcrdma_areadch) {
>>  		/* a read chunk - server will RDMA Read our memory */
>> @@ -209,9 +210,9 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, str=
uct xdr_buf *target,
>>  	if (nsegs < 0)
>>  		return nsegs;
>>=20
>> +	map =3D r_xprt->rx_ia.ri_ops->ro_map;
>>  	do {
>> -		n =3D rpcrdma_register_external(seg, nsegs,
>> -						cur_wchunk !=3D NULL, r_xprt);
>> +		n =3D map(r_xprt, seg, nsegs, cur_wchunk !=3D NULL);
>>  		if (n <=3D 0)
>>  			goto out;
>>  		if (cur_rchunk) {	/* read */
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 837d4ea..851ed97 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -1857,8 +1857,8 @@ rpcrdma_free_regbuf(struct rpcrdma_ia *ia, str=
uct rpcrdma_regbuf *rb)
>>   * Wrappers for chunk registration, shared by read/write chunk code=
=2E
>>   */
>>=20
>> -static void
>> -rpcrdma_map_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg, =
int writing)
>> +void
>> +rpcrdma_map_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg, =
bool writing)
>>  {
>>  	seg->mr_dir =3D writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>>  	seg->mr_dmalen =3D seg->mr_len;
>> @@ -1878,7 +1878,7 @@ rpcrdma_map_one(struct rpcrdma_ia *ia, struct =
rpcrdma_mr_seg *seg, int writing)
>>  	}
>>  }
>>=20
>> -static void
>> +void
>>  rpcrdma_unmap_one(struct rpcrdma_ia *ia, struct rpcrdma_mr_seg *seg=
)
>>  {
>>  	if (seg->mr_page)
>> @@ -1890,93 +1890,6 @@ rpcrdma_unmap_one(struct rpcrdma_ia *ia, stru=
ct rpcrdma_mr_seg *seg)
>>  }
>>=20
>>  static int
>> -rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
>> -			int *nsegs, int writing, struct rpcrdma_ia *ia,
>> -			struct rpcrdma_xprt *r_xprt)
>> -{
>> -	struct rpcrdma_mr_seg *seg1 =3D seg;
>> -	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>> -	struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
>> -	struct ib_mr *mr =3D frmr->fr_mr;
>> -	struct ib_send_wr fastreg_wr, *bad_wr;
>> -	u8 key;
>> -	int len, pageoff;
>> -	int i, rc;
>> -	int seg_len;
>> -	u64 pa;
>> -	int page_no;
>> -
>> -	pageoff =3D offset_in_page(seg1->mr_offset);
>> -	seg1->mr_offset -=3D pageoff;	/* start of page */
>> -	seg1->mr_len +=3D pageoff;
>> -	len =3D -pageoff;
>> -	if (*nsegs > ia->ri_max_frmr_depth)
>> -		*nsegs =3D ia->ri_max_frmr_depth;
>> -	for (page_no =3D i =3D 0; i < *nsegs;) {
>> -		rpcrdma_map_one(ia, seg, writing);
>> -		pa =3D seg->mr_dma;
>> -		for (seg_len =3D seg->mr_len; seg_len > 0; seg_len -=3D PAGE_SIZE=
) {
>> -			frmr->fr_pgl->page_list[page_no++] =3D pa;
>> -			pa +=3D PAGE_SIZE;
>> -		}
>> -		len +=3D seg->mr_len;
>> -		++seg;
>> -		++i;
>> -		/* Check for holes */
>> -		if ((i < *nsegs && offset_in_page(seg->mr_offset)) ||
>> -		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>> -			break;
>> -	}
>> -	dprintk("RPC:       %s: Using frmr %p to map %d segments\n",
>> -		__func__, mw, i);
>> -
>> -	frmr->fr_state =3D FRMR_IS_VALID;
>> -
>> -	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>> -	fastreg_wr.wr_id =3D (unsigned long)(void *)mw;
>> -	fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
>> -	fastreg_wr.wr.fast_reg.iova_start =3D seg1->mr_dma;
>> -	fastreg_wr.wr.fast_reg.page_list =3D frmr->fr_pgl;
>> -	fastreg_wr.wr.fast_reg.page_list_len =3D page_no;
>> -	fastreg_wr.wr.fast_reg.page_shift =3D PAGE_SHIFT;
>> -	fastreg_wr.wr.fast_reg.length =3D page_no << PAGE_SHIFT;
>> -	if (fastreg_wr.wr.fast_reg.length < len) {
>> -		rc =3D -EIO;
>> -		goto out_err;
>> -	}
>> -
>> -	/* Bump the key */
>> -	key =3D (u8)(mr->rkey & 0x000000FF);
>> -	ib_update_fast_reg_key(mr, ++key);
>> -
>> -	fastreg_wr.wr.fast_reg.access_flags =3D (writing ?
>> -				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
>> -				IB_ACCESS_REMOTE_READ);
>> -	fastreg_wr.wr.fast_reg.rkey =3D mr->rkey;
>> -	DECR_CQCOUNT(&r_xprt->rx_ep);
>> -
>> -	rc =3D ib_post_send(ia->ri_id->qp, &fastreg_wr, &bad_wr);
>> -	if (rc) {
>> -		dprintk("RPC:       %s: failed ib_post_send for register,"
>> -			" status %i\n", __func__, rc);
>> -		ib_update_fast_reg_key(mr, --key);
>> -		goto out_err;
>> -	} else {
>> -		seg1->mr_rkey =3D mr->rkey;
>> -		seg1->mr_base =3D seg1->mr_dma + pageoff;
>> -		seg1->mr_nsegs =3D i;
>> -		seg1->mr_len =3D len;
>> -	}
>> -	*nsegs =3D i;
>> -	return 0;
>> -out_err:
>> -	frmr->fr_state =3D FRMR_IS_INVALID;
>> -	while (i--)
>> -		rpcrdma_unmap_one(ia, --seg);
>> -	return rc;
>> -}
>> -
>> -static int
>>  rpcrdma_deregister_frmr_external(struct rpcrdma_mr_seg *seg,
>>  			struct rpcrdma_ia *ia, struct rpcrdma_xprt *r_xprt)
>>  {
>> @@ -2007,49 +1920,6 @@ rpcrdma_deregister_frmr_external(struct rpcrd=
ma_mr_seg *seg,
>>  }
>>=20
>>  static int
>> -rpcrdma_register_fmr_external(struct rpcrdma_mr_seg *seg,
>> -			int *nsegs, int writing, struct rpcrdma_ia *ia)
>> -{
>> -	struct rpcrdma_mr_seg *seg1 =3D seg;
>> -	u64 physaddrs[RPCRDMA_MAX_DATA_SEGS];
>> -	int len, pageoff, i, rc;
>> -
>> -	pageoff =3D offset_in_page(seg1->mr_offset);
>> -	seg1->mr_offset -=3D pageoff;	/* start of page */
>> -	seg1->mr_len +=3D pageoff;
>> -	len =3D -pageoff;
>> -	if (*nsegs > RPCRDMA_MAX_DATA_SEGS)
>> -		*nsegs =3D RPCRDMA_MAX_DATA_SEGS;
>> -	for (i =3D 0; i < *nsegs;) {
>> -		rpcrdma_map_one(ia, seg, writing);
>> -		physaddrs[i] =3D seg->mr_dma;
>> -		len +=3D seg->mr_len;
>> -		++seg;
>> -		++i;
>> -		/* Check for holes */
>> -		if ((i < *nsegs && offset_in_page(seg->mr_offset)) ||
>> -		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>> -			break;
>> -	}
>> -	rc =3D ib_map_phys_fmr(seg1->rl_mw->r.fmr, physaddrs, i, seg1->mr_=
dma);
>> -	if (rc) {
>> -		dprintk("RPC:       %s: failed ib_map_phys_fmr "
>> -			"%u@0x%llx+%i (%d)... status %i\n", __func__,
>> -			len, (unsigned long long)seg1->mr_dma,
>> -			pageoff, i, rc);
>> -		while (i--)
>> -			rpcrdma_unmap_one(ia, --seg);
>> -	} else {
>> -		seg1->mr_rkey =3D seg1->rl_mw->r.fmr->rkey;
>> -		seg1->mr_base =3D seg1->mr_dma + pageoff;
>> -		seg1->mr_nsegs =3D i;
>> -		seg1->mr_len =3D len;
>> -	}
>> -	*nsegs =3D i;
>> -	return rc;
>> -}
>> -
>> -static int
>>  rpcrdma_deregister_fmr_external(struct rpcrdma_mr_seg *seg,
>>  			struct rpcrdma_ia *ia)
>>  {
>> @@ -2070,42 +1940,6 @@ rpcrdma_deregister_fmr_external(struct rpcrdm=
a_mr_seg *seg,
>>  }
>>=20
>>  int
>> -rpcrdma_register_external(struct rpcrdma_mr_seg *seg,
>> -			int nsegs, int writing, struct rpcrdma_xprt *r_xprt)
>> -{
>> -	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>> -	int rc =3D 0;
>> -
>> -	switch (ia->ri_memreg_strategy) {
>> -
>> -	case RPCRDMA_ALLPHYSICAL:
>> -		rpcrdma_map_one(ia, seg, writing);
>> -		seg->mr_rkey =3D ia->ri_bind_mem->rkey;
>> -		seg->mr_base =3D seg->mr_dma;
>> -		seg->mr_nsegs =3D 1;
>> -		nsegs =3D 1;
>> -		break;
>> -
>> -	/* Registration using frmr registration */
>> -	case RPCRDMA_FRMR:
>> -		rc =3D rpcrdma_register_frmr_external(seg, &nsegs, writing, ia, r=
_xprt);
>> -		break;
>> -
>> -	/* Registration using fmr memory registration */
>> -	case RPCRDMA_MTHCAFMR:
>> -		rc =3D rpcrdma_register_fmr_external(seg, &nsegs, writing, ia);
>> -		break;
>> -
>> -	default:
>> -		return -EIO;
>> -	}
>> -	if (rc)
>> -		return rc;
>> -
>> -	return nsegs;
>> -}
>> -
>> -int
>>  rpcrdma_deregister_external(struct rpcrdma_mr_seg *seg,
>>  		struct rpcrdma_xprt *r_xprt)
>>  {
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index 59e627e..7bf077b 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -336,6 +336,8 @@ struct rpcrdma_stats {
>>   */
>>  struct rpcrdma_xprt;
>>  struct rpcrdma_memreg_ops {
>> +	int		(*ro_map)(struct rpcrdma_xprt *,
>> +				  struct rpcrdma_mr_seg *, int, bool);
>>  	size_t		(*ro_maxpages)(struct rpcrdma_xprt *);
>>  	const char	*ro_displayname;
>>  };
>> @@ -403,8 +405,6 @@ void rpcrdma_buffer_put(struct rpcrdma_req *);
>>  void rpcrdma_recv_buffer_get(struct rpcrdma_req *);
>>  void rpcrdma_recv_buffer_put(struct rpcrdma_rep *);
>>=20
>> -int rpcrdma_register_external(struct rpcrdma_mr_seg *,
>> -				int, int, struct rpcrdma_xprt *);
>>  int rpcrdma_deregister_external(struct rpcrdma_mr_seg *,
>>  				struct rpcrdma_xprt *);
>>=20
>> @@ -414,6 +414,8 @@ void rpcrdma_free_regbuf(struct rpcrdma_ia *,
>>  			 struct rpcrdma_regbuf *);
>>=20
>>  unsigned int rpcrdma_max_segments(struct rpcrdma_xprt *);
>> +void rpcrdma_map_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *, =
bool);
>> +void rpcrdma_unmap_one(struct rpcrdma_ia *, struct rpcrdma_mr_seg *=
);
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
