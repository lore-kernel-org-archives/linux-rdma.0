From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
Date: Mon, 16 Jun 2014 13:18:16 -0500
Message-ID: <539F34E8.3000501@opengridcomputing.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402940957-6381-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 6/16/2014 12:49 PM, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 5e153f6..867e664 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -455,8 +455,11 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
>   	unsigned int flowclen = 80;
>   	struct fw_flowc_wr *flowc;
>   	int i;
> -

Please add back the above blank line.

>   	skb = get_skb(skb, flowclen, GFP_KERNEL);
> +	if (!skb) {
> +		kfree_skb(skb);

Let's do a pr_warn() here;

         pr_warn(MOD "%s failed to allocate skb.\n", __func__);


> +		return;
> +	}
>   	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
>   
>   	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
