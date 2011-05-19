From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Optimized path for kernel post_send/post_recv
Date: Thu, 19 May 2011 15:48:50 -0700
Message-ID: <BANLkTimdXLS5R4pN-_752_1O4EtOm2NOyQ@mail.gmail.com>
References: <20110324123937.19461.56781.stgit@gkslx010.igk.intel.com> <4DD582E9.6020509@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DD582E9.6020509-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2011 at 1:51 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> Do you plan to merge this?

No... never got a reply after my previous reply:

Overall, looks pretty sane and non-intrusive.  I would like to see
patches for at least one driver using it before we merge this.

> +       if (file->ucontext->use_shpage_for_rxtx) {

Why do we attach this flag to the entire ucontext rather than
an individual QP?  It seems more awkward to require two
contexts if a process wants to use both bypass and non-bypass QPs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
