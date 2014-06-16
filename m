From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCHv2] Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 10:04:20 -0500
Message-ID: <539F0774.5030909@opengridcomputing.com>
References: <1402931009-3403-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402931009-3403-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/16/2014 10:03 AM, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
> +		if (!skb)
> +			kfree(skb);
>   		skb = alloc_skb(len, gfp);
>   	}
>   	t4_set_arp_err_handler(skb, NULL, NULL);

Should be 'if (skb)'

:)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
