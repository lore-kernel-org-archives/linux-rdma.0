From: Vivek Kashyap <kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Sun, 17 Jun 2012 23:37:33 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1206172330220.13728@oc4747053027.ibm.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com> <20120614172245.GC6552@obsidianresearch.com> <alpine.LRH.2.00.1206142336220.13728@oc4747053027.ibm.com> <20120615171919.GA17224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120615171919.GA17224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Fri, 15 Jun 2012, Jason Gunthorpe wrote:

> On Thu, Jun 14, 2012 at 11:48:09PM -0700, Vivek Kashyap wrote:
>>> I don't think anyone ever made patches for this, but considering the
>>> performance delta you see it really seems worthwhile.
>>
>> How about something like below? Basically the the 'checksum-less'
>> operation is only between hosts that both support it by extending
>> the existing IB connection setup mechanism. The following also keeps
>> the changes confined to ipoib-cm module.
>
> It is much better to do things properly (as I described) so you don't
> have a gotcha when a packet gets routed.
>
> We don't want to fake that we are doing csum, we want to forward the
> csum offload data to the other side, which might discard it or might
> use it to forward the packet out another interface. This is not hard,
> just fiddly work.

We certainly need to ensure that the routed packet is not left without a
checksum. One either does not enable 'checksum less link' on routers, or 
else the router must be able to take care of it when it forwards the packet.

By 'csum offload data' do you mean something akin to csum_start/csum_offset?
How would one transmit this information when using IPoIB-CM across from the
sending host to the router? If we can do that it will certainly be useful.

Otherwise what I was proposing was that a router is either configured to not
accept checksum less configuration on IPoIb-CM, or if checksum less links are 
supported then, when forwarding to a 'checksum less' interface it does nothing;
but when forwarding to any other interface the checksum is added.

This addition is really done in the ipoib-cm driver to insulate from the
rest of the stack. The 'faking' of checksum offload is only to the local
IP stack so that it does not do the calculation but leaves it to the
IPoIB-CM driver. That is what we essentially do with virtio or hardware
offload mechanisms.

We are working on a test patch. That should make it easier to discuss the 
gaps or if the solution is complete.

thanks
Vivek

>
> -- 
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
> Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
