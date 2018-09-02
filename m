From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: core: mad: Fix a sleep-in-atomic-context bug
 in ib_mad_recv_done()
Date: Sun, 2 Sep 2018 14:32:29 -0600
Message-ID: <20180902203229.GA13946@ziepe.ca>
References: <20180901120659.32509-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180901120659.32509-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: dledford@redhat.com, leon@kernel.org, ira.weiny@intel.com, pravin.shedge4linux@gmail.com, hal@mellanox.com, parav@mellanox.com, haakon.bugge@oracle.com, bart.vanassche@sandisk.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 01, 2018 at 08:06:59PM +0800, Jia-Ju Bai wrote:
> The driver may sleep with holding a spinlock.
> 
> The function call paths (from bottom to top) in Linux-4.16 are:
> 
> [FUNC] alloc_mad_private(GFP_KERNEL)
> drivers/infiniband/core/mad.c, 2264: 
> 	alloc_mad_private in ib_mad_recv_done
> drivers/infiniband/core/cq.c, 45: 
> 	[FUNC_PTR]ib_mad_recv_done in __ib_process_cq
> drivers/infiniband/core/cq.c, 77: 
> 	__ib_process_cq in ib_process_cq_direct
> drivers/infiniband/ulp/srp/ib_srp.c, 2010: 
> 	ib_process_cq_direct in __srp_get_tx_iu
> drivers/infiniband/ulp/srp/ib_srp.c, 2353: 
> 	__srp_get_tx_iu in srp_queuecommand
> drivers/infiniband/ulp/srp/ib_srp.c, 2352: 
> 	_raw_spin_lock_irqsave in srp_queuecommand
> 
> [FUNC] alloc_mad_private(GFP_KERNEL)
> drivers/infiniband/core/mad.c, 2264: 
> 	alloc_mad_private in ib_mad_recv_done
> drivers/infiniband/core/cq.c, 45: 
> 	[FUNC_PTR]ib_mad_recv_done in __ib_process_cq
> drivers/infiniband/core/cq.c, 77: 
> 	__ib_process_cq in ib_process_cq_direct

This trace doesn't seem right, the CQ used by SRP will never have
ib_mad_recv_done as a function pointer.

Jason
