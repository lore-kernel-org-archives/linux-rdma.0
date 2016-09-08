From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RFCv3: Consolidated userspace RDMA library repo
Date: Thu, 8 Sep 2016 12:31:22 -0600
Message-ID: <20160908183122.GC21614@obsidianresearch.com>
References: <20160907040925.GA27361@obsidianresearch.com>
 <2e2b54f5-1a9d-bb31-ffd9-fe6936011aaf@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2e2b54f5-1a9d-bb31-ffd9-fe6936011aaf-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 07:26:38AM -0400, Hal Rosenstock wrote:
> On 9/7/2016 12:09 AM, Jason Gunthorpe wrote:
> > Hello Everyone,
> > 
> > I've updated the repo, and I think we are now at the point to begin to
> > engage the distribution packagers and collect their feedback. As Doug
> > has suggested, there are many modifications that the distros have done
> > that could be folded back upstream.
> > 
> > It is available at:
> >   https://github.com/jgunthorpe/rdma-plumbing
> > 
> > Prior posts on this topic are still informative:
> >   http://www.spinics.net/lists/linux-rdma/msg39026.html
> >   http://www.spinics.net/lists/linux-rdma/msg39328.html
> >   http://www.spinics.net/lists/linux-rdma/msg40014.html
> 
> Looks to me that librdmacm is missing some patches. Sean moved this repo
> from the OFA server to github some time ago. What repo was used as basis
> for librdmacm in rdma-plumbing ?

Yep, good catch Hal, this is using the old URL.

I largely used https://openfabrics.org/downloads/MAINTAINERS as a
reference, so whoever is reposible should updated it I guess.

I've switched to https://github.com/ofiwg/librdmacm.git, and updated
the github.

Here is the list of trees if you can see any other mistakes:

    "git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git",
    "git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git",
    "git://git.openfabrics.org/~bvanassche/srptools.git",
    "git://git.openfabrics.org/~emulex/libocrdma.git",
    "git://git.openfabrics.org/~halr/libibumad.git",
    "git://git.openfabrics.org/~shefty/libibcm.git",
    "git://git.openfabrics.org/~swise/libcxgb3.git",
    "git://git.openfabrics.org/~swise/libcxgb4.git",
    "git://git.openfabrics.org/~tnikolova/libi40iw/.git",
    "git://git.openfabrics.org/~tnikolova/libiwpm",
    "git://git.openfabrics.org/~tnikolova/libnes/.git",
    "git://git.openfabrics.org/~yishaih/libmlx4.git",
    "git://git.openfabrics.org/~yishaih/libmlx5.git",
    "https://github.com/01org/libipathverbs.git",
    "https://github.com/01org/opa-libhfi1verbs.git",
    "https://github.com/SoftRoCE/librxe-dev.git",
    "https://github.com/ofiwg/librdmacm.git",

(see https://github.com/jgunthorpe/rdma-plumbing/blob/tooling/buildlib/make-merge.py)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
