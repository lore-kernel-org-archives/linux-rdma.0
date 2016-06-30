From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Thu, 30 Jun 2016 18:17:06 +0000
Message-ID: <HE1PR05MB14189E07EE8EE458E0CCD4DAB1240@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu>
 <022001d1d170$fda2c3e0$f8e84ba0$@opengridcomputing.com>
 <20160628211441.GA5786@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0663DA@ORSMSX109.amr.corp.intel.com>
 <20160629051956.GG3584@leon.nu> <20160629183042.GC17031@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160629183042.GC17031-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe

> On Wed, Jun 29, 2016 at 08:19:56AM +0300, Leon Romanovsky wrote:
> > On Tue, Jun 28, 2016 at 09:26:38PM +0000, Hefty, Sean wrote:
> > > > The fundamental question is if it is acceptable for libibverbs to
> > > > ship a new core provider agnostic API (cq polling) that is
> > > > optional depending on provider.
> > > >
> > > > I say no, that is not acceptable.
> > >
> > > I agree - there's no compelling argument that the new calls can't work over
> all providers.
> >
> > I agree too, this is why code is provided and nothing stops from other provider
> to support it.
> 
> That isn't what I said, and it isn't what everyone is agreeing with.
> 
> I said an optinal API is not acceptable to ship.
> 

What?
Almost every device interface has optional APIs.

The most immediate example is our beloved netdevice, in which almost everything is optional: fcoe support, flow steering, fdb settings, sriov controls...
All of these features are provider-agnostic, yet each netdev either implements them or not.

Especially in a performance-critical interface a polling API, I think that it actually makes more sense that each vendor provides the most optimized implementation that suits the HW.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
