From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 20:17:18 +0200
Message-ID: <20180914181718.GD3811@lunn.ch>
References: <20180914002514.27571-1-qing.huang@oracle.com>
 <20180914044314.GC5257@mtr-leonro.mtl.com>
 <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 14, 2018 at 10:15:48AM -0700, Qing Huang wrote:
> The FW version is actually a very crucial piece of information and only
> printed once here
> when the driver is loaded. People tend to get confused when switching
> multiple FW files
> back and forth without running separate utility tools, especially at
> customer sites.
> IMHO, this information is very useful and only takes up very little log file
> space. :-)

Why not use ethtool -i ?

$ sudo ethtool -i eth0
driver: r8169
version: 2.3LK-NAPI
firmware-version: rtl8168g-2_0.0.1 02/06/13

    Andrew
