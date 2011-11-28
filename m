From: Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 16/62] infiniband: remove the second argument of k[un]map_atomic()
Date: Mon, 28 Nov 2011 15:45:17 +0800
Message-ID: <4ED33C0D.3020001@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-17-git-send-email-amwang@redhat.com> <CAL1RGDXkh4xJJNO+7fkDXJ4f7LgwvbrHKTueiozUkiK0dkRBZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXkh4xJJNO+7fkDXJ4f7LgwvbrHKTueiozUkiK0dkRBZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=E4=BA=8E 2011=E5=B9=B411=E6=9C=8828=E6=97=A5 15:38, Roland Dreier =E5=86=
=99=E9=81=93:
> These look fine, given the second argument is unused.  So
>
> Acked-by: Roland Dreier<roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>

Thanks, Roland!

> ... or is there some point when the<linux/highmem.h>  part is
> going in and where it makes sense for me to apply this through
> my tree?
>

I think this patchset should be taken as a whole, so either Andrew
takes them all, or let Stephen to merge my tree[1] to linux-next.

But I don't know if Andrew has different opinions.

1. git://github.com/congwang/linux.git #for-next
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
