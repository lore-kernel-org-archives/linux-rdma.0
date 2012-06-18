From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Mon, 18 Jun 2012 11:53:16 -0600
Message-ID: <20120618175316.GD591@obsidianresearch.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com>
 <20120614172245.GC6552@obsidianresearch.com>
 <alpine.LRH.2.00.1206142336220.13728@oc4747053027.ibm.com>
 <20120615171919.GA17224@obsidianresearch.com>
 <alpine.LRH.2.00.1206172330220.13728@oc4747053027.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1206172330220.13728-Nzfcc2Us4m+Xfo/+vza+31aTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2012 at 11:37:33PM -0700, Vivek Kashyap wrote:

> >On Thu, Jun 14, 2012 at 11:48:09PM -0700, Vivek Kashyap wrote:

> >We don't want to fake that we are doing csum, we want to forward the
> >csum offload data to the other side, which might discard it or might
> >use it to forward the packet out another interface. This is not hard,
> >just fiddly work.
> 
> We certainly need to ensure that the routed packet is not left without a
> checksum. One either does not enable 'checksum less link' on
> routers, or else the router must be able to take care of it when it
> forwards the packet.

The latter is vastly preferred.

> By 'csum offload data' do you mean something akin to csum_start/csum_offset?
> How would one transmit this information when using IPoIB-CM across from the
> sending host to the router? If we can do that it will certainly be useful.

That plus a ip_summed needed flag seems to match what virtio_net is
doing. Review virtio_net.c:receive_buf and xmit_skb to see how it
handles the packet.

Also, I am just reminded, there has been some interest in also
forwarding GSO through the CM connection. This would speed things up
as well and avoid the need for the wonky 64k MTU. 

ie rework the CM mode to follow more closely how virtio-net works.

Like virtio_net you'd have to prefix a small header, or if you are
lucky, maybe encoding things in the 32 bits of immediate data.

> Otherwise what I was proposing was that a router is either
> configured to not accept checksum less configuration on IPoIb-CM, or

This sort of solution is something I'd like to avoid, it is not
necessary to make something so fragile.

> This addition is really done in the ipoib-cm driver to insulate from the
> rest of the stack. The 'faking' of checksum offload is only to the local
> IP stack so that it does not do the calculation but leaves it to the
> IPoIB-CM driver. That is what we essentially do with virtio or hardware
> offload mechanisms.

I mean 'faking' in the sense you tell the stack you will compute the
checksum, throw away the information needed to do that calculation,
and the send a packet on the wire that can never be check-summed
properly.

I don't see the point of keeping things contained to the CM part of
the ipoib driver, if the ipoib packet handling needs to be changed then
change it..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
