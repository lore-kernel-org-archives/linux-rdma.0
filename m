From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] verbs: Replace infiniband/sa-kern-abi.h
 with the kernel's uapi/rdma/ib_user_sa.h
Date: Thu, 27 Oct 2016 23:53:44 -0700
Message-ID: <20161028065344.GA28303@infradead.org>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1477609570-8087-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477609570-8087-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I can't see how this is supposed to work, there is no copy at all
of ib_user_sa.h in the tree.

Having to rely on system headers is a sure way to make the build
break most of the time.

What we need is a canonical copy of the kernel heades in the rdma-core
tree, with the option of just pointing to a kernel tree instead.

E.g. by default use headers from rdma-core/kernel/headers, but
optionally allow the build systems to use those from a kernel tree
explicitly specified.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
