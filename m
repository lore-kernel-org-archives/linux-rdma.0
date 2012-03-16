From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: ipoib and nfs in circular dependency deadlock
Date: Fri, 16 Mar 2012 12:44:07 -0500
Message-ID: <4F637BE7.7000700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jjolly-IBi9RG/b67k@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have dump which has all communications using ipoib blocking. The dump 
has the following trace for ipoib:

crash> bt ffff880601bbc600
PID: 5861   TASK: ffff880601bbc600  CPU: 5   COMMAND: "ipoib"
  #0 [ffff880614b6d410] schedule at ffffffff813988d4
  #1 [ffff880614b6d4c8] rpc_wait_bit_killable at ffffffffa03de655 [sunrpc]
  #2 [ffff880614b6d4d8] __wait_on_bit at ffffffff813991f0
  #3 [ffff880614b6d518] out_of_line_wait_on_bit at ffffffff81399299
  #4 [ffff880614b6d588] __rpc_execute at ffffffffa03def25 [sunrpc]
  #5 [ffff880614b6d5b8] rpc_run_task at ffffffffa03d7ad8 [sunrpc]
  #6 [ffff880614b6d5d8] nfs_commit_rpcsetup at ffffffffa048b088 [nfs]
  #7 [ffff880614b6d658] nfs_commit_inode at ffffffffa048cbce [nfs]
  #8 [ffff880614b6d698] nfs_release_page at ffffffffa047b98e [nfs]
  #9 [ffff880614b6d6b8] shrink_page_list at ffffffff810c2c9e
#10 [ffff880614b6d7c8] shrink_inactive_list at ffffffff810c30ba
#11 [ffff880614b6d958] shrink_zone at ffffffff810c3d64
#12 [ffff880614b6d9f8] shrink_zones at ffffffff810c3e63
#13 [ffff880614b6da38] do_try_to_free_pages at ffffffff810c50dd
#14 [ffff880614b6da98] try_to_free_pages at ffffffff810c5492
#15 [ffff880614b6daf8] __alloc_pages_slowpath at ffffffff810bba58
#16 [ffff880614b6dbb8] __alloc_pages_nodemask at ffffffff810bbe7a
#17 [ffff880614b6dc18] __vmalloc_area_node at ffffffff810de512
#18 [ffff880614b6dc68] ipoib_cm_tx_start at ffffffffa03647f9 [ib_ipoib]
#19 [ffff880614b6de38] run_workqueue at ffffffff810604f8
#20 [ffff880614b6de78] worker_thread at ffffffff81060616
#21 [ffff880614b6dee8] kthread at ffffffff810646b6
#22 [ffff880614b6df48] kernel_thread at ffffffff81003fba

This is a low memory situation where ipoib is trying to shrink cache and 
nfs is waiting on a bit to clear it's pages creating the circular 
dependency.

So my question is, should ipoib_cm_tx_init() call a simple kmalloc(.. , 
GFP_NOFS) instead of vzalloc()? The allocation size does not seem large 
enough to use vmalloc().

This problem was observed on SLES11SP1 (2.6.32.36 based), but I feel the 
problem exists in the upstream kernel as well.

-- 
Goldwyn

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
