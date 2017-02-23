From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core make install failing
Date: Thu, 23 Feb 2017 16:12:47 -0700
Message-ID: <20170223231247.GB18086@obsidianresearch.com>
References: <20170223230008.GA546@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170223230008.GA546-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 23, 2017 at 06:00:09PM -0500, ira.weiny wrote:
> I'm not sure what I'm doing wrong but make install seems to be deleting a
> library and then complaining that it can't find it for installation...  :-/
> 
> After running build.sh I ran make install and get this error:

Oh.. you can't 'make install' when using build.sh. I guess we should
have a more explicit error message for this case.

build.sh now uses -DIN_PLACE=1 which arranges for everything to run
smoothly without being installed. Just run build/bin/blat or do
LD_LIBRARY_PATH=`pwd`/build/bin to use the new library with something
out of tree. There is no longer a big reason for developers to 'make
install' anymore.

Part of the trick that happens to make IN_PLACE work is that the
install path is set to /nfs/site/home/iweiny/rdma-core/build/lib/
which means 'make install' tries to overwrite the built output and
just generally makes a mess.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
