From: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Fri, 27 Oct 2017 16:04:47 -0700
Message-ID: <9be6d049-c3fc-6cf2-8d91-4449f4bcc896@oracle.com>
References: <64ef31c8-cb1a-4579-ba12-11fbf6d1d5c0@default>
 <0af834ca-52ff-47da-a225-744aab4e59d6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0af834ca-52ff-47da-a225-744aab4e59d6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tbogendoerfer-l3A5Bk7waGM@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 10/27/2017 03:52 PM, Hal Rosenstock wrote:
> On 10/27/2017 5:54 PM, Ghazale Hosseinabadi wrote:
>> When running ibstat (if transceiver is not connected in adapter):
>>
>> ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid argument
> Any output before that ?
no, It only prints this line.

-- Ghazale
>   I'm trying to understand how far it gets. It
> looks to me that empty rate file would be parsed as 0 and ibstat would
> show that rate. ibpanic would occur if file was not found but I could be
> missing something.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
