From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Thu, 8 Dec 2016 10:41:52 -0700
Message-ID: <20161208174152.GA11025@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB0BA68E@ORSMSX109.amr.corp.intel.com>
 <HE1PR0501MB2812393A0A690DEC1E03DE3FB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161205171013.GA27784@obsidianresearch.com>
 <HE1PR0501MB2812A66403A8C19AF83742EDB1830@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAJ3xEMhYs0jtXYDqAXEw17Fk4padG903J3enL+uNPg_fNk-9Uw@mail.gmail.com>
 <20161206213938.GC647@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BBEC7@ORSMSX109.amr.corp.intel.com>
 <d7bca935-32cb-51ee-beea-724e1a5b748a@redhat.com>
 <20161207224044.GA23093@obsidianresearch.com>
 <HE1PR0501MB28127FEFC67D9F71BF14BB6CB1840@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR0501MB28127FEFC67D9F71BF14BB6CB1840-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 08, 2016 at 09:29:32AM +0000, Liran Liss wrote:

> > Well in that case, we should work toward getting rid of 'struct ib_device' - it is
> > the cause of so much of this trouble. A port-focused model like the netstack uses
> > is overall saner..
> > 
> 
> We are discussing 2 separate issues:
> (1) Whether a device can support multiple protocols
> (2) Multi-port devices, optionally with different link types.
> 
> I think that we all agree that (1) will be needed for future
> devices,

We all agree future hardware devices will support multiple protocols,
but I don't think there is any agreement so far on how to model that,
or what 'struct ib_device' means in such a world. As I said, I'd like
to get rid of it if we use a QP centric model to solve this problem.

> and that different QPs might be running different protocols.  This
> means that supported protocols need to be device capabilities,

No, they are QP capabilities, add new APIs to work with and query QP
related things and stop using the device for anything.

> have today in the kernel.  There are several devices that implement
> (2), which follows directly from the specification. The model for
> these devices is not going to change.

Again, no, the specification for multiport devices does not
contemplate different addressing formats, so the one driver that did
this went off spec in a badly thought out manner and left us this
mess.

> kernel). Doing so at the device level seems to be more aligned with
> how most future devices would be implemented.  However, I won't rule
> out multi-port devices so soon. When the transport is offloaded to
> HW, it makes sense to conduct HA between ports within the domain of
> a single device.

It is a QP thing if we go down Sean's suggestion, so add QP related
queries to get the information.

I have no idea how to model HA in this world - presumably when you add
an AH to a QP it will refuse to do it if the implied HA model isn't
supported.

But, I'm not sure how well the QP model works when talking about
HA/APM..

> In any case, this has nothing to do with 'struct ib_device', which
> represents a device that handles packet processing internally and
> exposes transport endpoints to applications.

We need to make sense of what 'struct ib_device' is to figure out how
to solve these problems because we have multiple different definitions
running around concurrnatly in the stack - that is why it doesn't work
today to have more than one protocol on a struct ib_device.

So, yes, it actually has everything to do with 'struct ib_device'..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
