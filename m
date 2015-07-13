From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 04/10] IB/core: Add rwsem to allow reading
 device list or client list
Date: Mon, 13 Jul 2015 11:29:00 -0600
Message-ID: <20150713172900.GG23832@obsidianresearch.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
 <1435150766-6803-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435150766-6803-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 24, 2015 at 03:59:20PM +0300, Matan Barak wrote:
> From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Currently the RDMA subsystem's device list and client list are
> protected by a single mutex. This prevents adding user-facing APIs
> that iterate these lists, since using them may cause a deadlock.
> The patch attempts to solve this problem by adding a read-write
> semaphore to protect the lists. Readers now don't need the mutex,
> and are safe just by read-locking the semaphore.
> 
> The ib_register_device, ib_register_client, ib_unregister_device, and
> ib_unregister_client functions are modified to lock the semaphore for
> write during their respective list modification. Also, in order to
> make sure client callbacks are called only between add() and remove()
> calls, the code is changed to only add items to the lists after the
> add() calls and remove from the lists before the remove() calls.
> 
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Looks OK

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
