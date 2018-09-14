From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 14:14:10 -0700 (PDT)
Message-ID: <20180914.141410.1124278905048123222.davem@davemloft.net>
References: <20180914044314.GC5257@mtr-leonro.mtl.com>
        <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
        <20180914181718.GD3811@lunn.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914181718.GD3811@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: andrew@lunn.ch
Cc: qing.huang@oracle.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 14 Sep 2018 20:17:18 +0200

> On Fri, Sep 14, 2018 at 10:15:48AM -0700, Qing Huang wrote:
>> The FW version is actually a very crucial piece of information and only
>> printed once here
>> when the driver is loaded. People tend to get confused when switching
>> multiple FW files
>> back and forth without running separate utility tools, especially at
>> customer sites.
>> IMHO, this information is very useful and only takes up very little log file
>> space. :-)
> 
> Why not use ethtool -i ?
> 
> $ sudo ethtool -i eth0
> driver: r8169
> version: 2.3LK-NAPI
> firmware-version: rtl8168g-2_0.0.1 02/06/13

+1
