From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibcm] Return errors from the kernel consistently
Date: Tue, 20 Oct 2009 10:09:22 -0700
Message-ID: <34B1325549824112A02BFE95F2886CB2@amr.corp.intel.com>
References: <20091020055834.GA26350@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020055834.GA26350-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>This fixes one subtle bug, where a return of 0 from the kernel will
>result in a success report from the library, and fixes a terrible
>API in the process. Use errno, or return the code, or both.
>Not half and half..
>
>It is easier to return errno than to fixup the cases that don't,
>so lets stick with that.
>
>Codes should have been be positive for alignment with POSIX, but
>it is much too late for that..
>
>Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>---
> src/cm.c |   30 +++++++++++++++---------------
> 1 files changed, 15 insertions(+), 15 deletions(-)
>
>librdmacm has the same basic flaw too.

Thanks - I'll fixup librdmacm the same way.

Is there a reason that you used -1*errno, rather than just -errno?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
