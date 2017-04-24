From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/ipoib: Fix deadlock between ipoib_stop
 and mcast join flow
Date: Mon, 24 Apr 2017 12:03:37 -0400
Message-ID: <1493049817.3041.31.camel@redhat.com>
References: <20170319091855.8419-1-leon@kernel.org>
         <20170319091855.8419-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170319091855.8419-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-03-19 at 11:18 +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Before calling ipoib_stop, rtnl_lock should be taken, then
> the flow clears the IPOIB_FLAG_ADMIN_UP and IPOIB_FLAG_OPER_UP
> flags, and waits for mcast completion if IPOIB_MCAST_FLAG_BUSY
> is set.
> 
> On the other hand, the flow of multicast join task initializes
> a mcast completion, sets the IPOIB_MCAST_FLAG_BUSY and calls
> ipoib_mcast_join. If IPOIB_FLAG_OPER_UP flag is not set, this
> call returns EINVAL without setting the mcast completion and
> leads to a deadlock.
> 
>     ipoib_stop                          |
>         |                               |
>     clear_bit(IPOIB_FLAG_ADMIN_UP)      |
>         |                               |
>     Context Switch                      |
>         |                       ipoib_mcast_join_task
>         |                               |
>         |                       spin_lock_irq(lock)
>         |                               |
>         |                       init_completion(mcast)
>         |                               |
>         |                       set_bit(IPOIB_MCAST_FLAG_BUSY)
>         |                               |
>         |                       Context Switch
>         |                               |
>     clear_bit(IPOIB_FLAG_OPER_UP)       |
>         |                               |
>     spin_lock_irqsave(lock)             |
>         |                               |
>     Context Switch                      |
>         |                       ipoib_mcast_join
>         |                       return (-EINVAL)
>         |                               |
>         |                       spin_unlock_irq(lock)
>         |                               |
>         |                       Context Switch
>         |                               |
>     ipoib_mcast_dev_flush               |
>     wait_for_completion(mcast)          |
> 
> ipoib_stop will wait for mcast completion for ever, and will
> not release the rtnl_lock. As a result panic occurs with the
> following trace:
> 
>     [13441.639268] Call Trace:
>     [13441.640150]  [<ffffffff8168b579>] schedule+0x29/0x70
>     [13441.641038]  [<ffffffff81688fc9>] schedule_timeout+0x239/0x2d0
>     [13441.641914]  [<ffffffff810bc017>] ? complete+0x47/0x50
>     [13441.642765]  [<ffffffff810a690d>] ?
> flush_workqueue_prep_pwqs+0x16d/0x200
>     [13441.643580]  [<ffffffff8168b956>]
> wait_for_completion+0x116/0x170
>     [13441.644434]  [<ffffffff810c4ec0>] ? wake_up_state+0x20/0x20
>     [13441.645293]  [<ffffffffa05af170>]
> ipoib_mcast_dev_flush+0x150/0x190 [ib_ipoib]
>     [13441.646159]  [<ffffffffa05ac967>] ipoib_ib_dev_down+0x37/0x60
> [ib_ipoib]
>     [13441.647013]  [<ffffffffa05a4805>] ipoib_stop+0x75/0x150
> [ib_ipoib]
> 
> Fixes: 08bc327629cb ("IB/ipoib: fix for rare multicast join race
> condition")
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
