From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: NVMe over RDMA latency
Date: Thu, 07 Jul 2016 12:55:42 -0700
Message-ID: <1467921342.24395.12.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi list,

I'm trying to understand the NVMe over RDMA latency.

Test hardware:
A real NVMe PCI drive on target
Host and target back-to-back connected by Mellanox ConnectX-3

[global]
ioengine=libaio
direct=1
runtime=10
time_based
norandommap
group_reporting

[job1]
filename=/dev/nvme0n1
rw=randread
bs=4k


fio latency data on host side(test nvmeof device)
    slat (usec): min=2, max=213, avg= 6.34, stdev= 3.47
    clat (usec): min=1, max=2470, avg=39.56, stdev=13.04
     lat (usec): min=30, max=2476, avg=46.14, stdev=15.50

fio latency data on target side(test NVMe pci device locally)
    slat (usec): min=1, max=36, avg= 1.92, stdev= 0.42
    clat (usec): min=1, max=68, avg=20.35, stdev= 1.11
     lat (usec): min=19, max=101, avg=22.35, stdev= 1.21

So I picked up this sample from blktrace which seems matches the fio avg latency data.

Host(/dev/nvme0n1)
259,0    0       86     0.015768739  3241  Q   R 1272199648 + 8 [fio]
259,0    0       87     0.015769674  3241  G   R 1272199648 + 8 [fio]
259,0    0       88     0.015771628  3241  U   N [fio] 1
259,0    0       89     0.015771901  3241  I  RS 1272199648 + 8 (    2227) [fio]
259,0    0       90     0.015772863  3241  D  RS 1272199648 + 8 (     962) [fio]
259,0    1       85     0.015819257     0  C  RS 1272199648 + 8 (   46394) [0]

Target(/dev/nvme0n1)
259,0    0      141     0.015675637  2197  Q   R 1272199648 + 8 [kworker/u17:0]
259,0    0      142     0.015676033  2197  G   R 1272199648 + 8 [kworker/u17:0]
259,0    0      143     0.015676915  2197  D  RS 1272199648 + 8 (15676915) [kworker/u17:0]
259,0    0      144     0.015694992     0  C  RS 1272199648 + 8 (   18077) [0]

So host completed IO in about 50usec and target completed IO in about 20usec.
Does that mean the 30usec delta comes from RDMA write(host read means target RDMA write)?

Thanks,
Ming

Below is just for myself to understand what the blktrace flag means
===================================================================
Q - queued:
generic_make_request_checks: trace_block_bio_queue(q, bio)

G - get request:
blk_mq_map_request: trace_block_getrq(q, bio, op)

U:
blk_mq_insert_requests: trace_block_unplug(q, depth, !from_schedule)

I - inserted:
__blk_mq_insert_req_list: trace_block_rq_insert(hctx->queue, rq)

D - issued:
blk_mq_start_request: trace_block_rq_issue(q, rq)

C - complete:
blk_update_request: trace_block_rq_complete(req->q, req, nr_bytes)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
