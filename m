From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Latest for-4.14
Date: Fri, 28 Jul 2017 12:54:56 -0400
Message-ID: <1501260896.2593.18.camel@redhat.com>
References: <20170726053749.GV3259@mtr-leonro.local>
         <b337a2ae-40ff-a207-82fa-fd3c7d2e1083@intel.com>
         <20170726130350.GW3259@mtr-leonro.local>
         <a1abee42-58d2-aba6-bc56-9bf1830a4539@redhat.com>
         <20170728043233.GE13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170728043233.GE13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-07-28 at 07:32 +0300, Leon Romanovsky wrote:
> On Thu, Jul 27, 2017 at 02:34:57PM -0400, Doug Ledford wrote:
> > On 7/26/2017 9:03 AM, Leon Romanovsky wrote:
> > > On Wed, Jul 26, 2017 at 08:24:44AM -0400, Dennis Dalessandro
> > > wrote:
> > > > On 7/26/2017 1:37 AM, Leon Romanovsky wrote:
> > > > > Reply to: "Re: [PATCH for-next 7/9] IB/core: Allow QP state
> > > > > transition from reset to error"
> > > > > 
> > > > > On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
> > > > > > On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> > > > > 
> > > > > <snip>
> > > > > 
> > > > > > > BTW, when will you post for-4.14 branch so we will be
> > > > > > > able to base our
> > > > > > > submission queue for the -next?
> > > > > > 
> > > > > > Tomorrow.  I wanted to base it on 4.13-rc2 so it would get
> > > > > > all of the
> > > > > > fixes that went in this week.
> > > > > 
> > > > > Any news on the matter?
> > > > > 
> > > > 
> > > > Check Doug's GitHub, I see a 4.13-rc2 based "for-next" branch
> > > > there.
> > > 
> > > Are you referring to this branch?
> > > https://github.com/torvalds/linux/compare/master...dledford:k.o/f
> > > or-next
> > > 
> > > It doesn't have most of mlx5/mlx4/cavium/core/e.t.c features.
> > 
> > Oh, and I never said I would be *done* processing the for-next area
> > all
> > in one go.  You said you wanted regular progress and updates, and
> > the
> > branch I have represents that.  But regular progress does not mean
> > take
> > everything all at once.  As I process more patchsets, more will be
> > added.
> > 
> 
> Regular sharing of information is also part of regular progress.

Yes it is.  And there is a specific order to when maintainers share
information: when the code lands at k.o (or wherever that maintainer's
official repo is located), the maintainer notifies the author that the
code has been accepted (except Linus, who tends to take pull requests
without response unless there is something wrong with it).  That's the
standard process.  I'm following it.  I didn't get my successful 0day
result on the merged up branch until this morning, at which point I
pushed my branch to k.o, so today is "email everyone and update
patchworks" day.  You had access to my github repo where you could have
clearly seen what I was working on, but I guess you were just too busy
tapping your finger and waiting on an email to check it.  That's your
problem, not mine.  I don't know of any maintainers that email people
about their code while it's still being processed and before it has
officially landed in their repo (unless there are review issues or
build failures that kick it back out), so I don't know why you would
expect different from me, but it's not gonna happen.

> As I said more than once, I'm fine with sequential work, I'm fine
> with
> the fact that not all my code is accepted, I'm fine with scheduled
> delays, but I'm not fine with silence.



-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
