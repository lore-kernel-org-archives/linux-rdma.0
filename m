From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 22:13:51 +0200
Message-ID: <20180914201351.GE3811@lunn.ch>
References: <20180914002514.27571-1-qing.huang@oracle.com>
 <20180914044314.GC5257@mtr-leonro.mtl.com>
 <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
 <20180914181718.GD3811@lunn.ch>
 <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

> >$ sudo ethtool -i eth0
> >driver: r8169
> >version: 2.3LK-NAPI
> >firmware-version: rtl8168g-2_0.0.1 02/06/13
> >
> >     Andrew

> Sure. You can also use ibstat or ibv_devinfo tool if they are installed. But
> it's not very convenient in some cases.

This is the standardised way to do this. It should work for any
Ethernet driver, so long as it fills in the needed information.
Anything else is non-standard, and so inconvenient by definition.

	Andrew
