From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 15:36:46 -0700
Message-ID: <1d4fe3c6-13aa-12a4-8da4-a83374b89fbf@oracle.com>
References: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
 <20180914181718.GD3811@lunn.ch>
 <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
 <20180914.141406.2211638662965115243.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914.141406.2211638662965115243.davem@davemloft.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: andrew@lunn.ch, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org



On 9/14/2018 2:14 PM, David Miller wrote:
> From: Qing Huang<qing.huang@oracle.com>
> Date: Fri, 14 Sep 2018 11:33:40 -0700
>
>> On 9/14/2018 11:17 AM, Andrew Lunn wrote:
>>> On Fri, Sep 14, 2018 at 10:15:48AM -0700, Qing Huang wrote:
>>>> The FW version is actually a very crucial piece of information and
>>>> only
>>>> printed once here
>>>> when the driver is loaded. People tend to get confused when switching
>>>> multiple FW files
>>>> back and forth without running separate utility tools, especially at
>>>> customer sites.
>>>> IMHO, this information is very useful and only takes up very little
>>>> log file
>>>> space. :-)
>>> Why not use ethtool -i ?
>>>
>>> $ sudo ethtool -i eth0
>>> driver: r8169
>>> version: 2.3LK-NAPI
>>> firmware-version: rtl8168g-2_0.0.1 02/06/13
>>>
>>>       Andrew
>> Sure. You can also use ibstat or ibv_devinfo tool if they are
>> installed. But it's not very
>> convenient in some cases.
>>
>> E.g.
>> A customer upgrades FW on HCAs and encounters issues. During triage,
>> it's much easier
>> to study customer uploaded log files when remotely testing different
>> FW files.
> Not a valid argument.  You can print the ethtool output from initramfs
> if necessary for triage.
>
> I still stand by the fact that ethtool is the only fully reliable way
> to obtain this information, the kernel log is not.

This is more for Infiniband mode which depends more on features and 
functionalities
provided in firmware and get much more frequent FW bug fixes than 
typical Ethernet
devices. This is not meant to replace other ways of getting the 
information, more like
an enhancement for checking log history.

This can provide valuable information when tracing through system log 
history to
discover what happened with a specific HCA drv ver and fw ver 
combination in the past.

Regards,
Qing
