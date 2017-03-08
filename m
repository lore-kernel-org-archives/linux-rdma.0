From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Wed, 8 Mar 2017 23:27:51 +0200
Message-ID: <6571cf34-63b9-7b83-ddb0-9279e7e20fa9@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
 <20170307191824.GD2228@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170307191824.GD2228-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/7/2017 9:18 PM, Jason Gunthorpe wrote:
>>> +static inline void mmio_wc_spinunlock(pthread_spinlock_t *lock)
>>> +{
>>> +	/* On x86 the lock is enough for strong ordering, but the SFENCE
>>> +	 * encourages the WC buffers to flush out more quickly (Yishai:
>>> +	 * confirm?) */
>>
>> This macro can't do both and should be dropped, see above.
>
> I don't understand this comment? Why can't it do both?

This macro made the flush and just later made the spin_unlock without 
letting any command to be executed between them, logically there is no 
reason for such a limitation.

As of that any command that needs the lock must be done before the flush 
and delays the hardware from see the BF data immediately.

Specifically, in both mlx4 and mlx5 the original code was to flush just 
after the BF copy then under the spinlock toggle the bf_offset (i.e. 
ctx->bf_offset ^= ctx->bf_buf_size) and finally unlock.

That's why this macro is bad, I'll drop this macro and preserve the 
original logic with the other new macros.

Similar logical issue might be with the mmio_wc_spinlock macro in case 
the driver wants to make some command after the lock before the 
start_mmio, currently there is no such use case so basically I'm fine 
with staying with it.

> diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
> index 77a4a34576cb69..a22fca7c6f1360 100644
> --- a/providers/mlx4/qp.c
> +++ b/providers/mlx4/qp.c
> @@ -477,23 +477,20 @@ out:
>  		ctrl->owner_opcode |= htonl((qp->sq.head & 0xffff) << 8);
>
>  		ctrl->bf_qpn |= qp->doorbell_qpn;
> +		++qp->sq.head;
> +

This is a change comparing the original code where was wmb() before that 
line to enforce the compiler not to change the order so that 
ctrl->owner_opcode will get the correct value of sq.head.
Will add here udma_to_device_barrier() which logically expects to do the 
same.

>  		/*
>  		 * Make sure that descriptor is written to memory
>  		 * before writing to BlueFlame page.
>  		 */
> -		mmio_wc_start();
> -
> -		++qp->sq.head;
> -
> -		pthread_spin_lock(&ctx->bf_lock);
> +		mmio_wc_spinlock(&ctx->bf_lock);
>
>  		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
>  			     align(size * 16, 64));
> -		mmio_flush_writes();
>
>  		ctx->bf_offset ^= ctx->bf_buf_size;
>
> -		pthread_spin_unlock(&ctx->bf_lock);
> +		mmio_wc_spinunlock(&ctx->bf_lock);
>  	} else if (nreq) {
>  		qp->sq.head += nreq;
>
> diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
> index d7087d986ce79f..0f1ec0ef2b094b 100644
> --- a/providers/mlx5/qp.c
> +++ b/providers/mlx5/qp.c
> @@ -931,11 +931,11 @@ out:
>
>  		/* Make sure that the doorbell write happens before the memcpy
>  		 * to WC memory below */
> -		mmio_wc_start();
> -
>  		ctx = to_mctx(ibqp->context);
> -		if (bf->need_lock)
> -			mlx5_spin_lock(&bf->lock);
> +		if (bf->need_lock && !mlx5_single_threaded)

Can consider some pre-patch which will encapsulate the 
mlx5_single_threaded flag into the bf->need lock, it will prevent the 
extra if statement that this new code introduced in the data path.

> +			mmio_wc_spinlock(&bf->lock.lock);
> +		else
> +			mmio_wc_start();
>
>  		if (!ctx->shut_up_bf && nreq == 1 && bf->uuarn &&
>  		    (inl || ctx->prefer_bf) && size > 1 &&
> @@ -955,10 +955,11 @@ out:
>  		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
>  		 * doorbell 2, followed by doorbell 1.
>  		 */
> -		mmio_flush_writes();
>  		bf->offset ^= bf->buf_size;
> -		if (bf->need_lock)
> -			mlx5_spin_unlock(&bf->lock);
> +		if (bf->need_lock && !mlx5_single_threaded)

Same as of above.
> +			mmio_wc_spinunlock(&bf->lock.lock);
> +		else
> +			mmio_flush_writes();
>  	}
>
> +static inline void mmio_wc_spinunlock(pthread_spinlock_t *lock)
> +{
> +	/* On x86 the lock is enough for strong ordering, but the SFENCE
> +	 * encourages the WC buffers to flush out more quickly (Yishai:
> +	 * confirm?) */
> +	mmio_flush_writes();
> +	pthread_spin_unlock(lock);

See above comment on that.
> +}
> +
>  #endif
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
