From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: fix spelling mistake: "Maximim" -> "Maximum"
Date: Tue, 8 Aug 2017 14:18:35 -0400
Message-ID: <a4b6438a-bc4f-53bb-192e-559fa2ccdf24@intel.com>
References: <20170805131150.32717-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170805131150.32717-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/5/2017 9:11 AM, Colin King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> Trivial fix to spelling mistake in pr_warn_ratelimited warning message
> 
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>   drivers/infiniband/hw/hfi1/mad.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 0a3e2dfdf56e..cb0bb69310e1 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -172,7 +172,7 @@ static struct trap_node *check_and_add_trap(struct hfi1_ibport *ibp,
>   			trap_list->list_len++;
>   			list_add_tail(&trap->list, &trap_list->list);
>   		} else {
> -			pr_warn_ratelimited("hfi1: Maximim trap limit reached for 0x%0x traps\n",
> +			pr_warn_ratelimited("hfi1: Maximum trap limit reached for 0x%0x traps\n",
>   					    trap->data.generic_type);
>   			kfree(trap);
>   		}
> 

Thanks!

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
