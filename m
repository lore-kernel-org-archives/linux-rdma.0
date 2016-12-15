From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 15 Dec 2016 12:18:00 -0800
Message-ID: <CA+55aFyja67hr4rFA+zGC=TMbsJ=p-4M1WC8KDsyxG_hY7BHSg@mail.gmail.com>
References: <ac96de9c-391b-70df-4c9d-d65d7dc28263@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ac96de9c-391b-70df-4c9d-d65d7dc28263-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2016 at 8:49 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> tags/for-linus

This adds a new compiler warning, and the compiler is obviously right:
rvt_cq_exit() is completely buggy and cannot possibly work.

I fixed it up in a separate commit, but I'm a bit annoyed.

                 Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
