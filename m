From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-core make install failing
Date: Fri, 24 Feb 2017 02:41:22 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E3C6513E7@CRSMSX101.amr.corp.intel.com>
References: <20170223230008.GA546@phlsvsds.ph.intel.com>
 <20170223231247.GB18086@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223231247.GB18086-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ok I see...

The issue is that there is a bug in libibmad/infiniband-diags when building against the changes you made to the libibumad headers and using "make install" seemed easier than trying to set up building against my home dir...

I'll try to build against the headers in build.

Ira

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, February 23, 2017 3:13 PM
> To: Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: rdma-core make install failing
> 
> On Thu, Feb 23, 2017 at 06:00:09PM -0500, ira.weiny wrote:
> > I'm not sure what I'm doing wrong but make install seems to be
> > deleting a library and then complaining that it can't find it for
> > installation...  :-/
> >
> > After running build.sh I ran make install and get this error:
> 
> Oh.. you can't 'make install' when using build.sh. I guess we should have a more
> explicit error message for this case.
> 
> build.sh now uses -DIN_PLACE=1 which arranges for everything to run smoothly
> without being installed. Just run build/bin/blat or do
> LD_LIBRARY_PATH=`pwd`/build/bin to use the new library with something out
> of tree. There is no longer a big reason for developers to 'make install' anymore.
> 
> Part of the trick that happens to make IN_PLACE work is that the install path is
> set to /nfs/site/home/iweiny/rdma-core/build/lib/
> which means 'make install' tries to overwrite the built output and just generally
> makes a mess.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
