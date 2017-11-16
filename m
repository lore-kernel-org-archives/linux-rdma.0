From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] nvmet-rdma: SRQ per completion vector
Date: Thu, 16 Nov 2017 20:08:53 +0200
Message-ID: <20171116180853.GN18825@mtr-leonro.local>
References: <1510852885-25519-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510852885-25519-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 07:21:22PM +0200, Max Gurtovoy wrote:
> Since there is an active discussion regarding the CQ pool architecture, I decided to push
> this feature (maybe it can be pushed before CQ pool).

Max,

Thanks for CCing me, can you please repost the series and CC linux-rdma too?

>
> This is a new feature for NVMEoF RDMA target, that is intended to save resource allocation
> (by sharing them) and utilize the locality of completions to get the best performance with
> Shared Receive Queues (SRQs). We'll create a SRQ per completion vector (and not per device)
> using a new API (SRQ pool, added to this patchset too) and associate each created QP/CQ with
> an appropriate SRQ. This will also reduce the lock contention on the single SRQ per device
> (today's solution).
>
> My testing environment included 4 initiators (CX5, CX5, CX4, CX3) that were connected to 4
> subsystems (1 ns per sub) throw 2 ports (each initiator connected to unique subsystem
> backed in a different bull_blk device) using a switch to the NVMEoF target (CX5).
> I used RoCE link layer.
>
> Configuration:
>  - Irqbalancer stopped on each server
>  - set_irq_affinity.sh on each interface
>  - 2 initiators run traffic throw port 1
>  - 2 initiators run traffic throw port 2
>  - On initiator set register_always=N
>  - Fio with 12 jobs, iodepth 128
>
> Memory consumption calculation for recv buffers (target):
>  - Multiple SRQ: SRQ_size * comp_num * ib_devs_num * inline_buffer_size
>  - Single SRQ: SRQ_size * 1 * ib_devs_num * inline_buffer_size
>  - MQ: RQ_size * CPU_num * ctrl_num * inline_buffer_size
>
> Cases:
>  1. Multiple SRQ with 1024 entries:
>     - Mem = 1024 * 24 * 2 * 4k = 192MiB (Constant number - not depend on initiators number)
>  2. Multiple SRQ with 256 entries:
>     - Mem = 256 * 24 * 2 * 4k = 48MiB (Constant number - not depend on initiators number)
>  3. MQ:
>     - Mem = 256 * 24 * 8 * 4k = 192MiB (Mem grows for every new created ctrl)
>  4. Single SRQ (current SRQ implementation):
>     - Mem = 4096 * 1 * 2 * 4k = 32MiB (Constant number - not depend on initiators number)
>
> results:
>
> BS    1.read (target CPU)   2.read (target CPU)    3.read (target CPU)   4.read (target CPU)
> ---  --------------------- --------------------- --------------------- ----------------------
> 1k     5.88M (80%)            5.45M (72%)            6.77M (91%)          2.2M (72%)
>
> 2k     3.56M (65%)            3.45M (59%)            3.72M (64%)          2.12M (59%)
>
> 4k     1.8M (33%)             1.87M (32%)            1.88M (32%)          1.59M (34%)
>
> BS    1.write (target CPU)   2.write (target CPU) 3.write (target CPU)   4.write (target CPU)
> ---  --------------------- --------------------- --------------------- ----------------------
> 1k     5.42M (63%)            5.14M (55%)            7.75M (82%)          2.14M (74%)
>
> 2k     4.15M (56%)            4.14M (51%)            4.16M (52%)          2.08M (73%)
>
> 4k     2.17M (28%)            2.17M (27%)            2.16M (28%)          1.62M (24%)
>
>
> We can see the perf improvement between Case 2 and Case 4 (same order of resource).
> We can see the benefit in resource consumption (mem and CPU) with a small perf loss
> between cases 2 and 3.
> There is still an open question between the perf differance for 1k between Case 1 and
> Case 3, but I guess we can investigate and improve it incrementaly.
>
> Thanks to Idan Burstein and Oren Duer for suggesting this nice feature.
>
> Changes from V1:
>  - Added SRQ pool per protection domain for IB/core
>  - Fixed few comments from Christoph and Sagi
>
> Max Gurtovoy (3):
>   IB/core: add a simple SRQ pool per PD
>   nvmet-rdma: use srq pointer in rdma_cmd
>   nvmet-rdma: use SRQ per completion vector
>
>  drivers/infiniband/core/Makefile   |   2 +-
>  drivers/infiniband/core/srq_pool.c | 106 +++++++++++++++++++++
>  drivers/infiniband/core/verbs.c    |   4 +
>  drivers/nvme/target/rdma.c         | 190 +++++++++++++++++++++++++++----------
>  include/rdma/ib_verbs.h            |   5 +
>  include/rdma/srq_pool.h            |  46 +++++++++
>  6 files changed, 301 insertions(+), 52 deletions(-)
>  create mode 100644 drivers/infiniband/core/srq_pool.c
>  create mode 100644 include/rdma/srq_pool.h
>
> --
> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
