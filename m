From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 17:30:26 -0400
Message-ID: <273019e4-2db5-00dd-4557-8cc5a88c77f4@dev.mellanox.co.il>
References: <20171027123011.10454-1-tbogendoerfer@suse.de>
 <VI1PR0502MB3008AE9EEBF086840CC06077D15A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20aece10-1188-6672-bd44-e78c50396445@dev.mellanox.co.il>
 <VI1PR0502MB3008DA34E5F8322BAEAD7C93D15A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0502MB3008DA34E5F8322BAEAD7C93D15A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>, Thomas Bogendoerfer <tbogendoerfer@suse.de>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2017 4:33 PM, Parav Pandit wrote:
> 
> 
>> -----Original Message-----
>> From: Hal Rosenstock [mailto:hal@dev.mellanox.co.il]
>> Sent: Friday, October 27, 2017 3:19 PM
>> To: Parav Pandit <parav@mellanox.com>; Thomas Bogendoerfer
>> <tbogendoerfer@suse.de>; Matan Barak <matanb@mellanox.com>; Leon
>> Romanovsky <leonro@mellanox.com>; Doug Ledford <dledford@redhat.com>;
>> linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
>> Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi@oracle.com>
>> Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
>> in SFP module
>>
>> On 10/27/2017 2:32 PM, Parav Pandit wrote:
>>> However I believe that ibstat tool should be enhanced to report unknown port
>> speed instead of expecting drivers to supply some random number like this.
>>
>> ibstat gets the rate from libibumad via /sys/class/infiniband/<IB
>> device>/ports/<port number>/rate file which is supposed to be populated by the
>> driver. Is there no rate file in this error case ?
>>
> <...>/<port_num>/rate file exist.
> 
> rate_show() has invalid active_width as expected due to nonexistence of SFP.
> So sysfs call return invalid value.
> We don't have invalid_active_width defined right now.
> So ibstat and other applications should not crash on such valid errors.

Agreed. I haven't seen ibstat crash reported though. Can someone provide
the crash details ?
