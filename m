From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core] Add -DIN_PLACE=1 to cmake
Date: Thu, 22 Dec 2016 16:30:17 -0600
Message-ID: <029801d25ca2$f8bb2f80$ea318e80$@opengridcomputing.com>
References: <20161222221559.GA15947@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222221559.GA15947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This configures the paths to run the software from the local build
> directory. Much of this is done automatically by how cmake uses rpath,
> but the two cases where we dlopen things have to be handled by us.
> 
> The simple solution is to hard wire the build directory path into the
> binaries.
> 
> 'etc' is also relocated to build/etc/ as that is part of how the verbs
> providers are located.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                | 23 +++++++++++++++++++++--
>  README.md                     |  3 ++-
>  build.sh                      |  4 ++--
>  buildlib/rdma_functions.cmake |  4 ++--
>  ibacm/CMakeLists.txt          |  5 +++++
>  5 files changed, 32 insertions(+), 7 deletions(-)
> 
> Steve, this is a refined version of what I sent you ealier, does it
> work for you?
> 

I was able to run rping from build/bin/rping and it loaded
build/lib/libcxgb4-rdmav2.so, so it worked for me.

Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
