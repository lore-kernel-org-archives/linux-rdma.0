From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/9] IB/mlx4: Don't return errors from poll_cq
Date: Sun, 28 Aug 2016 19:05:51 +0300
Message-ID: <82f1a1be-1189-c8c6-b134-d2f582cc7fa0@grimberg.me>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-5-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>  		/* SRQ is also in the radix tree */
>  		msrq = mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
>  				       srq_num);
> -		if (unlikely(!msrq)) {
> -			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
> -				cq->mcq.cqn, srq_num);
> -			return -EINVAL;
> -		}
>  	}

BTW, this is completely unrelated to this patch, but the current
implementation of shared receive queues in Mellanox drivers is
*very* inefficient. Each completion that relates to a srq the
mlx4/mlx5 drivers perform a device-wide locked srq lookup which
is pretty bad... (it kills consumers that want to use more
then one SRQ)

Other drivers that support kernel SRQs that I've looked at are ocrdma 
and i40iw and they don't seem to have this lock everything approach.

At the very-least we should try to make it a rcu + percpu_ref
instead of a killer device-wide lock. It'd be even better if
we use refcounting in the IB core and have the drivers not worry
about the kernel consumers destroying SRQs while processing IO
(i.e. when all the related QPs and CQs are destroyed).

I have some code in the works on this but it's not high on my todo
list at the moment. Mellanox folks, any thoughts on this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
