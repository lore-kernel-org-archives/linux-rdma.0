From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 11:58:55 -0700
Message-ID: <20161130185855.GA11617@obsidianresearch.com>
References: <5927e04b-42ec-52c1-88a3-456cc4409334@talpey.com>
 <HE1PR0501MB28124286F8D902C49596EF85B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130163949.GC24639@obsidianresearch.com>
 <HE1PR0501MB28128CDB112558C5980CB638B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130170830.GA17512@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
 <20161130173211.GA9067@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA20F@ORSMSX109.amr.corp.intel.com>
 <20161130183436.GA10057@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA24D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BA24D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 30, 2016 at 06:46:13PM +0000, Hefty, Sean wrote:
> > > But protocols are associated with QPs.  I'm not sure *why* an AH is
> > > linked to a PD.  Conceptually the association seems unnecessary.
> > 
> > The AH has to be linked to the PD because the PD specifies the
> > hardware target and the AH is a hardware object. All objects must be
> > traced back to a PD. It is linked to a PD not a QP because the AH can
> > be shared across all QPs, which is useful for UD applications..
> > 
> > The AH is really similar to the ethernet layer in an IP stack, and the
> > QP
> > is akin the TCP layer.
> 
> I always viewed the AH as specifying the route to the destination
> port.  Locally, I still don't see why it couldn't work across the
> device, like the CQ does.  Associating it with a PD just seems to
> limit which QPs, and by association the memory buffers, it can be
> used with.  So, I'm still not seeing the reason for the linkage...

Oh I see what you mean, I forgot about that - yes, I don't see any
reason why the AH is linked to the PD not the ibv_context..

Perhaps it is an artifact of the thinking when applying this to the
kernel where each ULP would allocate resources to the PD and then
destroy the PD when the connection is done? So per ulp resources were
charged to the PD..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
