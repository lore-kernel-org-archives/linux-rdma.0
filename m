From: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 14:54:55 -0700 (PDT)
Message-ID: <64ef31c8-cb1a-4579-ba12-11fbf6d1d5c0@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tbogendoerfer-l3A5Bk7waGM@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

----- Original Message -----
From: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
To: parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tbogendoerfer-l3A5Bk7waGM@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Sent: Friday, October 27, 2017 2:30:33 PM GMT -08:00 US/Canada Pacific
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged in SFP module

On 10/27/2017 4:33 PM, Parav Pandit wrote:
> 
> 
>> -----Original Message-----
>> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Friday, October 27, 2017 3:19 PM
>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Thomas Bogendoerfer
>> <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>; Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon
>> Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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

When running ibstat (if transceiver is not connected in adapter):

ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid argument

Thanks,
Ghazale
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
