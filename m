From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/4] rpm spec: install documentation too
Date: Mon, 17 Oct 2016 11:53:34 -0400
Message-ID: <20161017155334.GH14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-2-jarod@redhat.com>
 <20161014225204.GB16509@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014225204.GB16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 04:52:04PM -0600, Jason Gunthorpe wrote:
> On Fri, Oct 14, 2016 at 03:21:33PM -0400, Jarod Wilson wrote:
> > At least in the Red Hat world, we like to install the documentation files
> > provided in a given source tree.
> 
> I think other distros would like to do this too, can you use this
> patch instead?

Ah. Yeah. My cmake-fu is ... lacking. That does look like a better way to
go. I'll pull this into my working tree and play with it.

> From a23838ccc05574b1975741770abcbd66f7587293 Mon Sep 17 00:00:00 2001
> From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date: Fri, 14 Oct 2016 15:21:33 -0400
> Subject: [PATCH] Install end user focused documentation files
> 
> We recommend that all distros ship these.
> 
> Suggested-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                   | 3 ++-
>  Documentation/CMakeLists.txt     | 8 ++++++++
>  debian/ibacm.install             | 1 +
>  debian/ibverbs-providers.install | 1 +
>  debian/libibcm1.install          | 1 +
>  debian/libibverbs1.install       | 1 +
>  debian/librdmacm1.install        | 1 +
>  debian/srptools.install          | 1 +
>  rdma-core.spec                   | 4 +++-
>  9 files changed, 19 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/CMakeLists.txt
...

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
