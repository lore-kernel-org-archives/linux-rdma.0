From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Infinihost HCA ->MTT -are they per HCA?
Date: Wed, 9 Feb 2011 08:17:19 +0200
Message-ID: <20110209061719.GA30553@mtldesk30>
References: <4D4355ED.50301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D4355ED.50301-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 28, 2011 at 03:49:01PM -0800, Pradeep Satyanarayana wrote:
> We have the following HCAs in one of the machines:
> 
> InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx HCA] (rev 20)
> 
> There are two adapters in the machine and from various experiments
> we find that we are limited to being able to register
> (ibv_reg_mr()) 28 GB. My calculations show one should be able to
> register up to 56 GB. I would like to understand the difference.
> 
> In /sys/module/ib_mthca/parameters I see the following values:
> 
> fmr_reserved_mtts = 262144
> log_mtts_per_seg = 3
> num_mpt = 131072
> num_mtt = 2097152
> 
> Therefore max memory that one can register should be (2097152
> -262144) * 4K * 2^(log_mtts_per_seg)
> i.e. 1.75 MB * 4K * 8 = 56 GB.
> 
> Since ibv_reg_mr() ties one to a pd and thus a particular device, is
> the 56 GB split between the 2 HCAs in the machine?
> How does one explain the difference?
> 

Your calaculations are correct; each device should be able,
theoretically, to register 56 GB of memory. I assume you have enough
memory in your machine for the memory to be registered and also ICM
memory that is required to support all the registered memory. Also it
depends on how many registered memory regions you use and and their
sizes. For example, since the MTT segments allocator is a buddy
allocator, it allocates 2 ^ n mtt segments each time. So if your
memory region requires only [2 ^ (n -1)] + 1 entries, it will still
consume 2 ^ n entries from the allocator.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
