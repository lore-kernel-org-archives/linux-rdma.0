From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] libibverbs IB device hotplug support
Date: Wed, 1 Mar 2017 18:00:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0ECDC6@ORSMSX109.amr.corp.intel.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
 <20170301004449.GA13114@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301004449.GA13114-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > I don't think that we should introduce an asych context into
> libibverbs.
> >
> > Why not?
> 
> Generally, I dislike the idea of running threads from libraries,
> particularly libraries like ibverbs. So many apps get no benefit from
> the thread, but it sits there connected to udev..

I thought Doug was referring to reporting the device add/remove event through some event reporting interface, like what the librdmacm already does.  So no threads for that are needed.  IMO, this makes sense.

I didn't follow his idea for how the device list would be updated and kept in sync between the app and the library.

If you had device add/remove events, the get_event call could intercept that event and update the device list there.  But I don't know that you try to sync a shared list between the library and the app.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
