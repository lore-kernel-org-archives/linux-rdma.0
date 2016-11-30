From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 18:17:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BA20F@ORSMSX109.amr.corp.intel.com>
References: <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
 <5927e04b-42ec-52c1-88a3-456cc4409334@talpey.com>
 <HE1PR0501MB28124286F8D902C49596EF85B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130163949.GC24639@obsidianresearch.com>
 <HE1PR0501MB28128CDB112558C5980CB638B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <20161130170830.GA17512@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
 <20161130173211.GA9067@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161130173211.GA9067-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni
List-Id: linux-rdma@vger.kernel.org

> > Maybe the solution is to make the protocol selection explicit
> > throughout the APIs and associate it with a QP, rather than
> > attempting to list all transport protocols that a port can support.
> 
> AH's are linked to a PD, not a QP..

But protocols are associated with QPs.  I'm not sure *why* an AH is linked to a PD.  Conceptually the association seems unnecessary.

> If we had to do it again, a PD centric approach would be more
> sensible:
> 
>   // Create a PD on 'port' using ah format 'protocol'
>   pd = ibv_pd_create(port, enum ah_type protocol);
> 
>   // Enable APM or resource sharing on the PD across two ports
>   ibv_pd_add_port(pd, alt_port);
> 
> And get rid of the multi-port ib_device concept entirely.

I think no matter what option is chosen, some limitation may end up being placed on how a device is used that may not map to hardware limits.  I'm personally fine with that, but we need to define the right level of abstraction (and pick the right terms to describe them).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
