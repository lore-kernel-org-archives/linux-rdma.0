From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Wed, 1 Mar 2017 11:29:20 -0600
Message-ID: <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487272989-8215-7-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 16, 2017 at 12:23:01PM -0700, Jason Gunthorpe wrote:
> Use our standard versions from util instead. There doesn't seem
> to be anything tricky here, but the inlined versions were like our
> wc_wmb() barriers, not the wmb().
> 
> There appears to be no WC memory in this driver, so despite the comments,
> these barriers are also making sure that user DMA data is flushed out. Make
> them all wmb()
> 
> Guess at where the missing rmb() should be.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/i40iw/i40iw_osdep.h | 14 --------------
>  providers/i40iw/i40iw_uk.c    | 26 ++++++++++++++------------
>  2 files changed, 14 insertions(+), 26 deletions(-)
> 
> diff --git a/providers/i40iw/i40iw_osdep.h b/providers/i40iw/i40iw_osdep.h
> index fddedf40dd8ae2..92bedd31633eb5 100644
> --- a/providers/i40iw/i40iw_osdep.h
> +++ b/providers/i40iw/i40iw_osdep.h
> @@ -105,18 +105,4 @@ static inline void db_wr32(u32 value, u32 *wqe_word)
>  #define ACQUIRE_LOCK()
>  #define RELEASE_LOCK()
>  
> -#if defined(__i386__)
> -#define i40iw_mb() mb()		/* full memory barrier */
> -#define i40iw_wmb() mb()	/* write memory barrier */
> -#elif defined(__x86_64__)
> -#define i40iw_mb() asm volatile("mfence" ::: "memory")	 /* full memory barrier */
> -#define i40iw_wmb() asm volatile("sfence" ::: "memory")	 /* write memory barrier */
> -#else
> -#define i40iw_mb() mb()		/* full memory barrier */
> -#define i40iw_wmb() wmb()	/* write memory barrier */
> -#endif
> -#define i40iw_rmb() rmb()	/* read memory barrier */
> -#define i40iw_smp_mb() smp_mb()		/* memory barrier */
> -#define i40iw_smp_wmb() smp_wmb()	/* write memory barrier */
> -#define i40iw_smp_rmb() smp_rmb()	/* read memory barrier */
>  #endif				/* _I40IW_OSDEP_H_ */
> diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
> index d3e4fec7d8515b..b20748e9f09199 100644
> --- a/providers/i40iw/i40iw_uk.c
> +++ b/providers/i40iw/i40iw_uk.c
> @@ -75,7 +75,7 @@ static enum i40iw_status_code i40iw_nop_1(struct i40iw_qp_uk *qp)
>  	    LS_64(signaled, I40IWQPSQ_SIGCOMPL) |
>  	    LS_64(qp->swqe_polarity, I40IWQPSQ_VALID) | nop_signature++;
>  
> -	i40iw_wmb();	/* Memory barrier to ensure data is written before valid bit is set */
> +	udma_to_device_barrier();	/* Memory barrier to ensure data is written before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  	return 0;
> @@ -91,7 +91,7 @@ void i40iw_qp_post_wr(struct i40iw_qp_uk *qp)
>  	u32 hw_sq_tail;
>  	u32 sw_sq_head;
>  
> -	i40iw_mb(); /* valid bit is written and loads completed before reading shadow */
> +	udma_to_device_barrier(); /* valid bit is written and loads completed before reading shadow */

The constraint here is that the writes to SQ WQE must be globally visible to the 
PCIe device before the read of the shadow area. For x86, since loads can be reordered 
with older stores to a different location, we need some sort of a storeload barrier to 
enforce the constraint and hence the mfence was chosen. The udma_to_device_barrier() 
equates to just a compiler barrier on x86 and isn't sufficient for this purpose.

>  
>  	/* read the doorbell shadow area */
>  	get_64bit_val(qp->shadow_area, I40IW_BYTE_0, &temp);
> @@ -297,7 +297,7 @@ static enum i40iw_status_code i40iw_rdma_write(struct i40iw_qp_uk *qp,
>  		byte_off += 16;
>  	}
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -347,7 +347,7 @@ static enum i40iw_status_code i40iw_rdma_read(struct i40iw_qp_uk *qp,
>  
>  	i40iw_set_fragment(wqe, I40IW_BYTE_0, &op_info->lo_addr);
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  	if (post_sq)
> @@ -410,7 +410,7 @@ static enum i40iw_status_code i40iw_send(struct i40iw_qp_uk *qp,
>  		byte_off += 16;
>  	}
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  	if (post_sq)
> @@ -478,7 +478,7 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
>  		memcpy(dest, src, op_info->len - I40IW_BYTE_16);
>  	}
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -552,7 +552,7 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
>  		memcpy(dest, src, op_info->len - I40IW_BYTE_16);
>  	}
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -601,7 +601,7 @@ static enum i40iw_status_code i40iw_stag_local_invalidate(struct i40iw_qp_uk *qp
>  	    LS_64(info->signaled, I40IWQPSQ_SIGCOMPL) |
>  	    LS_64(qp->swqe_polarity, I40IWQPSQ_VALID);
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -650,7 +650,7 @@ static enum i40iw_status_code i40iw_mw_bind(struct i40iw_qp_uk *qp,
>  	    LS_64(info->signaled, I40IWQPSQ_SIGCOMPL) |
>  	    LS_64(qp->swqe_polarity, I40IWQPSQ_VALID);
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -694,7 +694,7 @@ static enum i40iw_status_code i40iw_post_receive(struct i40iw_qp_uk *qp,
>  		byte_off += 16;
>  	}
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  
> @@ -731,7 +731,7 @@ static void i40iw_cq_request_notification(struct i40iw_cq_uk *cq,
>  
>  	set_64bit_val(cq->shadow_area, I40IW_BYTE_32, temp_val);
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	db_wr32(cq->cq_id, cq->cqe_alloc_reg);
>  }
> @@ -780,6 +780,8 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
>  	if (polarity != cq->polarity)
>  		return I40IW_ERR_QUEUE_EMPTY;
>  
> +	udma_from_device_barrier();
> +
>  	q_type = (u8)RS_64(qword3, I40IW_CQ_SQ);
>  	info->error = (bool)RS_64(qword3, I40IW_CQ_ERROR);
>  	info->push_dropped = (bool)RS_64(qword3, I40IWCQ_PSHDROP);
> @@ -1121,7 +1123,7 @@ enum i40iw_status_code i40iw_nop(struct i40iw_qp_uk *qp,
>  	    LS_64(signaled, I40IWQPSQ_SIGCOMPL) |
>  	    LS_64(qp->swqe_polarity, I40IWQPSQ_VALID);
>  
> -	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
> +	udma_to_device_barrier(); /* make sure WQE is populated before valid bit is set */
>  
>  	set_64bit_val(wqe, I40IW_BYTE_24, header);
>  	if (post_sq)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
