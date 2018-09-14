From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 14:14:06 -0700 (PDT)
Message-ID: <20180914.141406.2211638662965115243.davem@davemloft.net>
References: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
        <20180914181718.GD3811@lunn.ch>
        <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qing.huang@oracle.com
Cc: andrew@lunn.ch, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Qing Huang <qing.huang@oracle.com>
Date: Fri, 14 Sep 2018 11:33:40 -0700

> 
> 
> On 9/14/2018 11:17 AM, Andrew Lunn wrote:
>> On Fri, Sep 14, 2018 at 10:15:48AM -0700, Qing Huang wrote:
>>> The FW version is actually a very crucial piece of information and
>>> only
>>> printed once here
>>> when the driver is loaded. People tend to get confused when switching
>>> multiple FW files
>>> back and forth without running separate utility tools, especially at
>>> customer sites.
>>> IMHO, this information is very useful and only takes up very little
>>> log file
>>> space. :-)
>> Why not use ethtool -i ?
>>
>> $ sudo ethtool -i eth0
>> driver: r8169
>> version: 2.3LK-NAPI
>> firmware-version: rtl8168g-2_0.0.1 02/06/13
>>
>>      Andrew
> Sure. You can also use ibstat or ibv_devinfo tool if they are
> installed. But it's not very
> convenient in some cases.
> 
> E.g.
> A customer upgrades FW on HCAs and encounters issues. During triage,
> it's much easier
> to study customer uploaded log files when remotely testing different
> FW files.

Not a valid argument.  You can print the ethtool output from initramfs
if necessary for triage.

I still stand by the fact that ethtool is the only fully reliable way
to obtain this information, the kernel log is not.
