From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and hca_core_clock
 to query_device
Date: Fri, 29 May 2015 08:46:06 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505290845040.8178@east.gentwo.org>
References: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com> <20150527222108.GA7855@obsidianresearch.com> <5566BDE4.50709@mellanox.com> <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org> <20150528162416.GA6515@obsidianresearch.com>
 <alpine.DEB.2.11.1505281212330.1711@east.gentwo.org> <20150528175043.GA10966@obsidianresearch.com> <alpine.DEB.2.11.1505281325150.1794@east.gentwo.org> <20150528195034.GA11182@obsidianresearch.com> <alpine.DEB.2.11.1505281522020.2703@east.gentwo.org>
 <20150528204749.GA12780@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528204749.GA12780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 May 2015, Jason Gunthorpe wrote:

> My point was exposing raw wrapping counters is a horrible UAPI.

Well this is a kernel bypass API and a lot of raw hardware issues will
have to be handled since you do go directly to the device.

> > through a complete cycle. But that is the nature of these counters. And
> > thats what you see when you look into the kernel timer subsystem for
> > example.
>
> Very little in the kernel is exposed to that wrapping, the timer
> subsystem takes care of it. Certainly, userspace never sees it.

Right but then we are not at the comfortable sockets API here but at the
bare metal level.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
