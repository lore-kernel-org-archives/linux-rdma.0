From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Mon, 10 Sep 2012 16:27:19 +0300
Message-ID: <504DEAB7.2070101@mellanox.com>
References: <20549.47088.805176.786765@iinet.net.au> <201209100957.08509.jackm@dev.mellanox.co.il> <504DC25B.1030501@mellanox.com> <201209101617.46581.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201209101617.46581.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/09/2012 16:17, Jack Morgenstein wrote:
> I don't know. I do notice (in file include/linux/rcupdate.h) that 
> rcu_read_lock/unlock is meant to be used in the interrupt context. 
> Would it be sufficient (besides rcu_read_lock/unlock calls) to add a 
> call rcu_synchronize() in mlx4_cq_free (after calling synchronize_irq)? 

I  took a look on the practice/wrapping used over the mm subsystem for 
radix_tree_lookup calls, whose maintainer,
Andrew Morton is signed on the patch Roland pointed to, its just 
rcu_read_lock/unlock, seems this is what to do as well.


> mm/readahead.c-179- rcu_read_lock();
> mm/readahead.c:180:             page = 
> radix_tree_lookup(&mapping->page_tree, page_offset);
> mm/readahead.c-181-             rcu_read_unlock();
> --
> mm/shmem.c-278- rcu_read_lock();
> mm/shmem.c:279: item = radix_tree_lookup(&mapping->page_tree, index);
> mm/shmem.c-280- rcu_read_unlock();
> --
> mm/vmalloc.c-986-       rcu_read_lock();
> mm/vmalloc.c:987:       vb = radix_tree_lookup(&vmap_block_tree, vb_idx);
> mm/vmalloc.c-988-       rcu_read_unlock();


> Could we also then dispense with the spinlocks in mlx4_cq_event() as 
> well? 

I don't see why mlx4_cq_event should be treated differently.

> Acquiring the SINGLE cq_table->lock spinlock for EVERY completion 
> event of EVERY cq seems very nasty to me (probably why Roland did not 
> do this), and it would clearly be desirable not to have to do this

so we have a way to avoid it, with rcu_read_lock, Max/Roland, agree?

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
