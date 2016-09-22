From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core, cmake/ninja question
Date: Thu, 22 Sep 2016 10:31:43 -0600
Message-ID: <20160922163143.GC6994@obsidianresearch.com>
References: <00cc01d214e6$e4cb2d80$ae618880$@opengridcomputing.com>
 <20160922154814.GB15212@obsidianresearch.com>
 <014501d214ed$6e4472f0$4acd58d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <014501d214ed$6e4472f0$4acd58d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 22, 2016 at 11:21:53AM -0500, Steve Wise wrote:
> > 
> > I recommend *against* running 'make install' to /usr. This is a big
> > package now, it is hard to unwind it once it installs over your
> > system. I really should finish the run in place patch :|
> > 
> > If you do this:
> > 
> > $ echo /usr/local/lib64/ > /etc/ld.so.conf.d/usrlocal.conf && ldconfig
> > 
> > Then you can install to /usr/local/ and things will work as you
> > expect. Note, this depends on a verbs patch that is still only in my
> > preview tree.
> 
> So I have a dev system setup with everything installed from the distro in /usr.
> I have my rdma-core git tree.  I change libcxgb4 to fix a bug.  I want to test
> it.  I install it to /usr/local and add /etc/ld.so.conf.d/usrlocal.conf.  But
> that still doesn't work because ldconfig still finds libcxgb4 in /usr/lib64
> first...

Apply this patch:

https://github.com/jgunthorpe/rdma-plumbing/commit/64ed4fd30a2157bdaf0a8f7f1b04d2dad02c1b8f

It hardwires the search path into libverbs and libverbs will look into
the place it was installed before searching the system library
path. That will eliminate the problem you mentioned above.

Further, after that patch is applied you can do a rough imitation of
'run-in-place' like this:

$ cmake .. -DVERBS_PROVIDER_DIR:PATH=`pwd`/lib -DSYSCONF_INSTALL_DIR:PATH=/etc

(untested) That hardwires the build directory into libibverbs, so it
will try to load all drivers from there first.

Then use

$ export LD_LIBRARY_PATH=`pwd`/lib

And all verbs using programs started from that shell will use the full
new library set and the new providers without having to do make
install at all.

I plan to automate this basic approach for 'run in place', please let
me know if it works for you and makes sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
