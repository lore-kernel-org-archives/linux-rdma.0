From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] svcrdma: refactor marshalling logic
Date: Fri, 25 Apr 2014 09:24:47 -0400
Message-ID: <6B12FA09-0E8C-497A-9145-E2B7CAB16C53@oracle.com>
References: <20140410183723.29724.18665.stgit@build.ogc.int> <20140425105838.GE22295@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140425105838.GE22295-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bruce-

On Apr 25, 2014, at 6:58 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wro=
te:

> On Thu, Apr 10, 2014 at 01:37:23PM -0500, Steve Wise wrote:
>> From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
>>=20
>> This patch refactors the marshalling logic to remove the intermediar=
y
>> map structures.  It also fixes an existing bug where the NFSRDMA ser=
ver
>> was not minding the device fast register page list length limitation=
s.
>>=20
>> Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
>> ---
>>=20
>> include/linux/sunrpc/svc_rdma.h          |    3=20
>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  551 +++++++++-----------=
----------
>> net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  230 +------------
>> net/sunrpc/xprtrdma/svc_rdma_transport.c |   57 ++-
>> 4 files changed, 222 insertions(+), 619 deletions(-)
>=20
> Is it possible to make this change in more than one step?
>=20
> RDMA is pretty esoteric to most of us, so honestly this will probably
> get merged based just on your having tested it, but if it was possibl=
e
> to break this up into smaller patches you might give us at least a
> fighting chance of giving it some review=85.

I agree it could be broken up.

However, my testing revealed that the patch inadvertently breaks suppor=
t
for HCAs that do not support FRMR.  I=92ve reported this to Steve and T=
om.
IMO you should wait for a newer version of the refactoring patch.

There are plenty of people who can review and test these patches.  We a=
re
working on setting up regular testing in a broad array of environments.

In general it would be best for maintainers not to merge NFS/RDMA patch=
es
at least until you see Tested-by and/or Reviewed-by on the mailing list=
=2E  I
also thought it was appropriate to mail patches To: you when they are r=
eady
to be merged, but To: the mailing lists when asking for review.  Will t=
hat
be a problem?


> --b.
>=20
>>=20
>> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/=
svc_rdma.h
>> index 0b8e3e6..5cf99a0 100644
>> --- a/include/linux/sunrpc/svc_rdma.h
>> +++ b/include/linux/sunrpc/svc_rdma.h
>> @@ -115,14 +115,13 @@ struct svc_rdma_fastreg_mr {
>> 	struct list_head frmr_list;
>> };
>> struct svc_rdma_req_map {
>> -	struct svc_rdma_fastreg_mr *frmr;
>> 	unsigned long count;
>> 	union {
>> 		struct kvec sge[RPCSVC_MAXPAGES];
>> 		struct svc_rdma_chunk_sge ch[RPCSVC_MAXPAGES];
>> +		unsigned long lkey[RPCSVC_MAXPAGES];
>> 	};
>> };
>> -#define RDMACTXT_F_FAST_UNREG	1
>> #define RDMACTXT_F_LAST_CTXT	2
>>=20
>> #define	SVCRDMA_DEVCAP_FAST_REG		1	/* fast mr registration */
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xp=
rtrdma/svc_rdma_recvfrom.c
>> index 8d904e4..9cf65ff 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -1,4 +1,5 @@
>> /*
>> + * Copyright (c) 2014 Open Grid Computing, Inc. All rights reserved=
=2E
>>  * Copyright (c) 2005-2006 Network Appliance, Inc. All rights reserv=
ed.
>>  *
>>  * This software is available to you under a choice of one of two
>> @@ -69,7 +70,8 @@ static void rdma_build_arg_xdr(struct svc_rqst *rq=
stp,
>>=20
>> 	/* Set up the XDR head */
>> 	rqstp->rq_arg.head[0].iov_base =3D page_address(page);
>> -	rqstp->rq_arg.head[0].iov_len =3D min(byte_count, ctxt->sge[0].len=
gth);
>> +	rqstp->rq_arg.head[0].iov_len =3D
>> +		min_t(size_t, byte_count, ctxt->sge[0].length);
>> 	rqstp->rq_arg.len =3D byte_count;
>> 	rqstp->rq_arg.buflen =3D byte_count;
>>=20
>> @@ -85,7 +87,7 @@ static void rdma_build_arg_xdr(struct svc_rqst *rq=
stp,
>> 		page =3D ctxt->pages[sge_no];
>> 		put_page(rqstp->rq_pages[sge_no]);
>> 		rqstp->rq_pages[sge_no] =3D page;
>> -		bc -=3D min(bc, ctxt->sge[sge_no].length);
>> +		bc -=3D min_t(u32, bc, ctxt->sge[sge_no].length);
>> 		rqstp->rq_arg.buflen +=3D ctxt->sge[sge_no].length;
>> 		sge_no++;
>> 	}
>> @@ -113,291 +115,154 @@ static void rdma_build_arg_xdr(struct svc_rq=
st *rqstp,
>> 	rqstp->rq_arg.tail[0].iov_len =3D 0;
>> }
>>=20
>> -/* Encode a read-chunk-list as an array of IB SGE
>> - *
>> - * Assumptions:
>> - * - chunk[0]->position points to pages[0] at an offset of 0
>> - * - pages[] is not physically or virtually contiguous and consists=
 of
>> - *   PAGE_SIZE elements.
>> - *
>> - * Output:
>> - * - sge array pointing into pages[] array.
>> - * - chunk_sge array specifying sge index and count for each
>> - *   chunk in the read list
>> - *
>> - */
>> -static int map_read_chunks(struct svcxprt_rdma *xprt,
>> -			   struct svc_rqst *rqstp,
>> -			   struct svc_rdma_op_ctxt *head,
>> -			   struct rpcrdma_msg *rmsgp,
>> -			   struct svc_rdma_req_map *rpl_map,
>> -			   struct svc_rdma_req_map *chl_map,
>> -			   int ch_count,
>> -			   int byte_count)
>> -{
>> -	int sge_no;
>> -	int sge_bytes;
>> -	int page_off;
>> -	int page_no;
>> -	int ch_bytes;
>> -	int ch_no;
>> -	struct rpcrdma_read_chunk *ch;
>> -
>> -	sge_no =3D 0;
>> -	page_no =3D 0;
>> -	page_off =3D 0;
>> -	ch =3D (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
>> -	ch_no =3D 0;
>> -	ch_bytes =3D ntohl(ch->rc_target.rs_length);
>> -	head->arg.head[0] =3D rqstp->rq_arg.head[0];
>> -	head->arg.tail[0] =3D rqstp->rq_arg.tail[0];
>> -	head->arg.pages =3D &head->pages[head->count];
>> -	head->hdr_count =3D head->count; /* save count of hdr pages */
>> -	head->arg.page_base =3D 0;
>> -	head->arg.page_len =3D ch_bytes;
>> -	head->arg.len =3D rqstp->rq_arg.len + ch_bytes;
>> -	head->arg.buflen =3D rqstp->rq_arg.buflen + ch_bytes;
>> -	head->count++;
>> -	chl_map->ch[0].start =3D 0;
>> -	while (byte_count) {
>> -		rpl_map->sge[sge_no].iov_base =3D
>> -			page_address(rqstp->rq_arg.pages[page_no]) + page_off;
>> -		sge_bytes =3D min_t(int, PAGE_SIZE-page_off, ch_bytes);
>> -		rpl_map->sge[sge_no].iov_len =3D sge_bytes;
>> -		/*
>> -		 * Don't bump head->count here because the same page
>> -		 * may be used by multiple SGE.
>> -		 */
>> -		head->arg.pages[page_no] =3D rqstp->rq_arg.pages[page_no];
>> -		rqstp->rq_respages =3D &rqstp->rq_arg.pages[page_no+1];
>> -		rqstp->rq_next_page =3D rqstp->rq_respages + 1;
>> -
>> -		byte_count -=3D sge_bytes;
>> -		ch_bytes -=3D sge_bytes;
>> -		sge_no++;
>> -		/*
>> -		 * If all bytes for this chunk have been mapped to an
>> -		 * SGE, move to the next SGE
>> -		 */
>> -		if (ch_bytes =3D=3D 0) {
>> -			chl_map->ch[ch_no].count =3D
>> -				sge_no - chl_map->ch[ch_no].start;
>> -			ch_no++;
>> -			ch++;
>> -			chl_map->ch[ch_no].start =3D sge_no;
>> -			ch_bytes =3D ntohl(ch->rc_target.rs_length);
>> -			/* If bytes remaining account for next chunk */
>> -			if (byte_count) {
>> -				head->arg.page_len +=3D ch_bytes;
>> -				head->arg.len +=3D ch_bytes;
>> -				head->arg.buflen +=3D ch_bytes;
>> -			}
>> -		}
>> -		/*
>> -		 * If this SGE consumed all of the page, move to the
>> -		 * next page
>> -		 */
>> -		if ((sge_bytes + page_off) =3D=3D PAGE_SIZE) {
>> -			page_no++;
>> -			page_off =3D 0;
>> -			/*
>> -			 * If there are still bytes left to map, bump
>> -			 * the page count
>> -			 */
>> -			if (byte_count)
>> -				head->count++;
>> -		} else
>> -			page_off +=3D sge_bytes;
>> -	}
>> -	BUG_ON(byte_count !=3D 0);
>> -	return sge_no;
>> -}
>> -
>> -/* Map a read-chunk-list to an XDR and fast register the page-list.
>> - *
>> - * Assumptions:
>> - * - chunk[0]	position points to pages[0] at an offset of 0
>> - * - pages[]	will be made physically contiguous by creating a one-o=
ff memory
>> - *		region using the fastreg verb.
>> - * - byte_count is # of bytes in read-chunk-list
>> - * - ch_count	is # of chunks in read-chunk-list
>> - *
>> - * Output:
>> - * - sge array pointing into pages[] array.
>> - * - chunk_sge array specifying sge index and count for each
>> - *   chunk in the read list
>> - */
>> -static int fast_reg_read_chunks(struct svcxprt_rdma *xprt,
>> +typedef int (*rdma_reader_fn)(struct svcxprt_rdma *xprt,
>> +			      struct svc_rqst *rqstp,
>> +			      struct svc_rdma_op_ctxt *head,
>> +			      int *page_no,
>> +			      u32 *page_offset,
>> +			      u32 rs_handle,
>> +			      u32 rs_length,
>> +			      u64 rs_offset,
>> +			      int last);
>> +
>> +/* Issue an RDMA_READ using an FRMR to map the data sink */
>> +static int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>> 				struct svc_rqst *rqstp,
>> 				struct svc_rdma_op_ctxt *head,
>> -				struct rpcrdma_msg *rmsgp,
>> -				struct svc_rdma_req_map *rpl_map,
>> -				struct svc_rdma_req_map *chl_map,
>> -				int ch_count,
>> -				int byte_count)
>> +				int *page_no,
>> +				u32 *page_offset,
>> +				u32 rs_handle,
>> +				u32 rs_length,
>> +				u64 rs_offset,
>> +				int last)
>> {
>> -	int page_no;
>> -	int ch_no;
>> -	u32 offset;
>> -	struct rpcrdma_read_chunk *ch;
>> -	struct svc_rdma_fastreg_mr *frmr;
>> -	int ret =3D 0;
>> +	struct ib_send_wr read_wr;
>> +	struct ib_send_wr inv_wr;
>> +	struct ib_send_wr fastreg_wr;
>> +	u8 key;
>> +	int pages_needed =3D PAGE_ALIGN(*page_offset + rs_length) >> PAGE_=
SHIFT;
>> +	struct svc_rdma_op_ctxt *ctxt =3D svc_rdma_get_context(xprt);
>> +	struct svc_rdma_fastreg_mr *frmr =3D svc_rdma_get_frmr(xprt);
>> +	int ret, read, pno;
>> +	u32 pg_off =3D *page_offset;
>> +	u32 pg_no =3D *page_no;
>>=20
>> -	frmr =3D svc_rdma_get_frmr(xprt);
>> 	if (IS_ERR(frmr))
>> 		return -ENOMEM;
>>=20
>> -	head->frmr =3D frmr;
>> -	head->arg.head[0] =3D rqstp->rq_arg.head[0];
>> -	head->arg.tail[0] =3D rqstp->rq_arg.tail[0];
>> -	head->arg.pages =3D &head->pages[head->count];
>> -	head->hdr_count =3D head->count; /* save count of hdr pages */
>> -	head->arg.page_base =3D 0;
>> -	head->arg.page_len =3D byte_count;
>> -	head->arg.len =3D rqstp->rq_arg.len + byte_count;
>> -	head->arg.buflen =3D rqstp->rq_arg.buflen + byte_count;
>> +	ctxt->direction =3D DMA_FROM_DEVICE;
>> +	ctxt->frmr =3D frmr;
>> +	pages_needed =3D min_t(int, pages_needed, xprt->sc_frmr_pg_list_le=
n);
>> +	read =3D min_t(int, pages_needed << PAGE_SHIFT, rs_length);
>>=20
>> -	/* Fast register the page list */
>> -	frmr->kva =3D page_address(rqstp->rq_arg.pages[0]);
>> +	frmr->kva =3D page_address(rqstp->rq_arg.pages[pg_no]);
>> 	frmr->direction =3D DMA_FROM_DEVICE;
>> 	frmr->access_flags =3D (IB_ACCESS_LOCAL_WRITE|IB_ACCESS_REMOTE_WRIT=
E);
>> -	frmr->map_len =3D byte_count;
>> -	frmr->page_list_len =3D PAGE_ALIGN(byte_count) >> PAGE_SHIFT;
>> -	for (page_no =3D 0; page_no < frmr->page_list_len; page_no++) {
>> -		frmr->page_list->page_list[page_no] =3D
>> +	frmr->map_len =3D pages_needed << PAGE_SHIFT;
>> +	frmr->page_list_len =3D pages_needed;
>> +
>> +	for (pno =3D 0; pno < pages_needed; pno++) {
>> +		int len =3D min_t(int, rs_length, PAGE_SIZE - pg_off);
>> +
>> +		head->arg.pages[pg_no] =3D rqstp->rq_arg.pages[pg_no];
>> +		head->arg.page_len +=3D len;
>> +		head->arg.len +=3D len;
>> +		head->count++;
>> +		rqstp->rq_respages =3D &rqstp->rq_arg.pages[pg_no+1];
>> +		rqstp->rq_next_page =3D rqstp->rq_respages + 1;
>> +		frmr->page_list->page_list[pno] =3D
>> 			ib_dma_map_page(xprt->sc_cm_id->device,
>> -					rqstp->rq_arg.pages[page_no], 0,
>> +					head->arg.pages[pg_no], 0,
>> 					PAGE_SIZE, DMA_FROM_DEVICE);
>> -		if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -					 frmr->page_list->page_list[page_no]))
>> -			goto fatal_err;
>> +		ret =3D ib_dma_mapping_error(xprt->sc_cm_id->device,
>> +					   frmr->page_list->page_list[pno]);
>> +		if (ret)
>> +			goto err;
>> 		atomic_inc(&xprt->sc_dma_used);
>> -		head->arg.pages[page_no] =3D rqstp->rq_arg.pages[page_no];
>> +		pg_no++;
>> +		pg_off =3D 0;
>> 	}
>> -	head->count +=3D page_no;
>> -
>> -	/* rq_respages points one past arg pages */
>> -	rqstp->rq_respages =3D &rqstp->rq_arg.pages[page_no];
>> 	rqstp->rq_next_page =3D rqstp->rq_respages + 1;
>> +	if (last && read =3D=3D rs_length)
>> +		set_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
>> +	else
>> +		clear_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
>>=20
>> -	/* Create the reply and chunk maps */
>> -	offset =3D 0;
>> -	ch =3D (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
>> -	for (ch_no =3D 0; ch_no < ch_count; ch_no++) {
>> -		int len =3D ntohl(ch->rc_target.rs_length);
>> -		rpl_map->sge[ch_no].iov_base =3D frmr->kva + offset;
>> -		rpl_map->sge[ch_no].iov_len =3D len;
>> -		chl_map->ch[ch_no].count =3D 1;
>> -		chl_map->ch[ch_no].start =3D ch_no;
>> -		offset +=3D len;
>> -		ch++;
>> +	/* Bump the key */
>> +	key =3D (u8)(frmr->mr->lkey & 0x000000FF);
>> +	ib_update_fast_reg_key(frmr->mr, ++key);
>> +
>> +	ctxt->sge[0].addr =3D (unsigned long)frmr->kva;
>> +	ctxt->sge[0].lkey =3D frmr->mr->lkey;
>> +	ctxt->sge[0].length =3D read;
>> +	ctxt->count =3D 1;
>> +	ctxt->read_hdr =3D head;
>> +
>> +	/* Prepare FASTREG WR */
>> +	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>> +	fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
>> +	fastreg_wr.send_flags =3D IB_SEND_SIGNALED;
>> +	fastreg_wr.wr.fast_reg.iova_start =3D (unsigned long)frmr->kva;
>> +	fastreg_wr.wr.fast_reg.page_list =3D frmr->page_list;
>> +	fastreg_wr.wr.fast_reg.page_list_len =3D frmr->page_list_len;
>> +	fastreg_wr.wr.fast_reg.page_shift =3D PAGE_SHIFT;
>> +	fastreg_wr.wr.fast_reg.length =3D frmr->map_len;
>> +	fastreg_wr.wr.fast_reg.access_flags =3D frmr->access_flags;
>> +	fastreg_wr.wr.fast_reg.rkey =3D frmr->mr->lkey;
>> +	fastreg_wr.next =3D &read_wr;
>> +
>> +	/* Prepare RDMA_READ */
>> +	memset(&read_wr, 0, sizeof(read_wr));
>> +	read_wr.send_flags =3D IB_SEND_SIGNALED;
>> +	read_wr.wr.rdma.rkey =3D rs_handle;
>> +	read_wr.wr.rdma.remote_addr =3D rs_offset;
>> +	read_wr.sg_list =3D ctxt->sge;
>> +	read_wr.num_sge =3D 1;
>> +	if (xprt->sc_dev_caps & SVCRDMA_DEVCAP_READ_W_INV) {
>> +		read_wr.opcode =3D IB_WR_RDMA_READ_WITH_INV;
>> +		read_wr.wr_id =3D (unsigned long)ctxt;
>> +		read_wr.ex.invalidate_rkey =3D ctxt->frmr->mr->lkey;
>> +	} else {
>> +		read_wr.opcode =3D IB_WR_RDMA_READ;
>> +		read_wr.next =3D &inv_wr;
>> +		/* Prepare invalidate */
>> +		memset(&inv_wr, 0, sizeof(inv_wr));
>> +		inv_wr.wr_id =3D (unsigned long)ctxt;
>> +		inv_wr.opcode =3D IB_WR_LOCAL_INV;
>> +		inv_wr.send_flags =3D IB_SEND_SIGNALED;
>> +		inv_wr.ex.invalidate_rkey =3D frmr->mr->lkey;
>> 	}
>> -
>> -	ret =3D svc_rdma_fastreg(xprt, frmr);
>> -	if (ret)
>> -		goto fatal_err;
>> -
>> -	return ch_no;
>> -
>> - fatal_err:
>> -	printk("svcrdma: error fast registering xdr for xprt %p", xprt);
>> -	svc_rdma_put_frmr(xprt, frmr);
>> -	return -EIO;
>> -}
>> -
>> -static int rdma_set_ctxt_sge(struct svcxprt_rdma *xprt,
>> -			     struct svc_rdma_op_ctxt *ctxt,
>> -			     struct svc_rdma_fastreg_mr *frmr,
>> -			     struct kvec *vec,
>> -			     u64 *sgl_offset,
>> -			     int count)
>> -{
>> -	int i;
>> -	unsigned long off;
>> -
>> -	ctxt->count =3D count;
>> -	ctxt->direction =3D DMA_FROM_DEVICE;
>> -	for (i =3D 0; i < count; i++) {
>> -		ctxt->sge[i].length =3D 0; /* in case map fails */
>> -		if (!frmr) {
>> -			BUG_ON(!virt_to_page(vec[i].iov_base));
>> -			off =3D (unsigned long)vec[i].iov_base & ~PAGE_MASK;
>> -			ctxt->sge[i].addr =3D
>> -				ib_dma_map_page(xprt->sc_cm_id->device,
>> -						virt_to_page(vec[i].iov_base),
>> -						off,
>> -						vec[i].iov_len,
>> -						DMA_FROM_DEVICE);
>> -			if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -						 ctxt->sge[i].addr))
>> -				return -EINVAL;
>> -			ctxt->sge[i].lkey =3D xprt->sc_dma_lkey;
>> -			atomic_inc(&xprt->sc_dma_used);
>> -		} else {
>> -			ctxt->sge[i].addr =3D (unsigned long)vec[i].iov_base;
>> -			ctxt->sge[i].lkey =3D frmr->mr->lkey;
>> -		}
>> -		ctxt->sge[i].length =3D vec[i].iov_len;
>> -		*sgl_offset =3D *sgl_offset + vec[i].iov_len;
>> +	ctxt->wr_op =3D read_wr.opcode;
>> +
>> +	/* Post the chain */
>> +	ret =3D svc_rdma_send(xprt, &fastreg_wr);
>> +	if (ret) {
>> +		pr_err("svcrdma: Error %d posting RDMA_READ\n", ret);
>> +		set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
>> +		goto err;
>> 	}
>> -	return 0;
>> -}
>> -
>> -static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_cou=
nt)
>> -{
>> -	if ((rdma_node_get_transport(xprt->sc_cm_id->device->node_type) =3D=
=3D
>> -	     RDMA_TRANSPORT_IWARP) &&
>> -	    sge_count > 1)
>> -		return 1;
>> -	else
>> -		return min_t(int, sge_count, xprt->sc_max_sge);
>> +	*page_no =3D pg_no;
>> +	*page_offset =3D pg_off;
>> +	ret =3D read;
>> +	atomic_inc(&rdma_stat_read);
>> +	return ret;
>> + err:
>> +	svc_rdma_unmap_dma(ctxt);
>> +	svc_rdma_put_context(ctxt, 0);
>> +	svc_rdma_put_frmr(xprt, frmr);
>> +	return ret;
>> }
>>=20
>> -/*
>> - * Use RDMA_READ to read data from the advertised client buffer int=
o the
>> - * XDR stream starting at rq_arg.head[0].iov_base.
>> - * Each chunk in the array
>> - * contains the following fields:
>> - * discrim      - '1', This isn't used for data placement
>> - * position     - The xdr stream offset (the same for every chunk)
>> - * handle       - RMR for client memory region
>> - * length       - data transfer length
>> - * offset       - 64 bit tagged offset in remote memory region
>> - *
>> - * On our side, we need to read into a pagelist. The first page imm=
ediately
>> - * follows the RPC header.
>> - *
>> - * This function returns:
>> - * 0 - No error and no read-list found.
>> - *
>> - * 1 - Successful read-list processing. The data is not yet in
>> - * the pagelist and therefore the RPC request must be deferred. The
>> - * I/O completion will enqueue the transport again and
>> - * svc_rdma_recvfrom will complete the request.
>> - *
>> - * <0 - Error processing/posting read-list.
>> - *
>> - * NOTE: The ctxt must not be touched after the last WR has been po=
sted
>> - * because the I/O completion processing may occur on another
>> - * processor and free / modify the context. Ne touche pas!
>> - */
>> -static int rdma_read_xdr(struct svcxprt_rdma *xprt,
>> -			 struct rpcrdma_msg *rmsgp,
>> -			 struct svc_rqst *rqstp,
>> -			 struct svc_rdma_op_ctxt *hdr_ctxt)
>> +static int rdma_read_chunks(struct svcxprt_rdma *xprt,
>> +			    struct rpcrdma_msg *rmsgp,
>> +			    struct svc_rqst *rqstp,
>> +			    struct svc_rdma_op_ctxt *head)
>> {
>> -	struct ib_send_wr read_wr;
>> -	struct ib_send_wr inv_wr;
>> -	int err =3D 0;
>> -	int ch_no;
>> -	int ch_count;
>> -	int byte_count;
>> -	int sge_count;
>> -	u64 sgl_offset;
>> +	int page_no, ch_count, ret;
>> 	struct rpcrdma_read_chunk *ch;
>> -	struct svc_rdma_op_ctxt *ctxt =3D NULL;
>> -	struct svc_rdma_req_map *rpl_map;
>> -	struct svc_rdma_req_map *chl_map;
>> +	u32 page_offset, byte_count;
>> +	u64 rs_offset;
>> +	rdma_reader_fn reader;
>>=20
>> 	/* If no read list is present, return 0 */
>> 	ch =3D svc_rdma_get_read_chunk(rmsgp);
>> @@ -408,122 +273,50 @@ static int rdma_read_xdr(struct svcxprt_rdma =
*xprt,
>> 	if (ch_count > RPCSVC_MAXPAGES)
>> 		return -EINVAL;
>>=20
>> -	/* Allocate temporary reply and chunk maps */
>> -	rpl_map =3D svc_rdma_get_req_map();
>> -	chl_map =3D svc_rdma_get_req_map();
>> -
>> -	if (!xprt->sc_frmr_pg_list_len)
>> -		sge_count =3D map_read_chunks(xprt, rqstp, hdr_ctxt, rmsgp,
>> -					    rpl_map, chl_map, ch_count,
>> -					    byte_count);
>> -	else
>> -		sge_count =3D fast_reg_read_chunks(xprt, rqstp, hdr_ctxt, rmsgp,
>> -						 rpl_map, chl_map, ch_count,
>> -						 byte_count);
>> -	if (sge_count < 0) {
>> -		err =3D -EIO;
>> -		goto out;
>> -	}
>> -
>> -	sgl_offset =3D 0;
>> -	ch_no =3D 0;
>> +	/* The request is completed when the RDMA_READs complete. The
>> +	 * head context keeps all the pages that comprise the
>> +	 * request.
>> +	 */
>> +	head->arg.head[0] =3D rqstp->rq_arg.head[0];
>> +	head->arg.tail[0] =3D rqstp->rq_arg.tail[0];
>> +	head->arg.pages =3D &head->pages[head->count];
>> +	head->hdr_count =3D head->count;
>> +	head->arg.page_base =3D 0;
>> +	head->arg.page_len =3D 0;
>> +	head->arg.len =3D rqstp->rq_arg.len;
>> +	head->arg.buflen =3D rqstp->rq_arg.buflen + PAGE_SIZE;
>>=20
>> +	page_no =3D 0; page_offset =3D 0;
>> 	for (ch =3D (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[=
0];
>> -	     ch->rc_discrim !=3D 0; ch++, ch_no++) {
>> -		u64 rs_offset;
>> -next_sge:
>> -		ctxt =3D svc_rdma_get_context(xprt);
>> -		ctxt->direction =3D DMA_FROM_DEVICE;
>> -		ctxt->frmr =3D hdr_ctxt->frmr;
>> -		ctxt->read_hdr =3D NULL;
>> -		clear_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
>> -		clear_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags);
>> -
>> -		/* Prepare READ WR */
>> -		memset(&read_wr, 0, sizeof read_wr);
>> -		read_wr.wr_id =3D (unsigned long)ctxt;
>> -		read_wr.opcode =3D IB_WR_RDMA_READ;
>> -		ctxt->wr_op =3D read_wr.opcode;
>> -		read_wr.send_flags =3D IB_SEND_SIGNALED;
>> -		read_wr.wr.rdma.rkey =3D ntohl(ch->rc_target.rs_handle);
>> +	     ch->rc_discrim !=3D 0; ch++) {
>> +		int sge_needed;
>> 		xdr_decode_hyper((__be32 *)&ch->rc_target.rs_offset,
>> 				 &rs_offset);
>> -		read_wr.wr.rdma.remote_addr =3D rs_offset + sgl_offset;
>> -		read_wr.sg_list =3D ctxt->sge;
>> -		read_wr.num_sge =3D
>> -			rdma_read_max_sge(xprt, chl_map->ch[ch_no].count);
>> -		err =3D rdma_set_ctxt_sge(xprt, ctxt, hdr_ctxt->frmr,
>> -					&rpl_map->sge[chl_map->ch[ch_no].start],
>> -					&sgl_offset,
>> -					read_wr.num_sge);
>> -		if (err) {
>> -			svc_rdma_unmap_dma(ctxt);
>> -			svc_rdma_put_context(ctxt, 0);
>> -			goto out;
>> +		byte_count =3D ntohl(ch->rc_target.rs_length);
>> +		/* Use FRMR if it's more efficient to do so. */
>> +		sge_needed =3D PAGE_ALIGN(byte_count) >> PAGE_SHIFT;
>> +		reader =3D rdma_read_chunk_frmr;
>> +		while (byte_count > 0) {
>> +			ret =3D reader(xprt, rqstp, head,
>> +				     &page_no, &page_offset,
>> +				     ntohl(ch->rc_target.rs_handle),
>> +				     byte_count, rs_offset,
>> +				     ((ch+1)->rc_discrim =3D=3D 0) /* last */
>> +				     );
>> +			if (ret < 0)
>> +				goto err;
>> +			byte_count -=3D ret;
>> +			rs_offset +=3D ret;
>> 		}
>> -		if (((ch+1)->rc_discrim =3D=3D 0) &&
>> -		    (read_wr.num_sge =3D=3D chl_map->ch[ch_no].count)) {
>> -			/*
>> -			 * Mark the last RDMA_READ with a bit to
>> -			 * indicate all RPC data has been fetched from
>> -			 * the client and the RPC needs to be enqueued.
>> -			 */
>> -			set_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
>> -			if (hdr_ctxt->frmr) {
>> -				set_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags);
>> -				/*
>> -				 * Invalidate the local MR used to map the data
>> -				 * sink.
>> -				 */
>> -				if (xprt->sc_dev_caps &
>> -				    SVCRDMA_DEVCAP_READ_W_INV) {
>> -					read_wr.opcode =3D
>> -						IB_WR_RDMA_READ_WITH_INV;
>> -					ctxt->wr_op =3D read_wr.opcode;
>> -					read_wr.ex.invalidate_rkey =3D
>> -						ctxt->frmr->mr->lkey;
>> -				} else {
>> -					/* Prepare INVALIDATE WR */
>> -					memset(&inv_wr, 0, sizeof inv_wr);
>> -					inv_wr.opcode =3D IB_WR_LOCAL_INV;
>> -					inv_wr.send_flags =3D IB_SEND_SIGNALED;
>> -					inv_wr.ex.invalidate_rkey =3D
>> -						hdr_ctxt->frmr->mr->lkey;
>> -					read_wr.next =3D &inv_wr;
>> -				}
>> -			}
>> -			ctxt->read_hdr =3D hdr_ctxt;
>> -		}
>> -		/* Post the read */
>> -		err =3D svc_rdma_send(xprt, &read_wr);
>> -		if (err) {
>> -			printk(KERN_ERR "svcrdma: Error %d posting RDMA_READ\n",
>> -			       err);
>> -			set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
>> -			svc_rdma_unmap_dma(ctxt);
>> -			svc_rdma_put_context(ctxt, 0);
>> -			goto out;
>> -		}
>> -		atomic_inc(&rdma_stat_read);
>> -
>> -		if (read_wr.num_sge < chl_map->ch[ch_no].count) {
>> -			chl_map->ch[ch_no].count -=3D read_wr.num_sge;
>> -			chl_map->ch[ch_no].start +=3D read_wr.num_sge;
>> -			goto next_sge;
>> -		}
>> -		sgl_offset =3D 0;
>> -		err =3D 1;
>> 	}
>> -
>> - out:
>> -	svc_rdma_put_req_map(rpl_map);
>> -	svc_rdma_put_req_map(chl_map);
>> -
>> +	ret =3D 1;
>> + err:
>> 	/* Detach arg pages. svc_recv will replenish them */
>> -	for (ch_no =3D 0; &rqstp->rq_pages[ch_no] < rqstp->rq_respages; ch=
_no++)
>> -		rqstp->rq_pages[ch_no] =3D NULL;
>> +	for (page_no =3D 0;
>> +	     &rqstp->rq_pages[page_no] < rqstp->rq_respages; page_no++)
>> +		rqstp->rq_pages[page_no] =3D NULL;
>>=20
>> -	return err;
>> +	return ret;
>> }
>>=20
>> static int rdma_read_complete(struct svc_rqst *rqstp,
>> @@ -595,13 +388,9 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
>> 				  struct svc_rdma_op_ctxt,
>> 				  dto_q);
>> 		list_del_init(&ctxt->dto_q);
>> -	}
>> -	if (ctxt) {
>> 		spin_unlock_bh(&rdma_xprt->sc_rq_dto_lock);
>> 		return rdma_read_complete(rqstp, ctxt);
>> -	}
>> -
>> -	if (!list_empty(&rdma_xprt->sc_rq_dto_q)) {
>> +	} else if (!list_empty(&rdma_xprt->sc_rq_dto_q)) {
>> 		ctxt =3D list_entry(rdma_xprt->sc_rq_dto_q.next,
>> 				  struct svc_rdma_op_ctxt,
>> 				  dto_q);
>> @@ -621,7 +410,6 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
>> 		if (test_bit(XPT_CLOSE, &xprt->xpt_flags))
>> 			goto close_out;
>>=20
>> -		BUG_ON(ret);
>> 		goto out;
>> 	}
>> 	dprintk("svcrdma: processing ctxt=3D%p on xprt=3D%p, rqstp=3D%p, st=
atus=3D%d\n",
>> @@ -644,12 +432,11 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
>> 	}
>>=20
>> 	/* Read read-list data. */
>> -	ret =3D rdma_read_xdr(rdma_xprt, rmsgp, rqstp, ctxt);
>> +	ret =3D rdma_read_chunks(rdma_xprt, rmsgp, rqstp, ctxt);
>> 	if (ret > 0) {
>> 		/* read-list posted, defer until data received from client. */
>> 		goto defer;
>> -	}
>> -	if (ret < 0) {
>> +	} else if (ret < 0) {
>> 		/* Post of read-list failed, free context. */
>> 		svc_rdma_put_context(ctxt, 1);
>> 		return 0;
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprt=
rdma/svc_rdma_sendto.c
>> index 7e024a5..49fd21a 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> @@ -1,4 +1,5 @@
>> /*
>> + * Copyright (c) 2014 Open Grid Computing, Inc. All rights reserved=
=2E
>>  * Copyright (c) 2005-2006 Network Appliance, Inc. All rights reserv=
ed.
>>  *
>>  * This software is available to you under a choice of one of two
>> @@ -49,152 +50,6 @@
>>=20
>> #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
>>=20
>> -/* Encode an XDR as an array of IB SGE
>> - *
>> - * Assumptions:
>> - * - head[0] is physically contiguous.
>> - * - tail[0] is physically contiguous.
>> - * - pages[] is not physically or virtually contiguous and consists=
 of
>> - *   PAGE_SIZE elements.
>> - *
>> - * Output:
>> - * SGE[0]              reserved for RCPRDMA header
>> - * SGE[1]              data from xdr->head[]
>> - * SGE[2..sge_count-2] data from xdr->pages[]
>> - * SGE[sge_count-1]    data from xdr->tail.
>> - *
>> - * The max SGE we need is the length of the XDR / pagesize + one fo=
r
>> - * head + one for tail + one for RPCRDMA header. Since RPCSVC_MAXPA=
GES
>> - * reserves a page for both the request and the reply header, and t=
his
>> - * array is only concerned with the reply we are assured that we ha=
ve
>> - * on extra page for the RPCRMDA header.
>> - */
>> -static int fast_reg_xdr(struct svcxprt_rdma *xprt,
>> -			struct xdr_buf *xdr,
>> -			struct svc_rdma_req_map *vec)
>> -{
>> -	int sge_no;
>> -	u32 sge_bytes;
>> -	u32 page_bytes;
>> -	u32 page_off;
>> -	int page_no =3D 0;
>> -	u8 *frva;
>> -	struct svc_rdma_fastreg_mr *frmr;
>> -
>> -	frmr =3D svc_rdma_get_frmr(xprt);
>> -	if (IS_ERR(frmr))
>> -		return -ENOMEM;
>> -	vec->frmr =3D frmr;
>> -
>> -	/* Skip the RPCRDMA header */
>> -	sge_no =3D 1;
>> -
>> -	/* Map the head. */
>> -	frva =3D (void *)((unsigned long)(xdr->head[0].iov_base) & PAGE_MA=
SK);
>> -	vec->sge[sge_no].iov_base =3D xdr->head[0].iov_base;
>> -	vec->sge[sge_no].iov_len =3D xdr->head[0].iov_len;
>> -	vec->count =3D 2;
>> -	sge_no++;
>> -
>> -	/* Map the XDR head */
>> -	frmr->kva =3D frva;
>> -	frmr->direction =3D DMA_TO_DEVICE;
>> -	frmr->access_flags =3D 0;
>> -	frmr->map_len =3D PAGE_SIZE;
>> -	frmr->page_list_len =3D 1;
>> -	page_off =3D (unsigned long)xdr->head[0].iov_base & ~PAGE_MASK;
>> -	frmr->page_list->page_list[page_no] =3D
>> -		ib_dma_map_page(xprt->sc_cm_id->device,
>> -				virt_to_page(xdr->head[0].iov_base),
>> -				page_off,
>> -				PAGE_SIZE - page_off,
>> -				DMA_TO_DEVICE);
>> -	if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -				 frmr->page_list->page_list[page_no]))
>> -		goto fatal_err;
>> -	atomic_inc(&xprt->sc_dma_used);
>> -
>> -	/* Map the XDR page list */
>> -	page_off =3D xdr->page_base;
>> -	page_bytes =3D xdr->page_len + page_off;
>> -	if (!page_bytes)
>> -		goto encode_tail;
>> -
>> -	/* Map the pages */
>> -	vec->sge[sge_no].iov_base =3D frva + frmr->map_len + page_off;
>> -	vec->sge[sge_no].iov_len =3D page_bytes;
>> -	sge_no++;
>> -	while (page_bytes) {
>> -		struct page *page;
>> -
>> -		page =3D xdr->pages[page_no++];
>> -		sge_bytes =3D min_t(u32, page_bytes, (PAGE_SIZE - page_off));
>> -		page_bytes -=3D sge_bytes;
>> -
>> -		frmr->page_list->page_list[page_no] =3D
>> -			ib_dma_map_page(xprt->sc_cm_id->device,
>> -					page, page_off,
>> -					sge_bytes, DMA_TO_DEVICE);
>> -		if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -					 frmr->page_list->page_list[page_no]))
>> -			goto fatal_err;
>> -
>> -		atomic_inc(&xprt->sc_dma_used);
>> -		page_off =3D 0; /* reset for next time through loop */
>> -		frmr->map_len +=3D PAGE_SIZE;
>> -		frmr->page_list_len++;
>> -	}
>> -	vec->count++;
>> -
>> - encode_tail:
>> -	/* Map tail */
>> -	if (0 =3D=3D xdr->tail[0].iov_len)
>> -		goto done;
>> -
>> -	vec->count++;
>> -	vec->sge[sge_no].iov_len =3D xdr->tail[0].iov_len;
>> -
>> -	if (((unsigned long)xdr->tail[0].iov_base & PAGE_MASK) =3D=3D
>> -	    ((unsigned long)xdr->head[0].iov_base & PAGE_MASK)) {
>> -		/*
>> -		 * If head and tail use the same page, we don't need
>> -		 * to map it again.
>> -		 */
>> -		vec->sge[sge_no].iov_base =3D xdr->tail[0].iov_base;
>> -	} else {
>> -		void *va;
>> -
>> -		/* Map another page for the tail */
>> -		page_off =3D (unsigned long)xdr->tail[0].iov_base & ~PAGE_MASK;
>> -		va =3D (void *)((unsigned long)xdr->tail[0].iov_base & PAGE_MASK)=
;
>> -		vec->sge[sge_no].iov_base =3D frva + frmr->map_len + page_off;
>> -
>> -		frmr->page_list->page_list[page_no] =3D
>> -		    ib_dma_map_page(xprt->sc_cm_id->device, virt_to_page(va),
>> -				    page_off,
>> -				    PAGE_SIZE,
>> -				    DMA_TO_DEVICE);
>> -		if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -					 frmr->page_list->page_list[page_no]))
>> -			goto fatal_err;
>> -		atomic_inc(&xprt->sc_dma_used);
>> -		frmr->map_len +=3D PAGE_SIZE;
>> -		frmr->page_list_len++;
>> -	}
>> -
>> - done:
>> -	if (svc_rdma_fastreg(xprt, frmr))
>> -		goto fatal_err;
>> -
>> -	return 0;
>> -
>> - fatal_err:
>> -	printk("svcrdma: Error fast registering memory for xprt %p\n", xpr=
t);
>> -	vec->frmr =3D NULL;
>> -	svc_rdma_put_frmr(xprt, frmr);
>> -	return -EIO;
>> -}
>> -
>> static int map_xdr(struct svcxprt_rdma *xprt,
>> 		   struct xdr_buf *xdr,
>> 		   struct svc_rdma_req_map *vec)
>> @@ -208,9 +63,6 @@ static int map_xdr(struct svcxprt_rdma *xprt,
>> 	BUG_ON(xdr->len !=3D
>> 	       (xdr->head[0].iov_len + xdr->page_len + xdr->tail[0].iov_len=
));
>>=20
>> -	if (xprt->sc_frmr_pg_list_len)
>> -		return fast_reg_xdr(xprt, xdr, vec);
>> -
>> 	/* Skip the first sge, this is for the RPCRDMA header */
>> 	sge_no =3D 1;
>>=20
>> @@ -282,8 +134,6 @@ static dma_addr_t dma_map_xdr(struct svcxprt_rdm=
a *xprt,
>> }
>>=20
>> /* Assumptions:
>> - * - We are using FRMR
>> - *     - or -
>>  * - The specified write_len can be represented in sc_max_sge * PAGE=
_SIZE
>>  */
>> static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rq=
stp,
>> @@ -327,23 +177,16 @@ static int send_write(struct svcxprt_rdma *xpr=
t, struct svc_rqst *rqstp,
>> 		sge_bytes =3D min_t(size_t,
>> 			  bc, vec->sge[xdr_sge_no].iov_len-sge_off);
>> 		sge[sge_no].length =3D sge_bytes;
>> -		if (!vec->frmr) {
>> -			sge[sge_no].addr =3D
>> -				dma_map_xdr(xprt, &rqstp->rq_res, xdr_off,
>> -					    sge_bytes, DMA_TO_DEVICE);
>> -			xdr_off +=3D sge_bytes;
>> -			if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> -						 sge[sge_no].addr))
>> -				goto err;
>> -			atomic_inc(&xprt->sc_dma_used);
>> -			sge[sge_no].lkey =3D xprt->sc_dma_lkey;
>> -		} else {
>> -			sge[sge_no].addr =3D (unsigned long)
>> -				vec->sge[xdr_sge_no].iov_base + sge_off;
>> -			sge[sge_no].lkey =3D vec->frmr->mr->lkey;
>> -		}
>> +		sge[sge_no].addr =3D
>> +			dma_map_xdr(xprt, &rqstp->rq_res, xdr_off,
>> +				    sge_bytes, DMA_TO_DEVICE);
>> +		xdr_off +=3D sge_bytes;
>> +		if (ib_dma_mapping_error(xprt->sc_cm_id->device,
>> +					 sge[sge_no].addr))
>> +			goto err;
>> +		atomic_inc(&xprt->sc_dma_used);
>> +		sge[sge_no].lkey =3D xprt->sc_dma_lkey;
>> 		ctxt->count++;
>> -		ctxt->frmr =3D vec->frmr;
>> 		sge_off =3D 0;
>> 		sge_no++;
>> 		xdr_sge_no++;
>> @@ -369,7 +212,6 @@ static int send_write(struct svcxprt_rdma *xprt,=
 struct svc_rqst *rqstp,
>> 	return 0;
>>  err:
>> 	svc_rdma_unmap_dma(ctxt);
>> -	svc_rdma_put_frmr(xprt, vec->frmr);
>> 	svc_rdma_put_context(ctxt, 0);
>> 	/* Fatal error, close transport */
>> 	return -EIO;
>> @@ -397,10 +239,7 @@ static int send_write_chunks(struct svcxprt_rdm=
a *xprt,
>> 	res_ary =3D (struct rpcrdma_write_array *)
>> 		&rdma_resp->rm_body.rm_chunks[1];
>>=20
>> -	if (vec->frmr)
>> -		max_write =3D vec->frmr->map_len;
>> -	else
>> -		max_write =3D xprt->sc_max_sge * PAGE_SIZE;
>> +	max_write =3D xprt->sc_max_sge * PAGE_SIZE;
>>=20
>> 	/* Write chunks start at the pagelist */
>> 	for (xdr_off =3D rqstp->rq_res.head[0].iov_len, chunk_no =3D 0;
>> @@ -472,10 +311,7 @@ static int send_reply_chunks(struct svcxprt_rdm=
a *xprt,
>> 	res_ary =3D (struct rpcrdma_write_array *)
>> 		&rdma_resp->rm_body.rm_chunks[2];
>>=20
>> -	if (vec->frmr)
>> -		max_write =3D vec->frmr->map_len;
>> -	else
>> -		max_write =3D xprt->sc_max_sge * PAGE_SIZE;
>> +	max_write =3D xprt->sc_max_sge * PAGE_SIZE;
>>=20
>> 	/* xdr offset starts at RPC message */
>> 	nchunks =3D ntohl(arg_ary->wc_nchunks);
>> @@ -545,7 +381,6 @@ static int send_reply(struct svcxprt_rdma *rdma,
>> 		      int byte_count)
>> {
>> 	struct ib_send_wr send_wr;
>> -	struct ib_send_wr inv_wr;
>> 	int sge_no;
>> 	int sge_bytes;
>> 	int page_no;
>> @@ -559,7 +394,6 @@ static int send_reply(struct svcxprt_rdma *rdma,
>> 		       "svcrdma: could not post a receive buffer, err=3D%d."
>> 		       "Closing transport %p.\n", ret, rdma);
>> 		set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
>> -		svc_rdma_put_frmr(rdma, vec->frmr);
>> 		svc_rdma_put_context(ctxt, 0);
>> 		return -ENOTCONN;
>> 	}
>> @@ -567,11 +401,6 @@ static int send_reply(struct svcxprt_rdma *rdma=
,
>> 	/* Prepare the context */
>> 	ctxt->pages[0] =3D page;
>> 	ctxt->count =3D 1;
>> -	ctxt->frmr =3D vec->frmr;
>> -	if (vec->frmr)
>> -		set_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags);
>> -	else
>> -		clear_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags);
>>=20
>> 	/* Prepare the SGE for the RPCRDMA Header */
>> 	ctxt->sge[0].lkey =3D rdma->sc_dma_lkey;
>> @@ -590,21 +419,15 @@ static int send_reply(struct svcxprt_rdma *rdm=
a,
>> 		int xdr_off =3D 0;
>> 		sge_bytes =3D min_t(size_t, vec->sge[sge_no].iov_len, byte_count);
>> 		byte_count -=3D sge_bytes;
>> -		if (!vec->frmr) {
>> -			ctxt->sge[sge_no].addr =3D
>> -				dma_map_xdr(rdma, &rqstp->rq_res, xdr_off,
>> -					    sge_bytes, DMA_TO_DEVICE);
>> -			xdr_off +=3D sge_bytes;
>> -			if (ib_dma_mapping_error(rdma->sc_cm_id->device,
>> -						 ctxt->sge[sge_no].addr))
>> -				goto err;
>> -			atomic_inc(&rdma->sc_dma_used);
>> -			ctxt->sge[sge_no].lkey =3D rdma->sc_dma_lkey;
>> -		} else {
>> -			ctxt->sge[sge_no].addr =3D (unsigned long)
>> -				vec->sge[sge_no].iov_base;
>> -			ctxt->sge[sge_no].lkey =3D vec->frmr->mr->lkey;
>> -		}
>> +		ctxt->sge[sge_no].addr =3D
>> +			dma_map_xdr(rdma, &rqstp->rq_res, xdr_off,
>> +				    sge_bytes, DMA_TO_DEVICE);
>> +		xdr_off +=3D sge_bytes;
>> +		if (ib_dma_mapping_error(rdma->sc_cm_id->device,
>> +					 ctxt->sge[sge_no].addr))
>> +			goto err;
>> +		atomic_inc(&rdma->sc_dma_used);
>> +		ctxt->sge[sge_no].lkey =3D rdma->sc_dma_lkey;
>> 		ctxt->sge[sge_no].length =3D sge_bytes;
>> 	}
>> 	BUG_ON(byte_count !=3D 0);
>> @@ -627,6 +450,7 @@ static int send_reply(struct svcxprt_rdma *rdma,
>> 			ctxt->sge[page_no+1].length =3D 0;
>> 	}
>> 	rqstp->rq_next_page =3D rqstp->rq_respages + 1;
>> +
>> 	BUG_ON(sge_no > rdma->sc_max_sge);
>> 	memset(&send_wr, 0, sizeof send_wr);
>> 	ctxt->wr_op =3D IB_WR_SEND;
>> @@ -635,15 +459,6 @@ static int send_reply(struct svcxprt_rdma *rdma=
,
>> 	send_wr.num_sge =3D sge_no;
>> 	send_wr.opcode =3D IB_WR_SEND;
>> 	send_wr.send_flags =3D  IB_SEND_SIGNALED;
>> -	if (vec->frmr) {
>> -		/* Prepare INVALIDATE WR */
>> -		memset(&inv_wr, 0, sizeof inv_wr);
>> -		inv_wr.opcode =3D IB_WR_LOCAL_INV;
>> -		inv_wr.send_flags =3D IB_SEND_SIGNALED;
>> -		inv_wr.ex.invalidate_rkey =3D
>> -			vec->frmr->mr->lkey;
>> -		send_wr.next =3D &inv_wr;
>> -	}
>>=20
>> 	ret =3D svc_rdma_send(rdma, &send_wr);
>> 	if (ret)
>> @@ -653,7 +468,6 @@ static int send_reply(struct svcxprt_rdma *rdma,
>>=20
>>  err:
>> 	svc_rdma_unmap_dma(ctxt);
>> -	svc_rdma_put_frmr(rdma, vec->frmr);
>> 	svc_rdma_put_context(ctxt, 1);
>> 	return -EIO;
>> }
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/x=
prtrdma/svc_rdma_transport.c
>> index 25688fa..5ee8430 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -1,4 +1,5 @@
>> /*
>> + * Copyright (c) 2014 Open Grid Computing, Inc. All rights reserved=
=2E
>>  * Copyright (c) 2005-2007 Network Appliance, Inc. All rights reserv=
ed.
>>  *
>>  * This software is available to you under a choice of one of two
>> @@ -160,7 +161,6 @@ struct svc_rdma_req_map *svc_rdma_get_req_map(vo=
id)
>> 		schedule_timeout_uninterruptible(msecs_to_jiffies(500));
>> 	}
>> 	map->count =3D 0;
>> -	map->frmr =3D NULL;
>> 	return map;
>> }
>>=20
>> @@ -336,22 +336,21 @@ static void process_context(struct svcxprt_rdm=
a *xprt,
>>=20
>> 	switch (ctxt->wr_op) {
>> 	case IB_WR_SEND:
>> -		if (test_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags))
>> -			svc_rdma_put_frmr(xprt, ctxt->frmr);
>> +		BUG_ON(ctxt->frmr);
>> 		svc_rdma_put_context(ctxt, 1);
>> 		break;
>>=20
>> 	case IB_WR_RDMA_WRITE:
>> +		BUG_ON(ctxt->frmr);
>> 		svc_rdma_put_context(ctxt, 0);
>> 		break;
>>=20
>> 	case IB_WR_RDMA_READ:
>> 	case IB_WR_RDMA_READ_WITH_INV:
>> +		svc_rdma_put_frmr(xprt, ctxt->frmr);
>> 		if (test_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags)) {
>> 			struct svc_rdma_op_ctxt *read_hdr =3D ctxt->read_hdr;
>> 			BUG_ON(!read_hdr);
>> -			if (test_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags))
>> -				svc_rdma_put_frmr(xprt, ctxt->frmr);
>> 			spin_lock_bh(&xprt->sc_rq_dto_lock);
>> 			set_bit(XPT_DATA, &xprt->sc_xprt.xpt_flags);
>> 			list_add_tail(&read_hdr->dto_q,
>> @@ -363,6 +362,7 @@ static void process_context(struct svcxprt_rdma =
*xprt,
>> 		break;
>>=20
>> 	default:
>> +		BUG_ON(1);
>> 		printk(KERN_ERR "svcrdma: unexpected completion type, "
>> 		       "opcode=3D%d\n",
>> 		       ctxt->wr_op);
>> @@ -378,29 +378,39 @@ static void process_context(struct svcxprt_rdm=
a *xprt,
>> static void sq_cq_reap(struct svcxprt_rdma *xprt)
>> {
>> 	struct svc_rdma_op_ctxt *ctxt =3D NULL;
>> -	struct ib_wc wc;
>> +	struct ib_wc wc_a[6];
>> +	struct ib_wc *wc;
>> 	struct ib_cq *cq =3D xprt->sc_sq_cq;
>> 	int ret;
>>=20
>> +	memset(wc_a, 0, sizeof(wc_a));
>> +
>> 	if (!test_and_clear_bit(RDMAXPRT_SQ_PENDING, &xprt->sc_flags))
>> 		return;
>>=20
>> 	ib_req_notify_cq(xprt->sc_sq_cq, IB_CQ_NEXT_COMP);
>> 	atomic_inc(&rdma_stat_sq_poll);
>> -	while ((ret =3D ib_poll_cq(cq, 1, &wc)) > 0) {
>> -		if (wc.status !=3D IB_WC_SUCCESS)
>> -			/* Close the transport */
>> -			set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
>> -
>> -		/* Decrement used SQ WR count */
>> -		atomic_dec(&xprt->sc_sq_count);
>> -		wake_up(&xprt->sc_send_wait);
>> +	while ((ret =3D ib_poll_cq(cq, ARRAY_SIZE(wc_a), wc_a)) > 0) {
>> +		int i;
>> +
>> +		for (i =3D 0; i < ret; i++) {
>> +			wc =3D &wc_a[i];
>> +			if (wc->status !=3D IB_WC_SUCCESS) {
>> +				/* Close the transport */
>> +				set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
>> +			}
>> +
>> +			/* Decrement used SQ WR count */
>> +			atomic_dec(&xprt->sc_sq_count);
>> +			wake_up(&xprt->sc_send_wait);
>>=20
>> -		ctxt =3D (struct svc_rdma_op_ctxt *)(unsigned long)wc.wr_id;
>> -		if (ctxt)
>> -			process_context(xprt, ctxt);
>> +			ctxt =3D (struct svc_rdma_op_ctxt *)
>> +				(unsigned long)wc->wr_id;
>> +			if (ctxt)
>> +				process_context(xprt, ctxt);
>>=20
>> -		svc_xprt_put(&xprt->sc_xprt);
>> +			svc_xprt_put(&xprt->sc_xprt);
>> +		}
>> 	}
>>=20
>> 	if (ctxt)
>> @@ -1040,7 +1050,7 @@ static struct svc_xprt *svc_rdma_accept(struct=
 svc_xprt *xprt)
>> 	/* Accept Connection */
>> 	set_bit(RDMAXPRT_CONN_PENDING, &newxprt->sc_flags);
>> 	memset(&conn_param, 0, sizeof conn_param);
>> -	conn_param.responder_resources =3D 0;
>> +	conn_param.responder_resources =3D 1;
>> 	conn_param.initiator_depth =3D newxprt->sc_ord;
>> 	ret =3D rdma_accept(newxprt->sc_cm_id, &conn_param);
>> 	if (ret) {
>> @@ -1190,14 +1200,7 @@ static int svc_rdma_has_wspace(struct svc_xpr=
t *xprt)
>> 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
>>=20
>> 	/*
>> -	 * If there are fewer SQ WR available than required to send a
>> -	 * simple response, return false.
>> -	 */
>> -	if ((rdma->sc_sq_depth - atomic_read(&rdma->sc_sq_count) < 3))
>> -		return 0;
>> -
>> -	/*
>> -	 * ...or there are already waiters on the SQ,
>> +	 * If there are already waiters on the SQ,
>> 	 * return false.
>> 	 */
>> 	if (waitqueue_active(&rdma->sc_send_wait))
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
