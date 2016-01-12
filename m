From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Tue, 12 Jan 2016 12:43:14 -0600
Message-ID: <00d301d14d69$18257d70$48707850$@opengridcomputing.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452158369-2938-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Matan,

Will you please submit this to 4.4-stable?

Thanks,

Steve.

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Matan Barak
> Sent: Thursday, January 07, 2016 3:19 AM
> To: Doug Ledford
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz; Majd Dibbiny; Hariprasad Shenai; Matan Barak
> Subject: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
> 
> cma_validate_port wrongly assumed that Ethernet devices are RoCE
> devices and thus their ndev should be matched in the GID table.
> This broke the iWarp support. Fixing that matching the ndev only if
> we work on a RoCE port.
> 
> Fixes: abae1b71dd37 ('IB/cma: cma_validate_port should verify the port
> 		     and netdevice')
> Reported-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Tested-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> 
> Hi Doug,
> 
> This patch fixes an iWarp issue that was introduced in the RoCE
> refactoring series.
> 
> Regards,
> Matan
> 
> Changes from V0:
>  - Fixed typo
> 
>  drivers/infiniband/core/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 2d762a2..17a15c5 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -453,7 +453,7 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
>  	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
>  		return ret;
> 
> -	if (dev_type == ARPHRD_ETHER)
> +	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
>  		ndev = dev_get_by_index(&init_net, bound_if_index);
> 
>  	ret = ib_find_cached_gid_by_port(device, gid, port, ndev, NULL);
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
