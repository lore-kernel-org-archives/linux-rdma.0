From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Fri, 1 May 2015 11:31:33 -0600
Message-ID: <20150501173133.GB17940@obsidianresearch.com>
References: <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com>
 <20150428174312.GB5497@obsidianresearch.com>
 <5540F8F4.5010906@dev.mellanox.co.il>
 <20150429164847.GA12781@obsidianresearch.com>
 <5541E5ED.7000606@mellanox.com>
 <20150430172606.GA32666@obsidianresearch.com>
 <CAAKD3BBGQwZ_Ainm6MSQjSkaXsJd9M5Vo4oarTLyFiVMQVS5_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBGQwZ_Ainm6MSQjSkaXsJd9M5Vo4oarTLyFiVMQVS5_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 01, 2015 at 09:28:40AM +0300, Matan Barak wrote:

> >> There might be some ways around it - for example, introduce another
> >> workqueue for roce_rescan_device and flush this workqueue only.
> >> Every way has its advantages and disadvantages.
> >
> > I don't see that either, like I keep saying, all work must complete,
> > more work queues don't really seem to help that.
> >
> 
> I think this is a possible solution, as all works but the "rescan" work
> aren't device specific. That means that after we move the rescan work
> to another workqueue and synchronize it in the client->remove function,
> we could be sure the device won't be used by this client anymore.
> 
> The rest of the works only iterate on the *existing* device list. Since the
> ib_unregister_device
> (a) lock (b) iterate over client->remove (c) remove from list (d) free
> (e) unlock
> all roce_gid_cache's works won't find it in the list and we'll be safe.

Well.. be carefull with the locking here, if device_mutex no longer
covers remove() then remove() and ib_enum_roce_ports_of_netdev() can
run concurrently and they will need locking against
free_roce_gid_cache(), which appears to implicitly rely on the
device_mutex (too subtle and fragile)

If there is a 'global' part and a 'device' specific part, it would
good to make this more obvious and clear: group the functions together,
annotate the difference with naming, a comment, or something. There
are *alot* of little functions in this module, it is hard to
understand the call graph without careful study.

> Regarding ib_unregister_client - if we guarantee that after each
> client->remove(dev)
> dev isn't used in this client, we actually guarantee that after removing all IB
> devices no IB device will be used (induction).

Yes, that is the idea..

> > So, ultimtely, this is really a self created problem, and infact, the
> > problem lies with the introduction of ib_enum_roce_ports_of_netdev -
> > adding a new use of the device_mutex that is not register/unregister
> > related exposes the design limitations of that mutex *that Roland
> > clearly explained in a giant comment!*

> I agree, while it's a general problem - it was first introduced by using
> device_mutex in an asynchronous context (that should be flushed in
> the remove function).

Well, no, generally speaking you can't use device_mutex in any client
facing API like ib_enum_roce_ports_of_netdev - it isn't just async
contexts, but it means the add() and remove() functions instantly
deadlock if they call a client facing API - that is not sane.

> >  - Convert device_mutex into a r/w sem
> 
> I'm not sure this will solve the problem, as besides the new enumerate
> devices function, all existing functions update the list - so we'll have
> read-while-write scenario and we'll be in the exact same condition.

You'd do something like hold the write sem and mutate the device list
to unlink the target device, then switch to a read sem to traverse the
client list. Two locks are clearer if contention is not an issue.

> Agree, but please consider also the addition of another
> workqueue as a possible solution. It *does* (seem) to answer
> all of your concerns and could be safer and cause less code changes.

As above, fundamentally, introducing a client API that holds
device_mutex is just wrong, so we need to address this.

I would also recommend splitting your per-device/global stuff anyhow,
global stuff needs a clear unwind during remove, and so on. It isn't
really optional to have this clarity.

> kref just hides an atomic refcount - so you're actually saying using
> the abstraction contradicts the kernel object's lifetime strategy?

kref has specific semantic meaning, it isn't a general use data
structure.

> I tend to agree. The __exit function flushes the workqueue (so eventually
> we guarentee that no code will execute before the module is unloaded).
> IMHO, after ib_unregister_client returns, the module could still run code
> (this is why the __exit handler exists), but it's not allowed to use any
> data of the module which unregistered it, meaning - we can't allow it to
> use any IB device.

Yes, I was being terse, of course the .text is still going to be used,
but the general idea of lifetime holds: the .text cannot remain in
service of the ib_device because the __exit handler cannot clean that
up.

> Ok, I get your point, thanks. I'll keep that call synchronous. The two
> options which are on the table right now are:
> (a) split the device_mutex to device_mutex and client_mutex.
>       ib_unregister_device first grabs only client_mutex and after it called
>       client->remove it grabs device->mutex to the rest of the work.
> (b) Introduce another workqueue for all device-specific events
> (actually, only rescan).
>       This allows us to flush only this workqueue without waiting for any
>       work which needs device_mutex.

The other option is to make rescan sense that the ib_device has been
freed and ignore it, and then flush the work queue that runs that on
module __exit. This might be needed anyhow due to the free race
discussed above. Be sure to add the necessary kref get/puts to hold
the ib device though.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
