From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/4] IB/iwpm: Fix a potential skb leak
Date: Wed, 4 May 2016 10:36:27 -0500
Message-ID: <019801d1a61a$b8ec7600$2ac56200$@opengridcomputing.com>
References: <1462340165-16067-1-git-send-email-leon@kernel.org> <1462340165-16067-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462340165-16067-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Wednesday, May 04, 2016 12:36 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
> matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Leon Romanovsky
> Subject: [PATCH rdma-next 1/4] IB/iwpm: Fix a potential skb leak
> 
> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In case ibnl_put_msg fails in send_nlmsg_done,
> the function returns with -ENOMEM without freeing.
> 
> This patch fixes this behavior.
> 
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space
> service")
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/iwpm_util.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/core/iwpm_util.c
> b/drivers/infiniband/core/iwpm_util.c
> index 9b2bf2f..b65e06c 100644
> --- a/drivers/infiniband/core/iwpm_util.c
> +++ b/drivers/infiniband/core/iwpm_util.c
> @@ -634,6 +634,7 @@ static int send_nlmsg_done(struct sk_buff *skb, u8
> nl_client, int iwpm_pid)
>  	if (!(ibnl_put_msg(skb, &nlh, 0, 0, nl_client,
>  			   RDMA_NL_IWPM_MAPINFO, NLM_F_MULTI))) {
>  		pr_warn("%s Unable to put NLMSG_DONE\n", __func__);
> +		dev_kfree_skb(skb);
>  		return -ENOMEM;
>  	}
>  	nlh->nlmsg_type = NLMSG_DONE;
> --
> 2.1.4

Looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
