From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 17:44:49 -0700
Message-ID: <20170301004449.GA13114@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3389d831-c135-b326-4b96-5f2a746de5ac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 28, 2017 at 04:47:05PM -0500, Doug Ledford wrote:

> > I don't think that we should introduce an asych context into libibverbs.
> 
> Why not?

Generally, I dislike the idea of running threads from libraries,
particularly libraries like ibverbs. So many apps get no benefit from
the thread, but it sits there connected to udev..

But aside from that, threads create races, and in this case if the
hidden thread has to run to get the up to date device list, then the
application has to synchronize with it to get the up to date
information.

This is practically problematic because one of the areas we need to
fix is rdma-cm which is already getting a kind of new-device
notification from kernel messages that are not synchronized with udev
or any other thread.

In this case I think the simple solution is the most correct one - run
readdir on every call to ibv_get_devices and do set-interesection with
the internal list before returning the result. Easy, simple locking,
no races to worry about.

We probably also need to add some retries for opening /dev/uverbsXX
based on sysfs to really solve all the races...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
