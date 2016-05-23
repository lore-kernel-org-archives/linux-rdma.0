From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Mon, 23 May 2016 14:09:29 +0000
Message-ID: <VI1PR05MB13910E30E227D4DCDBC19033D24E0@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
 <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <d54c2884-c2e9-8952-75f8-43147943640c@redhat.com>
 <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
 <20160518171536.GB15170@obsidianresearch.com>
 <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
 <VI1PR05MB1391B1C6DFE620C31A6474A0D2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <561a675d-89d2-e675-cf83-e86ecb7519b6@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EDE332@CRSMSX101.amr.corp.intel.com>
 <20160523085809.GF25500@leon.nu> <57430E34.3090501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57430E34.3090501-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, May 23, 2016 5:06 PM
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> resolution module into core
> 
> On 5/23/2016 4:58 AM, Leon Romanovsky wrote:
> > On Wed, May 18, 2016 at 07:36:03PM +0000, Weiny, Ira wrote:
> >>> On 05/18/2016 02:28 PM, Mark Bloch wrote:
> >>>>
> >>>>
> >>>>> -----Original Message-----
> >>>>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> >>>>> Sent: Wednesday, May 18, 2016 8:59 PM
> >>>>> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >>>>> Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-
> >>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>>>> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> >>>>> resolution module into core
> >>>>>
> >>>>> On 05/18/2016 01:15 PM, Jason Gunthorpe wrote:
> >>>>>> On Wed, May 18, 2016 at 10:51:02AM -0400, Doug Ledford wrote:
> >>>>>>> moves it into the ib_core and also keep the new ib_netlink stuff in
> >>>>>>> ib_core.  So, fewer modules, not more.
> >>>>>>
> >>>>>> What about getting rid of ib_sa as well so we can avoid that dynamic
> >>>>>> netlink registration patch too?
> >>>>>
> >>>>> That's fine too.
> >>>> Integrating ib_sa into ib_core also means to do the same for ib_mad.
> >>>> If you agree with it (ib_sa & ib_mad becoming part of ib_core), I'll
> create
> >>> the patches.
> >>>
> >>> Ira, Hal?
> >>>
> >>
> >> I don't see a problem with that.
> >
> > Doug,
> >
> > Will it be acceptable to you if Mark base his patches on this assumption?
> 
> Yes.
> 

Actually the new series is already posted, 
http://marc.info/?l=linux-rdma&m=146366717406108&w=2
if you can have a look at it'll be great.

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
