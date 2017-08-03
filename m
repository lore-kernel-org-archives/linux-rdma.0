From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Thu, 3 Aug 2017 10:59:02 -0600
Message-ID: <20170803165902.GB13127@obsidianresearch.com>
References: <1501590709.2725.10.camel@redhat.com>
 <20170801200846.GA3808@obsidianresearch.com>
 <1501766608.3581.6.camel@profitbricks.com>
 <1501773757.117042.12.camel@redhat.com>
 <1501775364.3581.9.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501775364.3581.9.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 03, 2017 at 05:49:24PM +0200, Benjamin Drung wrote:
> Am Donnerstag, den 03.08.2017, 11:22 -0400 schrieb Doug Ledford:
> > On Thu, 2017-08-03 at 15:23 +0200, Benjamin Drung wrote:
> > > Am Dienstag, den 01.08.2017, 14:08 -0600 schrieb Jason Gunthorpe:
> > > > On Tue, Aug 01, 2017 at 08:31:49AM -0400, Doug Ledford wrote:
> > > > 
> > > > > This is a little bit late, so it would be best to keep -rc
> > > > > cycles
> > > > > on it
> > > > > to a minimum and get the final version pushed out soon.  With
> > > > > the
> > > > > "excitement" of this last release cycle/merge window, this
> > > > > slipped
> > > > > my
> > > > > mind.  My apologies.
> > > > 
> > > > Benjamin,
> > > > 
> > > > What more do you need in this release to start submitting to to
> > > > the
> > > > debian archive?
> > > 
> > > I am waiting for the common udev/systemd based module auto loading
> > > support (#174) to be merged to master and the release of v15.
> > 
> > I was planning on merging 174 before final release.  I don't know if
> > you saw, but in another thread I mentioned that our internal cluster
> > for RDMA testing has been down for a reorg, I actually wanted to get
> > this on the cluster and test it before final release as well.  So I
> > hope to have v15 out soon, but there are a couple things gating that
> > release as far as I'm concerned.
> 
> That sounds like a good plan.

I will update 174 today with the latest comments.

Doug, I think you should test the final product, there will be another
two PRs (one is the patch I sent the list, another is enabling
sd_notify) to largely complete the full design.

We will also need to disable redhat/rdma.service for the testing to be
complete.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
