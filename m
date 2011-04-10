From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] RDMA/cxgb4: missing parentheses
Date: Sun, 10 Apr 2011 15:12:58 -0500
Message-ID: <4DA20F4A.3040205@opengridcomputing.com>
References: <4DA20964.6050806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DA20964.6050806@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: roel <roel.kluin@gmail.com>
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise@opengridcomputing.com>

On 4/10/2011 2:47 PM, roel wrote:
> Parens are missing: '|' has a higher presedence than '?'.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/qp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 70a5a3c..80cab20 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -214,7 +214,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   		V_FW_RI_RES_WR_HOSTFCMODE(0) |	/* no host cidx updates */
>   		V_FW_RI_RES_WR_CPRIO(0) |	/* don't keep in chip cache */
>   		V_FW_RI_RES_WR_PCIECHN(0) |	/* set by uP at ri_init time */
> -		t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0 |
> +		(t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0) |
>   		V_FW_RI_RES_WR_IQID(scq->cqid));
>   	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
>   		V_FW_RI_RES_WR_DCAEN(0) |
