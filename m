From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: MLX5 iSER issue on 4.6?
Date: Sun, 29 May 2016 15:33:47 +0300
Message-ID: <574AE1AB.9050501@grimberg.me>
References: <CAANLjFpPoynQeBiQjZ=2RA1YHaNp3jZKtavZ5URWcsJu+x85vA@mail.gmail.com>
 <574A930E.6030507@grimberg.me> <574ADB25.8080903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574ADB25.8080903-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> I've been running iSER on 4.1/4.4 with a Connect-IB and ConnectX-3 and
>>> everything works fine. When running the 4.6 kernel, the Connect-IB
>>> card aren't able to login to iSER even though the ConnectX-3 card does
>>> just fine. Hopefully, someone here has an idea of what the issue may
>>> be. For this test, we are making 12 sessions to the same host (three
>>> ports on each host, four sessions per port). Only four sessions become
>>> established which correlate to the ConnectX-3 card. It doesn't seem to
>>> matter which kernel the target is on, only the initiator.
>>>
>>> 02:00.0 Network controller: Mellanox Technologies MT27500 Family
>>> [ConnectX-3]
>>> 81:00.0 Infiniband controller: Mellanox Technologies MT27600
>>> [Connect-IB]
>>
>> Hi Robert, thanks for reporting.
>>
>> The difference in iSER in 4.6 is the arbitrary SG registration support
>> which works with a capable device (IB_DEVICE_SG_GAPS_REG). The CIB does
>> not support this feature but CX4 does, however, I wander if your CIB
>> falsely reports it does support this feature.
>
> Sagi your'e right.
> I repro this bug and saw that we alloc mr with:
> mr_type = IB_MR_TYPE_SG_GAPS (means that IB_DEVICE_SG_GAPS_REG cap is on).
> We also never call blk_queue_virt_boundary(sdev->request_queue,
> ~MASK_4K); because of this false cap.

Hey Max,

Thanks for looking into this!

>>
>> Can you share the output of ibv_devinfo -v on the CIB device? I'm
>> specifically interested in knowing what the max_mw is? it should
>> be 0, if its not I suspect this is a FW bug.
>
>   ibv_devinfo -v | grep max_mw
>          max_mw:                         0

OK, this is weird, lets dive into the the mlx5 driver code:

         if (MLX5_CAP_GEN(mdev, imaicl)) {
                 props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
                                            IB_DEVICE_MEM_WINDOW_TYPE_2B;
                 props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
                 /* We support 'Gappy' memory registration too */
                 props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
         }

We turn on SG_GAPS_REG in case the device supports memory windows (which
allows upgrading local permissions to remote on a window). This is
because in indirect registration, we effectively open a window on the
local_dma_lkey.

So the device seems to report it supports memory windows but it actually
doesn't because the maximum windows you can allocate is 0 (which looks
kind of silly to me). I'd say that the CIB FW needs to be fixed and not
report imaicl altogether for CIB (instead of reporting it with 0 memory
windows).

Anyway, either this will be fixed, or the below patch should work around
this (rather strange) behavior:

--
diff --git a/drivers/infiniband/hw/mlx5/main.c 
b/drivers/infiniband/hw/mlx5/main.c
index 6ad0489cb3c5..ae70fd1a6467 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -492,8 +492,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
                 props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
                                            IB_DEVICE_MEM_WINDOW_TYPE_2B;
                 props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
-               /* We support 'Gappy' memory registration too */
-               props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
+               if (props->max_mw)
+                       /* We support 'Gappy' memory registration too */
+                       props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
         }
         props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
         if (MLX5_CAP_GEN(mdev, sho)) {
--

Can you report if Mellanox plans to fix it in FW or should we work
around in the driver?

Thanks,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
