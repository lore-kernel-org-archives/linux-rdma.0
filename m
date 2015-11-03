From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/srp: Fix possible send queue overflow
Date: Tue, 3 Nov 2015 20:56:29 +0200
Message-ID: <5639035D.6050805@dev.mellanox.co.il>
References: <1444901206-27462-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1444901206-27462-1-git-send-email-sagig@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Stable <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


On 15/10/2015 12:26, Sagi Grimberg wrote:
> When using work request based memory registration (fast_reg)
> we must reserve SQ entries for registration and invalidation
> in addition to send operations. Each IO consumes 3 SQ entries
> (registration, send, invalidation) so we need to allocate 3x
> larger send-queue instead of 2x.
>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> CC: Stable <stable@vger.kernel.org>
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
>

Hi Doug,

Kind reminder for picking this up for 4.4

Cheers,
Sagi
