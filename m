From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] IB multicast cleanup patches V2
Date: Wed, 23 Dec 2015 15:02:02 -0500
Message-ID: <20151223200202.GS3860@phlsvsds.ph.intel.com>
References: <20151221144252.575119561@linux.com> <567AE3BF.6020407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <567AE3BF.6020407-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 01:11:11PM -0500, Doug Ledford wrote:
> On 12/21/2015 09:42 AM, Christoph Lameter wrote:
> > V1->V2
> >  - Add Reviewed by's for first patch from Ira Weiny
> >  - Change name of ipoib_check_mcast_sendonly() to
> > 	ipoib_check_and_add_mcast_sendonly() as requested by Ira
> > 
> > This patchset cleans up the code a bit after the last round of multicast
> > patches related to the sendonly join logic. Some of the bits of code
> > landed in ipoib_main.c instead of ipoib_multicast.c.
> > 
> > - Move the multicastbits into that file so that everything is neatly together
> > - Reduce the number of functions exported from ipoib_multicast.c
> > 
> > This patchset can be retrieved from a git repo on kernel.org via
> > 
> > git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/rdma.git cleanup
> > 
> 
> Thanks, applied (with Ira's name fixed).

Thanks!  :-D

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
