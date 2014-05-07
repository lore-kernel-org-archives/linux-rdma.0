From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] ib/mad: Add pr_notice messages for various umad/mad
 registration failures
Date: Wed, 7 May 2014 14:35:38 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B82CAF@CRSMSX101.amr.corp.intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-4-git-send-email-ira.weiny@intel.com>
 <20140506025714.GC2307@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140506025714.GC2307-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, May 05, 2014 at 09:44:48PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> An empty commit message is not good enough for the mainline kernel,
> please describe motivation at least.

Will do.

> 
> I am worried about log DOS potential here, it looks like many of these
> messages could be triggered by userspace? Have you thought about this?

Yes I did think about it, see below.

> 
> Generally moving this stuff to a pr_debug might be more appropriate, it is
> very unusual to have logging like this for malformed syscall arguments.

I debated using debug.  The problem with debug is that it requires a kernel recompile.  This may not be acceptable for some users.  Ib_umad devices should  only be accessible from a privileged user which I felt was sufficient protection against a DOS attack.  But if it would be more acceptable I can change to [pr|dev]_debug.

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
