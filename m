From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rmmod mlx4_core panic 3.16-rc1
Date: Sun, 22 Jun 2014 12:29:01 +0300
Message-ID: <53A6A1DD.3020907@mellanox.com>
References: <53A259F3.3040203@oracle.com> <CAJZOPZK__Qo2LcTpL3R0=WOzsLKY2FYT_7VkKXThGiPWF8wv_g@mail.gmail.com> <53A46C2B.8030301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A46C2B.8030301-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/06/2014 20:15, Shirley Ma wrote:
>
> On 06/19/2014 08:34 PM, Or Gerlitz wrote:
>> On Thu, Jun 19, 2014 at 6:33 AM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> 1. Whether IB VFs is supported in ConnectX-2 (mlx4 driver)?
>>>
>>> I tried to num_vfs={port1,port2,port1+2} when loading mlx4_core module, it failed with mlx4_core 0000:40:00.0: Invalid syntax of num_vfs/probe_vfs with IB port - single port VFs syntax is only supported when all ports are configured as ethernet
>>
>> What do you mean by "port1" and "port2" -- can you give the exact
>> command line you used?
>>
>> Single ported VFs are currently supported for Ethernet only
>> configuration, that is not for only IB nor for VPI, that is only if
>> you use port_type_arrary=2,2
>>
> I tried command line with num_vfs without port_type_array=2,2.
>
> num_vfs=2
> num_vfs={1,1,2}
>
> both failed.

Please provide further details on what fails when you use num_vfs=2, 
here it works just fine, e.g send us the output of

$ modprobe -v mlx4_core

and the related dmesg

As for the crash you reported, indeed, it seems we have a bug there on 
the error flow of module loading when single ported VF are requested in 
conjunction with IB ports. I have it fixed on my system with this patch 
which are will review etc


 From 6dec77e0dc68679e4127de19f6798151cc8b2fe6 Mon Sep 17 00:00:00 2001
From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 22 Jun 2014 13:46:04 +0300
Subject: [PATCH] net/mlx4_core: Return error when module is loaded with 
invalid VF configuration

Single ported VF are currently not supported on configurations where
one or both ports are IB. When we hit this case, the module load
function didn't return error, fix that.

Fixes: dd41cc3 ('net/mlx4: Adapt num_vfs/probed_vf params for single 
port VF')
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
  drivers/net/ethernet/mellanox/mlx4/main.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c 
b/drivers/net/ethernet/mellanox/mlx4/main.c
index 5f42f6d..4f4d48c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2439,6 +2439,7 @@ slave_start:
                             (num_vfs_argc > 1 || probe_vfs_argc > 1)) {
                                 mlx4_err(dev,
                                          "Invalid syntax of 
num_vfs/probe_vfs with IB port - single port VFs syntax is only 
supported when all ports are configured as ethernet\n");
+                               err = -EINVAL;
                                 goto err_close;
                         }
                         for (i = 0; i < sizeof(nvfs)/sizeof(nvfs[0]); 
i++) {
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
