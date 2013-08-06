From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 0/8] Critical bug fixes for RDMA/cxgb4
Date: Tue, 6 Aug 2013 10:42:30 -0700
Message-ID: <CAL1RGDXuigeKkMawuRZ_5GVnkQ0Mm0FiMk4eqZ5jthHHDx1v=g@mail.gmail.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 6, 2013 at 8:34 AM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:

> This series is on top of previously submitted series "Add IPv6 support for
> iWARP" which can be found at following location:
> http://comments.gmane.org/gmane.linux.network/272124
> We request Roland to merge above series first and then apply this series on top
> of it.

I can do that, and in fact I should be able to start queueing 3.12
material soon.  However, if these are really critical bug fixes, do
you want them to wait for 3.12 as well?

Which are really critical bug fixes?  For example, just from the
subject line, I can't see advertising the wrong MR size as a critical
bug.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
