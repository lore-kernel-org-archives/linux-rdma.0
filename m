From: Shamir Rabinovith <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] librdmacm: lazy initialization for ib devices]
Date: Sun, 30 Mar 2014 13:27:32 +0300
Message-ID: <20140330102731.GA4433@shamir-pc>
References: <20140327082325.GA5006@shamir-pc>
 <5333E37B.5080202@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5333E37B.5080202-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 27, 2014 at 10:38:19AM +0200, Or Gerlitz wrote:
> sorry, but you didn't provide an answer to my question - why is
> ibv_open_device failing if called from N > M (what's
> N and what's M) processes/threads.
> 
> Or.

The limit is due to firmware UAR BAR size. The issue happen here:
ib_uverbs_get_context -> ibdev->alloc_ucontext -> mlx4_ib_alloc_ucontext
-> mlx4_uar_alloc -> mlx4_bitmap_alloc . mlx4_QUERY_DEV_CAP return value
of 4194304 when reading the UAR from the firmware which turn to UAR
table size of 1024 in mlx4_init_uar_table. This is the result of
dividing the UAR BAR size by page size. We can try to extend the size of
the UAR BAR for Oracle servers as we know the HW and we can verify it
will boot with this change but anyhow we will still hit the limit of
number of processes that can open the library. More then this - UAR is
set to value that will allow less stronger machines to boot properly so
if you do not know which machine will use the firmware you cannot change
this limit as all. So the overall is that I think we need this change
anyhow, with or without the UAR BAR size change.

BR, Shamir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
