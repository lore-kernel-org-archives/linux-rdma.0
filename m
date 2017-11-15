From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Tue, 14 Nov 2017 18:49:25 -0800
Message-ID: <20171115024924.GA23574@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171114085143.GS18825@mtr-leonro.local>
 <20171114182720.GC18825@mtr-leonro.local>
 <20171114190029.GI18825@mtr-leonro.local>
 <20171114192510.GA6083@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171114192858.GM4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114192858.GM4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 12:28:58PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 11:25:12AM -0800, Bryan Tan wrote:
> > On Tue, Nov 14, 2017 at 09:00:29PM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 14, 2017 at 08:27:20PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 14, 2017 at 10:51:43AM +0200, Leon Romanovsky wrote:
> > > > > The commit 25f07300bfb7 ("vmw_pvrdma: Add SRQ support") causes to build
> > > > > failures in Travis CI [1] and on my system too [2].
> > > > >
> > > > > Please fix.
> > > >
> > > > I reverted the commit, please fix compilation error and resubmit.
> > > >
> > > > Commit: 32bf4efb8605 ("Revert "vmw_pvrdma: Add SRQ support" because it causes build failures")
> > > 
> > > Just as a pointer, it fails on the systems with kernel's include/uapi/rdma/vmw_pvrdma-abi.h
> > > file available, so fixup is not applied but without your definition yet.
> > 
> > Thanks for the notice, I should have tried building on a kernel without
> > the updated ABI header. We had a question though, what would be the best
> > approach to fix this?
> 
> The cmake scheme always uses the distro header if the distro header
> passes the 'test'. Till now the test for pvrdma.h was existance only.
> 
> Now that you depend on new stuff, you have to update the test to see
> if the header is new enough.
> 
> > We didn't bump up the ABI version after discussion on the pull
> > request.
> 
> Correct.
> 
> > there is an ABI version mismatch, or if a macro is not defined (in this
> > case, PVRDMA_UAR_SRQ_OFFSET)? I thought that we'd use the fixup over the
> > ABI header exposed by the kernel, but my assumption there was wrong.
> 
> Look in buildlib/RDMA_LinuxHeaders.cmake and copy something like the
> rdma/rdma_netlink.h line, but test for PVRDMA_UAR_SRQ_OFFSET.

Thanks for your suggestion, Jason. I've opened up a new pull request
that includes the original commit for SRQ support that has been
reverted, along with the one line change you suggested. Let me know if
you prefer something different. I've run the travis build on kernels
both with and without the new ABI header as well.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
