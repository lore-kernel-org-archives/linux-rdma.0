From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 01/13] IB/core: lock client data with lists_rwsem
Date: Mon, 27 Jul 2015 11:44:21 -0600
Message-ID: <20150727174421.GE18348@obsidianresearch.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-2-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437924832-18327-2-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 26, 2015 at 06:33:40PM +0300, Haggai Eran wrote:
> An ib_client callback that is called with the lists_rwsem locked only for
> read is protected from changes to the IB client lists, but not from
> ib_unregister_device() freeing its client data. This is because
> ib_unregister_device() will remove the device from the device list with
> lists_rwsem locked for write, but perform the rest of the cleanup,
> including the call to remove() without that lock.
> 
> Mark client data that is undergoing de-registration with a new going_down
> flag in the client data context. Lock the client data list with lists_rwsem
> for write in addition to using the spinlock, so that functions calling the
> callback would be able to lock only lists_rwsem for read and let callbacks
> sleep.
> 
> Since ib_unregister_client() now marks the client data context, no need for
> remove() to search the context again, so pass the client data directly to
> remove() callbacks.

This looks fine to me..

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
