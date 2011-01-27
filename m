From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Infiniband Shared Memory Segment
Date: Thu, 27 Jan 2011 08:55:02 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1E969AF@orsmsx501.amr.corp.intel.com>
References: <AANLkTik6h8t0+hBzFZ=eWXKiS2kV8CFuODUNCm_-VqR0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik6h8t0+hBzFZ=eWXKiS2kV8CFuODUNCm_-VqR0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What kind of data might be located within the memory pointed to by the
> FD? I.e. Could there be configuration information for the connection
> and/or HCA? Could there be the data waiting to be sent (although I
> don't believe the HCA buffers)? Would it just be the command sent to
> the HCA?

A write to the uverbs file issues a command to the lower driver, for example, to allocate a QP or CQ.  Reads are not supported.  A read to the event file will retrieve information about an asynchronous event (e.g. port up/down).  Writes to that file are not handled.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
