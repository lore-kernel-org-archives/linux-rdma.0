From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 19:19:05 -0400
Message-ID: <4dcf0ca6-77ff-bfd3-9f79-c114617f536f@dev.mellanox.co.il>
References: <64ef31c8-cb1a-4579-ba12-11fbf6d1d5c0@default>
 <0af834ca-52ff-47da-a225-744aab4e59d6@dev.mellanox.co.il>
 <9be6d049-c3fc-6cf2-8d91-4449f4bcc896@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9be6d049-c3fc-6cf2-8d91-4449f4bcc896-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tbogendoerfer-l3A5Bk7waGM@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/27/2017 7:04 PM, Ghazale Hosseinabadi wrote:
> 
> 
> On 10/27/2017 03:52 PM, Hal Rosenstock wrote:
>> On 10/27/2017 5:54 PM, Ghazale Hosseinabadi wrote:
>>> When running ibstat (if transceiver is not connected in adapter):
>>>
>>> ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid
>>> argument
>> Any output before that ?
> no, It only prints this line.

and setting the width to 1x in the driver so the rate file is properly
populated fixes this ? I must be missing something as to what is going
on in this scenario.

sysfs.c:rate_show is inconsistent as it paves over an invalid speed
setting that to SDR but does not pave over invalid width returning
-EINVAL but this comment is in another "direction".

-- Hal

> 
> -- Ghazale
>>   I'm trying to understand how far it gets. It
>> looks to me that empty rate file would be parsed as 0 and ibstat would
>> show that rate. ibpanic would occur if file was not found but I could be
>> missing something.
>>
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
