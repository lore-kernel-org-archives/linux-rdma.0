From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 27 Feb 2017 22:33:16 +0200
Message-ID: <3eb5814f-14cb-2b94-adf8-335d4b2eb7e9@grimberg.me>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com>
 <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0@grimberg.me>
 <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
 <1554c1d1-6bf4-9ca2-12d4-a0125d8c5715@gmail.com>
 <DE927C68B458BE418D582EC97927A92854655137@ORSMSX112.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE927C68B458BE418D582EC97927A92854655137-8oqHQFITsIFcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hey Joseph,

> In our lab we are dealing with an issue which has some of the same symptoms.  Wanted to add to the thread in case it is useful here.  We have a target system with 16 Intel P3520 disks and a Mellanox CX4 50Gb NIC directly connected (no switch) to a single initiator system with a matching Mellanox CX4 50Gb NIC.  We are running Ubuntu 16.10 with 4.10-RC8 mainline kernel.  All drivers are kernel default drivers.  I've attached our nvmetcli json, and FIO workload, and dmesg from both systems.
>
> We are able to provoke this problem with a variety of workloads but a high bandwidth read operation seems to cause it the most reliably, harder to produce with smaller block sizes.  For some reason the problem seems produced when we stop and restart IO - I can run the FIO workload on the initiator system for 1-2 hours without any new events in dmesg, pushing about 5500MB/sec the whole time, then kill it and wait 10 seconds and restart it, and the errors and reconnect events happen reliably at that point.  Working to characterize further this week and also to see if we can produce on a smaller configuration.  Happy to provide any additional details that would be useful or try any fixes!
>
> On the initiator we see events like this:
>
> [51390.065641] mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> [51390.065644] 00000000 00000000 00000000 00000000
> [51390.065645] 00000000 00000000 00000000 00000000
> [51390.065646] 00000000 00000000 00000000 00000000
> [51390.065648] 00000000 08007806 250003ab 02b9dcd2
> [51390.065666] nvme nvme3: MEMREG for CQE 0xffff9fc845039410 failed with status memory management operation error (6)
> [51390.079156] nvme nvme3: reconnecting in 10 seconds
> [51400.432782] nvme nvme3: Successfully reconnected

Seems to me this is a CX4 FW issue. Mellanox can elaborate on these
vendor specific syndromes on this output.

> On the target we see events like this:
>
> [51370.394694] mlx5_0:dump_cqe:262:(pid 6623): dump error cqe
> [51370.394696] 00000000 00000000 00000000 00000000
> [51370.394697] 00000000 00000000 00000000 00000000
> [51370.394699] 00000000 00000000 00000000 00000000
> [51370.394701] 00000000 00008813 080003ea 00c3b1d2

If the host is failing on memory mapping while the target is initiating
rdma access it makes sense that it will see errors.

>
> Sometimes, but less frequently, we also will see events on the target like this as part of the problem:
>
> [21322.678571] nvmet: ctrl 1 fatal error occurred!

Again, also makes sense because for nvmet this is a fatal error and we
need to teardown the controller.

You can try out this patch to see if it makes the memreg issues to go
away:
--
diff --git a/drivers/infiniband/hw/mlx5/qp.c 
b/drivers/infiniband/hw/mlx5/qp.c
index ad8a2638e339..0f9a12570262 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3893,7 +3893,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct 
ib_send_wr *wr,
                                 goto out;

                         case IB_WR_LOCAL_INV:
-                               next_fence = 
MLX5_FENCE_MODE_INITIATOR_SMALL;
+                               next_fence = 
MLX5_FENCE_MODE_STRONG_ORDERING;
                                 qp->sq.wr_data[idx] = IB_WR_LOCAL_INV;
                                 ctrl->imm = 
cpu_to_be32(wr->ex.invalidate_rkey);
                                 set_linv_wr(qp, &seg, &size);
@@ -3901,7 +3901,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct 
ib_send_wr *wr,
                                 break;

                         case IB_WR_REG_MR:
-                               next_fence = 
MLX5_FENCE_MODE_INITIATOR_SMALL;
+                               next_fence = 
MLX5_FENCE_MODE_STRONG_ORDERING;
                                 qp->sq.wr_data[idx] = IB_WR_REG_MR;
                                 ctrl->imm = cpu_to_be32(reg_wr(wr)->key);
                                 err = set_reg_wr(qp, reg_wr(wr), &seg, 
&size);
--

Note that this will have a big performance (negative) impact on small
read workloads.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
