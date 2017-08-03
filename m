From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Thu, 03 Aug 2017 13:44:37 -0400
Message-ID: <1501782277.117042.24.camel@redhat.com>
References: <1501590709.2725.10.camel@redhat.com>
         <20170801200846.GA3808@obsidianresearch.com>
         <1501766608.3581.6.camel@profitbricks.com>
         <1501773757.117042.12.camel@redhat.com>
         <1501775364.3581.9.camel@profitbricks.com>
         <20170803165902.GB13127@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170803165902.GB13127-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-03 at 10:59 -0600, Jason Gunthorpe wrote:
> On Thu, Aug 03, 2017 at 05:49:24PM +0200, Benjamin Drung wrote:
> > Am Donnerstag, den 03.08.2017, 11:22 -0400 schrieb Doug Ledford:
> > > On Thu, 2017-08-03 at 15:23 +0200, Benjamin Drung wrote:
> > > > Am Dienstag, den 01.08.2017, 14:08 -0600 schrieb Jason
> > > > Gunthorpe:
> > > > > On Tue, Aug 01, 2017 at 08:31:49AM -0400, Doug Ledford wrote:
> > > > > 
> > > > > > This is a little bit late, so it would be best to keep -rc
> > > > > > cycles
> > > > > > on it
> > > > > > to a minimum and get the final version pushed out
> > > > > > soon.  With
> > > > > > the
> > > > > > "excitement" of this last release cycle/merge window, this
> > > > > > slipped
> > > > > > my
> > > > > > mind.  My apologies.
> > > > > 
> > > > > Benjamin,
> > > > > 
> > > > > What more do you need in this release to start submitting to
> > > > > to
> > > > > the
> > > > > debian archive?
> > > > 
> > > > I am waiting for the common udev/systemd based module auto
> > > > loading
> > > > support (#174) to be merged to master and the release of v15.
> > > 
> > > I was planning on merging 174 before final release.  I don't know
> > > if
> > > you saw, but in another thread I mentioned that our internal
> > > cluster
> > > for RDMA testing has been down for a reorg, I actually wanted to
> > > get
> > > this on the cluster and test it before final release as well.  So
> > > I
> > > hope to have v15 out soon, but there are a couple things gating
> > > that
> > > release as far as I'm concerned.
> > 
> > That sounds like a good plan.
> 
> I will update 174 today with the latest comments.
> 
> Doug, I think you should test the final product,

I planned on it.  I even provisioned some machines in our cluster (it's
still not all the way back up, but it's limping along now at about 75%
capacity) only to find that the latest Fedora 26 and Fedora Rawhide
images totally bail out if your machine has an ipoib interface in it. 
Bug filed with the anaconda team.  I'll fanagle an install somehow and
have some machines ready to test this ;-)

>  there will be another
> two PRs (one is the patch I sent the list, another is enabling
> sd_notify) to largely complete the full design.

Ok.

> We will also need to disable redhat/rdma.service for the testing to
> be
> complete.

Yeppers.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
