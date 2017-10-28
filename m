From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without
 plugged in SFP module
Date: Sat, 28 Oct 2017 12:42:44 +0200
Message-ID: <20171028124244.34dcc77d90637f5fc4a77017@suse.de>
References: <64ef31c8-cb1a-4579-ba12-11fbf6d1d5c0@default>
        <0af834ca-52ff-47da-a225-744aab4e59d6@dev.mellanox.co.il>
        <9be6d049-c3fc-6cf2-8d91-4449f4bcc896@oracle.com>
        <4dcf0ca6-77ff-bfd3-9f79-c114617f536f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4dcf0ca6-77ff-bfd3-9f79-c114617f536f-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 27 Oct 2017 19:19:05 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 10/27/2017 7:04 PM, Ghazale Hosseinabadi wrote:
> > 
> > 
> > On 10/27/2017 03:52 PM, Hal Rosenstock wrote:
> >> On 10/27/2017 5:54 PM, Ghazale Hosseinabadi wrote:
> >>> When running ibstat (if transceiver is not connected in adapter):
> >>>
> >>> ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid
> >>> argument
> >> Any output before that ?
> > no, It only prints this line.

rate_show() generates an EINVAL, that's propably what ibstat/*libs confuses.

> and setting the width to 1x in the driver so the rate file is properly
> populated fixes this ? 

yes, because then rate_show() will not return EINVAL.

> I must be missing something as to what is going on in this scenario.
> 
> sysfs.c:rate_show is inconsistent as it paves over an invalid speed
> setting that to SDR but does not pave over invalid width returning
> -EINVAL but this comment is in another "direction".

I thought about going in the other direction by making the speed/width unknown case
somehow visible in rate_show(). When I checked all other drivers only mlx5 stand out
so I decided to only change mlx5. But I make a change to let rate_show() print out, 
that is currently has no rate for the port.

Thomas.

-- 
Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
