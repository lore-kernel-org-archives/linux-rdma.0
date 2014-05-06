From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/5] ib/mad: Add pr_notice messages for various
 umad/mad registration failures
Date: Mon, 5 May 2014 20:57:14 -0600
Message-ID: <20140506025714.GC2307@obsidianresearch.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-4-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399340690-27677-4-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 05, 2014 at 09:44:48PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

An empty commit message is not good enough for the mainline kernel,
please describe motivation at least.

I am worried about log DOS potential here, it looks like many of these
messages could be triggered by userspace? Have you thought about this?

Generally moving this stuff to a pr_debug might be more appropriate,
it is very unusual to have logging like this for malformed syscall
arguments.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
