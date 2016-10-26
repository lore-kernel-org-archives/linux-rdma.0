From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] Avoid possible hang on device removal
Date: Wed, 26 Oct 2016 08:45:33 -0500
Message-ID: <064101d22f8f$3b6e7850$b24b68f0$@opengridcomputing.com>
References: <1477428628-11504-1-git-send-email-mustafa.ismail@intel.com> <01ec01d22f02$53012630$f9037290$@opengridcomputing.com> <20161025224318.GA7816@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025224318.GA7816-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > Also, this fixes a previous commit, so you could add this tag:
> >
> > Fixes 612eae1f6fe3 ("rping: ignore flushed completions")
> >
> > However that commit id is from the previous librdmacm repo...not
> > sure how useful it is?
> 
> It still exists in the new repo, I'd include the fixes line.
> 
> Jason

Hey Jason, how do I see the history?

[root@stevo1 rdma-core]# git log --pretty=oneline --abbrev-commit
librdmacm/examples/rping.c
9024876 rdmacm: Use correct format specifier for size_t
400122e Be explicit about _GNU_SOURCE
663098b Rename librdmacm

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
