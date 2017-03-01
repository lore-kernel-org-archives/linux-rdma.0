From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 15:23:20 -0700
Message-ID: <20170301222320.GA2820@obsidianresearch.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
 <20170301004449.GA13114@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
 <cad3d2c6-0c98-9f58-a3bb-81823103bd76@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cad3d2c6-0c98-9f58-a3bb-81823103bd76-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 04:56:50PM -0500, Doug Ledford wrote:

> isn't a new device in the list already, then great too.  Because the
> initial implementation proposal left if up to the app to determine
> how/when to check for a new device, there was never any guarantee that
> whatever triggered the app to look for the new device meant that it was
> ready to be used in sysfs

No, that isn't true. The kernel guarentees that sysfs is fully setup
before it can deliver any sort of event, by any channel, to an
app. This includes rdma connection establish, uevents for udev,
netlink notifications/etc.

> and would be found by the re-reading of the sysfs directory.  So
> whatever race might be present in my proposed implementation would
> also be present in the original implementation.

Since the kernel strongly orders things, there is no race in Alex's
suggestion.

All apps using rdma-cm have to cope with hot plug transparently. An
app can 'all device' bind and get an incomming connection from the
kernel on a newly plugged device. This must work without having the
app do any new steps or introducing races between the rdma-cm channel
and some other channel hidden in verbs.

> Personally I would use a thread in the library that would block on
> inotify events from the sysfs directory.

sysfs does not support inotify.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
