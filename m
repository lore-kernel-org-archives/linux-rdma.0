From: Levente Kurusa <levex@linux.com>
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 17:12:47 +0200
Message-ID: <539F096F.8020502@linux.com>
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
Reply-To: Levente Kurusa <levex@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 06/16/2014 05:08 PM, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>    */
>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>   {
>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                  skb_trim(skb, 0);
>                  skb_get(skb);
>                  skb_reset_transport_header(skb);
>   	} else {
> +		if (skb)
> +			kfree (skb);
>   		skb = alloc_skb(len, gfp);
>   	}
>   	t4_set_arp_err_handler(skb, NULL, NULL);
>

Isn't kfree(NULL) legal?

(i.e. the if statement is useless)

Thanks,
     Levente Kurusa
