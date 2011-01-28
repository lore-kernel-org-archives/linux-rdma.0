From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Infiniband Shared Memory Segment
Date: Thu, 27 Jan 2011 16:57:47 -0800
Message-ID: <AANLkTinFgShQG3BjWqE=8QcSgNo+Q=kdiATTqJ5K4dBd@mail.gmail.com>
References: <AANLkTik6h8t0+hBzFZ=eWXKiS2kV8CFuODUNCm_-VqR0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik6h8t0+hBzFZ=eWXKiS2kV8CFuODUNCm_-VqR0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> What kind of data might be located within the memory pointed to by the
> FD? I.e. Could there be configuration information for the connection
> and/or HCA? Could there be the data waiting to be sent (although I
> don't believe the HCA buffers)? Would it just be the command sent to
> the HCA?

I'm not sure what you mean by "memory pointed to by the FD".  File
descriptors don't point to memory, do they?

/dev/infiniband/uverbs0 is used for two things: userspace does write()
on it to tell the kernel to do various control path things like creating QPs,
modifying QPs, etc.  Also userpace does mmap() on it to get access to
a device-specific region; on many adapters it is used to map PCI BAR
space directly into the userspace process for kernel bypass on data path
operations.

The event file is used for the kernel to return async events to userspace.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
