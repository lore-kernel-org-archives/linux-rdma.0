From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 7 Dec 2016 15:40:44 -0700
Message-ID: <20161207224044.GA23093@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB0BA1B7@ORSMSX109.amr.corp.intel.com>
 <d4bab4a9-aa32-282f-b501-ecfc00b0be0f@talpey.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA68E@ORSMSX109.amr.corp.intel.com>
 <HE1PR0501MB2812393A0A690DEC1E03DE3FB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161205171013.GA27784@obsidianresearch.com>
 <HE1PR0501MB2812A66403A8C19AF83742EDB1830@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <CAJ3xEMhYs0jtXYDqAXEw17Fk4padG903J3enL+uNPg_fNk-9Uw@mail.gmail.com>
 <20161206213938.GC647@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BBEC7@ORSMSX109.amr.corp.intel.com>
 <d7bca935-32cb-51ee-beea-724e1a5b748a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d7bca935-32cb-51ee-beea-724e1a5b748a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 07, 2016 at 05:06:24PM -0500, Doug Ledford wrote:
> On 12/6/2016 5:13 PM, Hefty, Sean wrote:
> >> I've already proposed disallowing multiprotocol struct ib_devices.
> > 
> > My preference is to discontinue attempts at associating a protocol with the device.  A device could implement a dozen protocols in software.  Transports belong to QPs or cm ids, not devices.  Each rdma_cm_id should be associated with a specific cm/transport directly, rather than indirectly selecting one based on the bound <device, port>.
> > 
> > If an app wants a specific transport type for a QP, why doesn't it just try to open one and see if the call fails?
> 
> I tend to agree with Sean on this.  And to answer Or's question from a
> couple emails back, I'm inclined to just take the last three patches for
> now while we work out a better idea of how everything here should be
> done on the first seven patches.

Well in that case, we should work toward getting rid of 'struct
ib_device' - it is the cause of so much of this trouble. A
port-focused model like the netstack uses is overall saner..

We can figure out some other way to model what ports can be shared
within a PD, ideally something that works better for rxe..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
