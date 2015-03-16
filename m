From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 05/16] xprtrdma: Add a "register_external" op for each
 memreg mode
Date: Mon, 16 Mar 2015 20:15:23 +0200
Message-ID: <55071DBB.4050500@dev.mellanox.co.il>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212718.22783.10096.stgit@manet.1015granger.net> <5506B036.1040905@dev.mellanox.co.il> <982A021D-1B85-4AAF-89A3-302A21CF2B36@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <982A021D-1B85-4AAF-89A3-302A21CF2B36-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/16/2015 6:48 PM, Chuck Lever wrote:
>
> On Mar 16, 2015, at 3:28 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>
>> On 3/13/2015 11:27 PM, Chuck Lever wrote:
>>> There is very little common processing among the different external
>>> memory registration functions. Have rpcrdma_create_chunks() call
>>> the registration method directly. This removes a stack frame and a
>>> switch statement from the external registration path.
>>>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   net/sunrpc/xprtrdma/fmr_ops.c      |   51 +++++++++++
>>>   net/sunrpc/xprtrdma/frwr_ops.c     |   88 ++++++++++++++++++
>>>   net/sunrpc/xprtrdma/physical_ops.c |   17 ++++
>>>   net/sunrpc/xprtrdma/rpc_rdma.c     |    5 +
>>>   net/sunrpc/xprtrdma/verbs.c        |  172 +----------------------=
-------------
>>>   net/sunrpc/xprtrdma/xprt_rdma.h    |    6 +
>>>   6 files changed, 166 insertions(+), 173 deletions(-)
>>>
>>> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fm=
r_ops.c
>>> index eec2660..45fb646 100644
>>> --- a/net/sunrpc/xprtrdma/fmr_ops.c
>>> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
>>> @@ -29,7 +29,58 @@ fmr_op_maxpages(struct rpcrdma_xprt *r_xprt)
>>>   		     rpcrdma_max_segments(r_xprt) * RPCRDMA_MAX_FMR_SGES);
>>>   }
>>>
>>> +/* Use the ib_map_phys_fmr() verb to register a memory region
>>> + * for remote access via RDMA READ or RDMA WRITE.
>>> + */
>>> +static int
>>> +fmr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg=
,
>>> +	   int nsegs, bool writing)
>>> +{
>>> +	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>> +	struct rpcrdma_mr_seg *seg1 =3D seg;
>>> +	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>>> +	u64 physaddrs[RPCRDMA_MAX_DATA_SEGS];
>>> +	int len, pageoff, i, rc;
>>> +
>>> +	pageoff =3D offset_in_page(seg1->mr_offset);
>>> +	seg1->mr_offset -=3D pageoff;	/* start of page */
>>> +	seg1->mr_len +=3D pageoff;
>>> +	len =3D -pageoff;
>>> +	if (nsegs > RPCRDMA_MAX_FMR_SGES)
>>> +		nsegs =3D RPCRDMA_MAX_FMR_SGES;
>>> +	for (i =3D 0; i < nsegs;) {
>>> +		rpcrdma_map_one(ia, seg, writing);
>>> +		physaddrs[i] =3D seg->mr_dma;
>>> +		len +=3D seg->mr_len;
>>> +		++seg;
>>> +		++i;
>>> +		/* Check for holes */
>>> +		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
>>> +		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>>> +			break;
>>> +	}
>>> +
>>> +	rc =3D ib_map_phys_fmr(mw->r.fmr, physaddrs, i, seg1->mr_dma);
>>> +	if (rc)
>>> +		goto out_maperr;
>>> +
>>> +	seg1->mr_rkey =3D mw->r.fmr->rkey;
>>> +	seg1->mr_base =3D seg1->mr_dma + pageoff;
>>> +	seg1->mr_nsegs =3D i;
>>> +	seg1->mr_len =3D len;
>>> +	return i;
>>> +
>>> +out_maperr:
>>> +	dprintk("RPC:       %s: ib_map_phys_fmr %u@0x%llx+%i (%d) status =
%i\n",
>>> +		__func__, len, (unsigned long long)seg1->mr_dma,
>>> +		pageoff, i, rc);
>>> +	while (i--)
>>> +		rpcrdma_unmap_one(ia, --seg);
>>> +	return rc;
>>> +}
>>> +
>>>   const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops =3D {
>>> +	.ro_map				=3D fmr_op_map,
>>>   	.ro_maxpages			=3D fmr_op_maxpages,
>>>   	.ro_displayname			=3D "fmr",
>>>   };
>>> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/f=
rwr_ops.c
>>> index 73a5ac8..2b5ccb0 100644
>>> --- a/net/sunrpc/xprtrdma/frwr_ops.c
>>> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
>>> @@ -29,7 +29,95 @@ frwr_op_maxpages(struct rpcrdma_xprt *r_xprt)
>>>   		     rpcrdma_max_segments(r_xprt) * ia->ri_max_frmr_depth);
>>>   }
>>>
>>> +/* Post a FAST_REG Work Request to register a memory region
>>> + * for remote access via RDMA READ or RDMA WRITE.
>>> + */
>>> +static int
>>> +frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *se=
g,
>>> +	    int nsegs, bool writing)
>>> +{
>>> +	struct rpcrdma_ia *ia =3D &r_xprt->rx_ia;
>>> +	struct rpcrdma_mr_seg *seg1 =3D seg;
>>> +	struct rpcrdma_mw *mw =3D seg1->rl_mw;
>>> +	struct rpcrdma_frmr *frmr =3D &mw->r.frmr;
>>> +	struct ib_mr *mr =3D frmr->fr_mr;
>>> +	struct ib_send_wr fastreg_wr, *bad_wr;
>>> +	u8 key;
>>> +	int len, pageoff;
>>> +	int i, rc;
>>> +	int seg_len;
>>> +	u64 pa;
>>> +	int page_no;
>>> +
>>> +	pageoff =3D offset_in_page(seg1->mr_offset);
>>> +	seg1->mr_offset -=3D pageoff;	/* start of page */
>>> +	seg1->mr_len +=3D pageoff;
>>> +	len =3D -pageoff;
>>> +	if (nsegs > ia->ri_max_frmr_depth)
>>> +		nsegs =3D ia->ri_max_frmr_depth;
>>> +	for (page_no =3D i =3D 0; i < nsegs;) {
>>> +		rpcrdma_map_one(ia, seg, writing);
>>> +		pa =3D seg->mr_dma;
>>> +		for (seg_len =3D seg->mr_len; seg_len > 0; seg_len -=3D PAGE_SIZ=
E) {
>>> +			frmr->fr_pgl->page_list[page_no++] =3D pa;
>>> +			pa +=3D PAGE_SIZE;
>>> +		}
>>> +		len +=3D seg->mr_len;
>>> +		++seg;
>>> +		++i;
>>> +		/* Check for holes */
>>> +		if ((i < nsegs && offset_in_page(seg->mr_offset)) ||
>>> +		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
>>> +			break;
>>> +	}
>>> +	dprintk("RPC:       %s: Using frmr %p to map %d segments\n",
>>> +		__func__, mw, i);
>>> +
>>> +	frmr->fr_state =3D FRMR_IS_VALID;
>>> +
>>> +	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
>>> +	fastreg_wr.wr_id =3D (unsigned long)(void *)mw;
>>> +	fastreg_wr.opcode =3D IB_WR_FAST_REG_MR;
>>> +	fastreg_wr.wr.fast_reg.iova_start =3D seg1->mr_dma;
>>> +	fastreg_wr.wr.fast_reg.page_list =3D frmr->fr_pgl;
>>> +	fastreg_wr.wr.fast_reg.page_shift =3D PAGE_SHIFT;
>>> +	fastreg_wr.wr.fast_reg.page_list_len =3D page_no;
>>> +	fastreg_wr.wr.fast_reg.length =3D page_no << PAGE_SHIFT;
>>
>> Umm, is this necessarily true? will the region length be full pages?
>> Why don't you assign fast_reg.length =3D len?
>> I might be missing something here=85
>
> Don=92t know. This goes back to when FRWR was introduced in this code=
,
> with commit 3197d309 in 2008.

I see.

So from inspecting at the code it seems that if you had a buffer of
length PAGE_SIZE + 512, the client would register two pages. So in case
the server attempts a write that exceeds this length the client might
get a data corruption instead of a much nicer remote access error
completion...

But then again, I may be missing something here...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
