From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 11/11] IB/rxe: Handle NETDEV_CHANGE events
Date: Tue, 29 Aug 2017 10:53:19 +0300
Message-ID: <20170829075318.GA3500@yuvallap>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-12-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503951119-25573-12-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 28, 2017 at 04:11:59PM -0400, Andrew Boyer wrote:
> Without this fix, ports configured on top of ixgbe miss link up
> notifications. ibv_query_port() will continue to return IBV_PORT_DOWN even
> though the port is up and working.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/infiniband/sw/rxe/rxe_net.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 3ba76e7..59dee10 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -651,8 +651,13 @@ static int rxe_notify(struct notifier_block *not_blk,
>  		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
>  		rxe_set_mtu(rxe, ndev->mtu);
>  		break;
> -	case NETDEV_REBOOT:
>  	case NETDEV_CHANGE:
> +		if (netif_running(ndev) && netif_carrier_ok(ndev))
> +			rxe_port_up(rxe);
> +		else
> +			rxe_port_down(rxe);
> +		break;
> +	case NETDEV_REBOOT:
>  	case NETDEV_GOING_DOWN:
>  	case NETDEV_CHANGEADDR:
>  	case NETDEV_CHANGENAME:
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
