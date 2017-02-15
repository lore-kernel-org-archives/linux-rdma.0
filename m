From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 17:38:06 +0200
Message-ID: <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170214185636.29250-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Tests have shown that the following error message is reported when
> using SG-GAPS registration with an mlx5 adapter:
>
> scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd4270eb0
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 0f007806 2500002a ad9fafd1
> scsi host1: ib_srp: reconnect succeeded
> mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 00000000 0f007806 25000032 00105dd0
> scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b92860138
>
> Hence avoid using SG-GAPS memory registrations. Additionally,
> always configure the blk_queue_virt_boundary() to avoid to trigger
> a mapping failure when using adapters that support SG-GAPS (e.g.
> mlx5).

Hi Guys,

Sorry for addressing this late, but has this failure been investigated?

Max, Israel, what does this error syndrome map to?

Looking at mlx5_ib_sg_to_klms, I think the mr->length is incorrectly
incremented. Does the following change fix the problem?
--
diff --git a/drivers/infiniband/hw/mlx5/mr.c 
b/drivers/infiniband/hw/mlx5/mr.c
index 8f608debe141..c21c9eee37f6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1832,7 +1832,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
                 klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
                 klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
                 klms[i].key = cpu_to_be32(lkey);
-               mr->ibmr.length += sg_dma_len(sg);
+               mr->ibmr.length += sg_dma_len(sg) - sg_offset;

                 sg_offset = 0;
         }
