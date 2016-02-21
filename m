From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Recovering from IBV_EVENT_DEVICE_FATAL in librdmacm application?
Date: Sun, 21 Feb 2016 08:51:53 -0800
Message-ID: <CAG4TOxPy1LQf4cfYm=_zSyr1RuEhLds+ZDiuYKcrD-cFmKUEnA@mail.gmail.com>
References: <CAL1RGDXux9KFEUkBeegeiGGJdvKpGv_rRRs-cqNj1U6Nq0YSiw@mail.gmail.com>
 <HE1PR05MB1418BB2F8E162955160E2D3EB1A20@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418BB2F8E162955160E2D3EB1A20-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Right, that's pretty much what I wrote.  However I think it's a bit
worse than "be informed of this event and re-open the HCA context."
Userspace needs to synchronize with the kernel to wait for the uverbs
device to be torn down and recreated, and there's no guarantee that
the device will come back with the same name.  (A perhaps contrived
example is a glitch of a PCI switch with multiple HCAs below it - we
might reset and re-enumerate the HCAs in a different order the second
time around)

 - R.

On Sun, Feb 21, 2016 at 3:56 AM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Roland,
>
> The kernel part is in place, but user-space support is not complete.
>
> When a specific RDMA device receives a fatal event, the user is guaranteed to get this event.
> What is missing is a way for rdmacm (maybe via a well-behaved app that provides the context for reading asynch errors) to be informed of this event and re-open the HCA context.
>
> BTW, rdmacm also doesn't notice when new RDMA devices pop up...
> --Liran
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
>> Sent: Friday, February 19, 2016 8:03 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Doug
>> Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> Subject: Recovering from IBV_EVENT_DEVICE_FATAL in librdmacm application?
>>
>> Hello again everyone,
>>
>> I'm assessing the state of the art in writing an application that can recover from
>> an HCA castastrophic error (aka IBV_EVENT_DEVICE_FATAL async event), and it
>> appears the pieces are not there yet.  What is supposed to happen from the
>> kernel side is that userspace closes all of its contexts, then the kernel tears down
>> and recreates the device, and userspace reopens the device and starts over.
>>
>> However it doesn't look like there is any way for librdmacm to call
>> ibv_close_device() without tearing down the whole library and closing all
>> devices (which is disruptive if my application is also using another HCA that
>> didn't hit a catastrophic error).  But even if we add an interface to close a single
>> cma_device, libibverbs doesn't really have a way to wait for the device to be
>> torn down and reinitialized.
>> (In the kernel, we have the ib_client.add and ib_client.remove callbacks, but
>> libibverbs just initializes a static array of devices at library initialization)
>>
>> Is there any work on closing these gaps that has been done yet (perhaps in OFED
>> or in pending patches), or have I found a wide open field to innovate in?
>>
>>
>> As a side note, how does opensm handle this?  I haven't tried it yet, but from
>> reading code I believe that libibumad will not correctly pass the ib_umad failure
>> back up to opensm, and so opensm will be stuck with a dead
>> /dev/infiniband/umadX file handle forever.  Is that assessment correct?
>>
>> Thanks!
>>   Roland
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
