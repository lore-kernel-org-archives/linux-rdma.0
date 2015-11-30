From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/core: correct issue with sge copyin corrupting wr
Date: Mon, 30 Nov 2015 23:39:05 +0200
Message-ID: <CAJ3xEMjqcvfe6Gvt5Ctee354RotRXCw8BATWTv2+zgpodGhMOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 30, 2015 at 4:34 PM, Mike Marciniszyn
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Being a non native English speaker I am not fully sure, but "copyin
corrupting" sounds like slang / street talking... proper English
please

> Commit e622f2f4ad21 ("IB: split struct ib_send_wr")
> introduced a regression for HCAs whose user mode post
> sends go through ib_uverbs_post_send().
>
> The code didn't account for the fact that the first sge is
> offset by an operation dependent length.  The allocation did,
> but the pointer to the sge list is computed without that knowledge.
>
> Store the operation dependent length in an automatic and
> compute the sge list copy in destination using that length.

in an automatic what?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
