From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [for-next V2 06/10] linux/dim: Move implementation to .c files
Date: Tue, 2 Jul 2019 18:15:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg>
References: <20190625205701.17849-1-saeedm@mellanox.com> <20190625205701.17849-7-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190625205701.17849-7-saeedm@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Tal Gilboa <talgi@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

 	Hi Saeed, Tal,

On Tue, 25 Jun 2019, Saeed Mahameed wrote:
> From: Tal Gilboa <talgi@mellanox.com>
>
> Moved all logic from dim.h and net_dim.h to dim.c and net_dim.c.
> This is both more structurally appealing and would allow to only
> expose externally used functions.
>
> Signed-off-by: Tal Gilboa <talgi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

This is now commit 4f75da3666c0c572 ("linux/dim: Move implementation to
.c files") in net-next.

> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -8,6 +8,7 @@ config NET_VENDOR_BROADCOM
> 	default y
> 	depends on (SSB_POSSIBLE && HAS_DMA) || PCI || BCM63XX || \
> 		   SIBYTE_SB1xxx_SOC
> +	select DIMLIB

Merely enabling a NET_VENDOR_* symbol should not enable inclusion of
any additional code, cfr. the help text for the NET_VENDOR_BROADCOM
option.

Hence please move the select to the config symbol(s) for the driver(s)
that need it.

> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -562,6 +562,14 @@ config SIGNATURE
> 	  Digital signature verification. Currently only RSA is supported.
> 	  Implementation is done using GnuPG MPI library
>
> +config DIMLIB
> +	bool "DIM library"
> +	default y

Please drop this line, as optional library code should never be included
by default.

Thanks!

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
