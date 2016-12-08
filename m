From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Thu, 8 Dec 2016 09:29:32 +0000
Message-ID: <HE1PR0501MB28127FEFC67D9F71BF14BB6CB1840@HE1PR0501MB2812.eurprd05.prod.outlook.com>
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
 <20161207224044.GA23093@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207224044.GA23093-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, December 08, 2016 12:41 AM

> > >
> > > My preference is to discontinue attempts at associating a protocol wi=
th the
> device.  A device could implement a dozen protocols in software.  Transpo=
rts
> belong to QPs or cm ids, not devices.  Each rdma_cm_id should be associat=
ed
> with a specific cm/transport directly, rather than indirectly selecting o=
ne based
> on the bound <device, port>.
> > >
> > > If an app wants a specific transport type for a QP, why doesn't it ju=
st try to
> open one and see if the call fails?
> >
> > I tend to agree with Sean on this.  And to answer Or's question from a
> > couple emails back, I'm inclined to just take the last three patches
> > for now while we work out a better idea of how everything here should
> > be done on the first seven patches.
>=20

Yep, it's a good start.

> Well in that case, we should work toward getting rid of 'struct ib_device=
' - it is
> the cause of so much of this trouble. A port-focused model like the netst=
ack uses
> is overall saner..
>=20

We are discussing 2 separate issues:
(1) Whether a device can support multiple protocols
(2) Multi-port devices, optionally with different link types.

I think that we all agree that (1) will be needed for future devices, and t=
hat different QPs might be running different protocols.
This means that supported protocols need to be device capabilities, as we h=
ave today in the kernel.
There are several devices that implement (2), which follows directly from t=
he specification. The model for these devices is not going to change.

There is a question on where to report protocol capabilities - at the devic=
e or port level. This is regardless of how the kernel CMA will resolve whic=
h device and port will service a connection - it's a matter of transparency=
 and management.
Doing so at the device level will require apps to know which protocols run =
on which link type. Doing so at the port level will be more obvious to apps=
, but won't be a common use case (assuming most apps will use rdmacm, which=
 will do the protocol resolution job for them in the kernel). Doing so at t=
he device level seems to be more aligned with how most future devices would=
 be implemented.
However, I won't rule out multi-port devices so soon. When the transport is=
 offloaded to HW, it makes sense to conduct HA between ports within the dom=
ain of a single device.

In any case, this has nothing to do with 'struct ib_device', which represen=
ts a device that handles packet processing internally and exposes transport=
 endpoints to applications.
--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
