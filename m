From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_ib_create_qp failed - OOM with call trace
Date: Thu, 19 Jul 2012 13:31:02 -0700
Message-ID: <CAL1RGDX6+NZ_ZJ+TLOMBaVdyM0wd6BjCEHwwAYCVODY4Cfkm4Q@mail.gmail.com>
References: <5006BF13.50405@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5006BF13.50405-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> [5416523.203047] ib_srpt: Received SRP_LOGIN_REQ with i_port_id
> 0x0:0x2c903004ecf8b, t_port_id 0x2c903004ecf82:0x2c903004ecf82 and
> it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c903004ecf83)
> [5416523.204736] kworker/0:4: page allocation failure: order:4, mode:0x40d0
> [5416523.204738] Pid: 17674, comm: kworker/0:4 Not tainted 3.2.15+ #5
> [5416523.204740] Call Trace:
> [5416523.204745] [<ffffffff810d3d6b>] warn_alloc_failed+0xeb/0x130
> [5416523.204747] [<ffffffff810d6720>] ? drain_pages+0xa0/0xa0
> [5416523.204749] [<ffffffff810d6731>] ? drain_local_pages+0x11/0x20
> [5416523.204751] [<ffffffff810d6ec2>] __alloc_pages_nodemask+0x5f2/0x820
> [5416523.204754] [<ffffffff8110c4b1>] alloc_pages_current+0xa1/0x110
> [5416523.204756] [<ffffffff810d3829>] __get_free_pages+0x9/0x40
> [5416523.204759] [<ffffffff81113a3a>] kmalloc_order_trace+0x3a/0xb0
> [5416523.204761] [<ffffffff8111502e>] __kmalloc+0xee/0x140
> [5416523.204764] [<ffffffff81445954>] ? mlx4_buf_write_mtt+0xb4/0xd0
> [5416523.204768] [<ffffffff8153cd62>] create_qp_common.clone.17+0x6c2/0x990

So the issue I guess is memory fragementation -- we're trying to
do an order 4 allocation, ie 16 contiguous pages, and no so free
space is available.

I guess this allocation is:

		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), GFP_KERNEL);

in create_qp_common().  I don't have the SCST code handy but
the in-tree SRP target that was ported from it creates very big
send queues so that explains why we consume so much data.

I have to think about the best way to fix this.  We could just
convert to vmalloc() here but I'm not thrilled about consuming
vmalloc() space (on modern 64-bit architectures it's a non-issue
but it's going to cause issues for people on smaller systems).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
