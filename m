From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 18:28:47 +0000
Message-ID: <VI1PR05MB1391B1C6DFE620C31A6474A0D2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <VI1PR05MB13915036338162B126E55CC2D2480@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
 <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <d54c2884-c2e9-8952-75f8-43147943640c@redhat.com>
 <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
 <20160518171536.GB15170@obsidianresearch.com>
 <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe88d9cc-3d03-030d-c4c9-360ef0ce7067-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, May 18, 2016 8:59 PM
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> resolution module into core
> 
> On 05/18/2016 01:15 PM, Jason Gunthorpe wrote:
> > On Wed, May 18, 2016 at 10:51:02AM -0400, Doug Ledford wrote:
> >> moves it into the ib_core and also keep the new ib_netlink stuff in
> >> ib_core.  So, fewer modules, not more.
> >
> > What about getting rid of ib_sa as well so we can avoid that dynamic
> > netlink registration patch too?
> 
> That's fine too.
Integrating ib_sa into ib_core also means to do the same for ib_mad.
If you agree with it (ib_sa & ib_mad becoming part of ib_core), I'll create the patches.

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
