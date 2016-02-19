From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Recovering from IBV_EVENT_DEVICE_FATAL in librdmacm application?
Date: Fri, 19 Feb 2016 10:03:23 -0800
Message-ID: <CAL1RGDXux9KFEUkBeegeiGGJdvKpGv_rRRs-cqNj1U6Nq0YSiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello again everyone,

I'm assessing the state of the art in writing an application that can
recover from an HCA castastrophic error (aka IBV_EVENT_DEVICE_FATAL
async event), and it appears the pieces are not there yet.  What is
supposed to happen from the kernel side is that userspace closes all
of its contexts, then the kernel tears down and recreates the device,
and userspace reopens the device and starts over.

However it doesn't look like there is any way for librdmacm to call
ibv_close_device() without tearing down the whole library and closing
all devices (which is disruptive if my application is also using
another HCA that didn't hit a catastrophic error).  But even if we add
an interface to close a single cma_device, libibverbs doesn't really
have a way to wait for the device to be torn down and reinitialized.
(In the kernel, we have the ib_client.add and ib_client.remove
callbacks, but libibverbs just initializes a static array of devices
at library initialization)

Is there any work on closing these gaps that has been done yet
(perhaps in OFED or in pending patches), or have I found a wide open
field to innovate in?


As a side note, how does opensm handle this?  I haven't tried it yet,
but from reading code I believe that libibumad will not correctly pass
the ib_umad failure back up to opensm, and so opensm will be stuck
with a dead /dev/infiniband/umadX file handle forever.  Is that
assessment correct?

Thanks!
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
