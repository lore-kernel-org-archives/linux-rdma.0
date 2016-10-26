From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Avoid possible hang on device removal
Date: Wed, 26 Oct 2016 10:03:33 -0600
Message-ID: <20161026160333.GB24898@obsidianresearch.com>
References: <1477428628-11504-1-git-send-email-mustafa.ismail@intel.com>
 <01ec01d22f02$53012630$f9037290$@opengridcomputing.com>
 <20161025224318.GA7816@obsidianresearch.com>
 <064101d22f8f$3b6e7850$b24b68f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <064101d22f8f$3b6e7850$b24b68f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 08:45:33AM -0500, Steve Wise wrote:
> > > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > >
> > > Also, this fixes a previous commit, so you could add this tag:
> > >
> > > Fixes 612eae1f6fe3 ("rping: ignore flushed completions")
> > >
> > > However that commit id is from the previous librdmacm repo...not
> > > sure how useful it is?
> > 
> > It still exists in the new repo, I'd include the fixes line.
> > 
> > Jason
> 
> Hey Jason, how do I see the history?
> 
> [root@stevo1 rdma-core]# git log --pretty=oneline --abbrev-commit
> librdmacm/examples/rping.c
> 9024876 rdmacm: Use correct format specifier for size_t
> 400122e Be explicit about _GNU_SOURCE
> 663098b Rename librdmacm

Add --follow

$ git log --follow --pretty=oneline --abbrev-commit librdmacm/examples/rping.c
44579aeb63ee Enable -Wwrite-strings
90248767130f rdmacm: Use correct format specifier for size_t
400122ef15bd Be explicit about _GNU_SOURCE
663098bfc3ac Rename librdmacm
171176797516 [v1, 1/1, librdmacm] examples/rping.c: fix unwanted abort during qp creation
c9ac6566b26c [librdmacm] examples: Use gai_strerror rather than perror for [rdma_]getaddrinfo failures
5c5bd081e37a rping: create persistent server threads in DETACHED state
612eae1f6fe3 rping: ignore flushed completions
5ae36aba6f95 rping: Fixes race, where ibv context was getting freed before memory was deregistered
b70a390d8bd8 rping: Fix server reporting error on exit
e57196c71ddd [5/5,librdmacm] rping: added checks to the return values functions
860b1a8784f1 rping: Reduce retry_count to fit in 3-bits
5658ff385e04 rping: Replace sprintf with snprintf to protect from buffer overflow
93635fa33b41 librdmacm/rping: Make sure CQ event thread exits before destroying the CQ
8c6aeb3e70bb RPING: Remove printf for FLUSH completion.
4e33a4109a62 librdmacm: returns errors from the library consistently
267c28a2f03b rping: add ipv6 support
ea9b03238b13 librdmacm/rping: allow specifying hostnames in place of IP addresses
163f48d410fa librdmacm/rping: fix duplicate usage message
308b811d8d6b librdmacm: implement address change event
1beed21b111e librdmacm/examples
[..]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
