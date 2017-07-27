From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Thu, 27 Jul 2017 19:23:23 -0400
Message-ID: <1501197803.2593.10.camel@redhat.com>
References: <20170726053749.GV3259@mtr-leonro.local>
         <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
         <20170726130350.GW3259@mtr-leonro.local>
         <7aad42cd-05be-b7a7-9e85-2c13f5d489d3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7aad42cd-05be-b7a7-9e85-2c13f5d489d3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-27 at 14:32 -0400, Doug Ledford wrote:
> On 7/26/2017 9:03 AM, Leon Romanovsky wrote:
> > On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro wrote:
> > > On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
> > > > Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state
> > > > transition from reset to error"
> > > > 
> > > > On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
> > > > > On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> > > > 
> > > > <snip>
> > > > 
> > > > > > BTW, when will you post for-4.14 branch so we will be able
> > > > > > to base our
> > > > > > submission queue for the -next?
> > > > > 
> > > > > Tomorrow.  I wanted to base it on 4.13-rc2 so it would get
> > > > > all of the
> > > > > fixes that went in this week.
> > > > 
> > > > Any news on the matter?
> > > > 
> > > 
> > > Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch
> > > there.
> > 
> > Are you referring to this branch?
> > https://github.com/torvalds/linux/compare/master...dledford:k.o/for
> > -next
> > 
> > It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.
> 
> I created a for-next and then I've been making various other branches
> through the week and sending them to github to be checked by 0day
> testing.  Once they pass 0day, I merge them into the for-next and
> push
> one more time to make sure the combination of everything merged
> together
> passes 0day, and once I get confirmation that the build is good, I'll
> push it to k.o where it will be considered unrebaseable, and so any
> fixes after that may require incremental patches, reverts, etc.  The
> slowdown this week has largely been the turnaround time on 0day
> testing.
>  That's been taking in excess of 10 hours from a push to test results
> :-/.  I pushed what I want to push to k.o this morning about 8am, not
> sure when I'll get my 0day results back.

The current for-next is pushed to k.o.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
