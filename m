From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible send queue overflow
Date: Thu, 15 Oct 2015 08:35:17 -0700
Message-ID: <561FC7B5.8010103@sandisk.com>
References: <1444901206-27462-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444901206-27462-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/15/2015 02:26 AM, Sagi Grimberg wrote:
> When using work request based memory registration (fast_reg)
> we must reserve SQ entries for registration and invalidation
> in addition to send operations. Each IO consumes 3 SQ entries
> (registration, send, invalidation) so we need to allocate 3x
> larger send-queue instead of 2x.
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> CC: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index d00f819..43b07f7 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -488,7 +488,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
>   	struct ib_qp *qp;
>   	struct ib_fmr_pool *fmr_pool = NULL;
>   	struct srp_fr_pool *fr_pool = NULL;
> -	const int m = 1 + dev->use_fast_reg;
> +	const int m = dev->use_fast_reg ? 3 : 1;
>   	struct ib_cq_init_attr cq_attr = {};
>   	int ret;
>

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
