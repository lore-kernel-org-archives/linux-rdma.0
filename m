From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/mlx4: Add dependency INET
Date: Mon, 20 Jan 2014 00:32:46 +0200
Message-ID: <52DC528E.2040404@mellanox.com>
References: <1389885408-21897-1-git-send-email-matanb@mellanox.com> <1389885408-21897-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389885408-21897-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/01/2014 17:16, Matan Barak wrote:
> Since mlx4_ib supports IP based addressing, a dependency on
> INET should be added. This is mandatory since mlx4_ib
> registers itself to net device events.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Roland,
>
> The mlx4_ib driver registers itself to network events.
> This is mandatory for adding IP based GIDs.
> Thus, we need to introduce a new dependency on INET.

Roland, I see that you've picked this patch, thanks. Note the same patch 
need to be done for ocrdma, since
it also registered to the notifiers under the IP addressing patches.

Or.




>
> Thanks,
> Matan
>
>   drivers/infiniband/hw/mlx4/Kconfig |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
> index 24ab11a..fc01dea 100644
> --- a/drivers/infiniband/hw/mlx4/Kconfig
> +++ b/drivers/infiniband/hw/mlx4/Kconfig
> @@ -1,6 +1,6 @@
>   config MLX4_INFINIBAND
>   	tristate "Mellanox ConnectX HCA support"
> -	depends on NETDEVICES && ETHERNET && PCI
> +	depends on NETDEVICES && ETHERNET && PCI && INET
>   	select NET_VENDOR_MELLANOX
>   	select MLX4_CORE
>   	---help---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
