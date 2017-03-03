From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RXE, should I use rdma-core or the older stand-alone code
Date: Thu, 2 Mar 2017 17:44:37 -0700
Message-ID: <20170303004437.GA32227@obsidianresearch.com>
References: <CAANLjFru=X5RDEojsjMgzjjhe130raz3QPaPLZmS_W2Jru9Tkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFru=X5RDEojsjMgzjjhe130raz3QPaPLZmS_W2Jru9Tkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 02, 2017 at 04:53:54PM -0700, Robert LeBlanc wrote:

> I cloned rdma-core and built it using the build.sh scipt. I could use
> the rxe_cfg from providers/rxe/, but I was getting '(?)' for the MTU

This bug should have been fixed a few days ago.. I suspect when you
tested you probably didn't have this commit:

commit ebc66e2f29c8dd05331dc07b929f976e204001cb
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Mon Feb 27 11:47:22 2017 -0700

    rxe: Fix dropped padding in rxe_queue
    
    Dropping it was a typo.
    
    Reported-by: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Fixes: 6b26a9e24739 ("Use C11 atomics instead of wmb/rmb macros for CPU-only atomics")
    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

> ibv_devinfo: ../libibverbs/init.c:376: try_driver: Assertion
> `dev->_ops._dummy1 == ((void *)0)' failed.

However, this assertion is only present in an even newer checkin.

But, it can only trigger if a slightly older, mismatched, provider
library is present.

So, I think, your environment is messed up with mismatched
libaries and providers..

Manually copying files into /usr/ surely contributed to this,
cmake pre-install output has embedded rpath's and cannot be placed in
/usr/

> I also went into the build directory and ran cmake3 . -G"Unix
> Makefiles" and then installed it and had the exact problem.

The trouble with the default 'make install' is that it puts everything
in /usr/local, so it doesn't actually replace your existing local
install and unexpected stuff can happen if the two overlap improperly.

You don't need to install it to test it. Just use ./build.sh and run
the binaries or LD_LIBRARY_PATH the libraries under build/lib/. This
is designed to work properly without interfering with the system
install.

When you want to install it I always recommend making packages, the
redhat/rdma-core.spec will build proper RPMs for el7 that will cleanly
upgrade your existing ones without leaving conflicting residual stuff
around.

Most likely at this point you need to wipe out everything you have
done to /usr and /usr/local and start again.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
