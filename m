From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Wed, 29 Apr 2015 10:48:47 -0600
Message-ID: <20150429164847.GA12781@obsidianresearch.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com>
 <20150428174312.GB5497@obsidianresearch.com>
 <5540F8F4.5010906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5540F8F4.5010906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> >Although, there must be a call to the driver's modify_gid to free
> >context before freeing, and I don't see that obviously happening..
 
> Of course there is:
> roce_gid_cache_client_cleanup_one ->
> roce_gid_cache_client_cleanup_one_work -> *work* ->
> roce_gid_cache_client_cleanup_work_handler ->
> roce_gid_cache_cleanup_one -> free_roce_gid_cache -> write_gid ->
> modify_gid

Ah, this wasn't there in the earlier versions. Good.
 
> >However, all the other async work launched doesn't look safe at all.

> I think it's safe - roce_gid_cache_client_cleanup_one deactivates
> the cache (no new events are handled on the cache). Ongoing events
> are flushed in roce_gid_cache_client_cleanup_one_work

Do you mean roce_gid_cache_client_cleanup_work_handler? 

> It's not safe to free the client's context in ib_unregister_device
> while the client isn't done. The obvious solution is to wait in
> client->remove (like you suggested) until the client has finished
> cleaning up things.

This isn't just the obvious solution, it is the *expected* solution.
In the kernel the add/remove style idiom always works like this.

> This doesn't fit our case - since client->remove is called under
> device_lock, but it's possible (for example) that
> roce_rescan_device_work_handler is currently running and waits to
> grab this exact mutex - DEAD LOCK.

Uh, client->remove is most obviously called with
drivers/infiniband/core/device.c:device_mutex held, is that what you
mean? But that can't be right because only four functions hold that
lock and none of them are obviously called from this patch?

If these patches have a locking problem then breaking the add/remove
idiom is not the way to solve it.

Look, four people have asked about this patch, and I still have yet to
see an accurate and convincing answer from you what is actually going
on here. Please actually spend some time to properly research and
describe why the remove callback can't be synchronous.

> >It is just fundamentally wrong to return from ib_client.remove while
> >async work is still outstanding, the client is expected to deal with
> >this internally and synchronously.
> >
> >You don't need IB core help to do this.
> 
> netdev is taking a similar approach - please take a look at
> netdev_wait_allrefs

No, it really isn't, from the attached drivers perspective after
unregister_netdevice returns the driver is not allowed to operate the
net device anymore. netdev_wait_allrefs is part of making
unregister_netdevice synchronous.

The same is true of our IB client attaches, after a client returns
from remove it is not allowed to operate the IB device anymore.

That is a standard idiom, and we'd need a huge compelling reason to go
away from that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
