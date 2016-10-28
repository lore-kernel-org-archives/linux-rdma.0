From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] verbs: Replace infiniband/sa-kern-abi.h
 with the kernel's uapi/rdma/ib_user_sa.h
Date: Fri, 28 Oct 2016 09:42:31 -0600
Message-ID: <20161028154231.GA10441@obsidianresearch.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1477609570-8087-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161028065344.GA28303@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028065344.GA28303-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 11:53:44PM -0700, Christoph Hellwig wrote:
> I can't see how this is supposed to work, there is no copy at all
> of ib_user_sa.h in the tree.

It uses the one that comes with the distro. Which is new enough on all
supported distros..

In this specific case because ib_user_sa.h is included by a public
header we really don't have much choice, it has to work with the
distro-version.

Fortunately ib_user_sa.h has not changed in a long time, so this is
not a problem and I didn't include an in-tree copy. Several of the
other headers are like that too.

rxe and netlink are counter examples, where we need really new headers
and they are not used in public headers so they have in-tree copies.

> E.g. by default use headers from rdma-core/kernel/headers, but
> optionally allow the build systems to use those from a kernel tree
> explicitly specified.

I've done both of these things, with the twist that the build tests
the distro-header first and uses it before the in-tree copy if it is
new enough.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
