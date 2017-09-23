From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 22 Sep 2017 17:23:00 -1000
Message-ID: <CA+55aFz2hYPEkweckHKpOU45bHQU7tFLKYoVWaMGduMSP4NCFA@mail.gmail.com>
References: <1506114769.120853.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506114769.120853.7.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 22, 2017 at 11:12 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> - Smattering of miscellanous fixes
> - A five patch series for i40iw that had a patch (5/5) that was larger
>   than I would like, but I took it because it's needed for large scale
>   users
> - An 8 patch series for bnxt_re that landed right as I was leaving on
>   PTO and so had to wait until now...they are all appropriate fixes for
>   -rc IMO

Honestly, I'm not sure if I'm going to pull this. I already got one
"fix" pull request today that I didn't think was just fixes.

This looks very similar - fixes mixed in with what looks like
development and new features that have never worked before.

I thought we agreed thar rdma wasn't going to continue to be "that subsystem"?

               Linu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
