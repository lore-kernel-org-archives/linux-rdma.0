From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core, cmake/ninja question
Date: Thu, 22 Sep 2016 14:34:28 -0500
Message-ID: <01a301d21508$559b52d0$00d1f870$@opengridcomputing.com>
References: <00cc01d214e6$e4cb2d80$ae618880$@opengridcomputing.com> <20160922154814.GB15212@obsidianresearch.com> <014501d214ed$6e4472f0$4acd58d0$@opengridcomputing.com> <20160922163143.GC6994@obsidianresearch.com> <019201d21501$3a191a80$ae4b4f80$@opengridcomputing.com> <20160922192932.GA25659@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160922192932.GA25659-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Thu, Sep 22, 2016 at 01:43:36PM -0500, Steve Wise wrote:
> 
> > > Apply this patch:
> > >
> > > https://github.com/jgunthorpe/rdma-
> > > plumbing/commit/64ed4fd30a2157bdaf0a8f7f1b04d2dad02c1b8f
> > >
> > > It hardwires the search path into libverbs and libverbs will look into
> > > the place it was installed before searching the system library
> > > path. That will eliminate the problem you mentioned above.
> > >
> > > Further, after that patch is applied you can do a rough imitation of
> > > 'run-in-place' like this:
> > >
> > > $ cmake .. -DVERBS_PROVIDER_DIR:PATH=`pwd`/lib -
> > > DSYSCONF_INSTALL_DIR:PATH=/etc
> > >
> >
> > And how do I build this after the cmake?
> 
> Sorry, you always need the -GNinja, I was just being brief
> 
> I also mistyped the ETC name.
> 
> I tested this:
> 
> $ mkdir build ; cd build
> $ cmake .. -GNinja -DVERBS_PROVIDER_DIR:PATH=`pwd`/lib -
> DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc
> $ ninja
> $ strace bin/ibv_devinfo  2>&1 | grep -i rdmav2
> open("/tmp/rdma-core/build/lib/libmlx4-rdmav2.so", O_RDONLY|O_CLOEXEC) = 3
> 
> Note LD_LIBRARY_PATH is needed to run things from outside build/bin/
> 
> I have some thoughts to make this simpler, call it a proof of concept for
> run-from-build ..
> 

No worries.  I'm just thick headed. :)  Its working for me.  I've made a change
to libcxgb4 and can test by running in the build tree. I compile with and
without my change and see that the correct libcxgb4 is being used.  Ship it!  :)

So if I have a libcxgb4 change to submit, I should submit it against rdma-core,
ja?

Thanks Jason!

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
