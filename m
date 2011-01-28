From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Infinihost HCA ->MTT -are they per HCA?
Date: Fri, 28 Jan 2011 15:49:01 -0800
Message-ID: <4D4355ED.50301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have the following HCAs in one of the machines:

InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx HCA] (rev 20)

There are two adapters in the machine and from various experiments we 
find that we are limited to being able to register
(ibv_reg_mr()) 28 GB. My calculations show one should be able to 
register up to 56 GB. I would like to understand the difference.

In /sys/module/ib_mthca/parameters I see the following values:

fmr_reserved_mtts = 262144
log_mtts_per_seg = 3
num_mpt = 131072
num_mtt = 2097152

Therefore max memory that one can register should be (2097152 -262144) * 
4K * 2^(log_mtts_per_seg)
i.e. 1.75 MB * 4K * 8 = 56 GB.

Since ibv_reg_mr() ties one to a pd and thus a particular device, is the 
56 GB split between the 2 HCAs in the machine?
How does one explain the difference?

Thanks
Pradeep



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
