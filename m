From: Iago Abal <iago.abal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Potential double-lock BUG in drivers/infiniband/core/umem_odp.c
 (Linux 4.9-rc7)
Date: Tue, 6 Dec 2016 16:59:54 +0100
Message-ID: <CAGbDTvpM5tWrUfLCtZByJ3Jp036a8QbieP5Wpj88zAXpmtu+_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jesper Dangaard Brouer <brouer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

With the help of a static bug finder (EBA -
http://www.iagoabal.eu/eba) I have found a potential double-lock in
drivers/infiniband/core/umem_odp.c: there seems to be a recursive lock
on `umem->odp_data->umem_mutex' in function
`ib_umem_odp_map_dma_pages'.

This problem may have been introduced by commit c1d383b5785b
("IB/core: dma map/unmap locking optimizations").

If this is indeed a bug, I could try to help with a patch... although
it doesn't look trivial to fix at first sight.

The trace is as follows:

1. Function `ib_umem_odp_map_dma_pages' takes the lock for the first
time in line 589:

    // see https://github.com/torvalds/linux/blob/v4.9-rc7/drivers/infiniband/core/umem_odp.c#L589
    mutex_lock(&umem->odp_data->umem_mutex);

2. Call to function `ib_umem_odp_map_dma_single_page' in line 591;

3. Call to function `invalidate_page_trampoline' in line 486;

4. Call to function `ib_umem_notifier_start_account' in line 160;

5. Lock is taken for the second time in line 46:

    // see https://github.com/torvalds/linux/blob/v4.9-rc7/drivers/infiniband/core/umem_odp.c#L46
    mutex_lock(&item->odp_data->umem_mutex);

Hope it helps!

-- iago
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
