From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/ipoib: fixup multicast locking issues
Date: Fri, 13 Mar 2015 10:41:42 +0200
Message-ID: <CAJ3xEMjHrTH_F=zPDsH9A9qRWo=AYN4sgbsdDKV62nzBkB5kXA@mail.gmail.com>
References: <cover.1424562072.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 22, 2015 at 2:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This is the re-ordered, squashed version of my 22 patch set that I
> posted on Feb 11.  There are a few minor differences between that
> set and this one.  They are:
[...]

Doug, you wrote here a very detailed listing of the changes from
earlier posts and the testing the patches went through, which is
excellent. It would be very good if you can also post few liner
telling the changes done by the series in high level, so we can have
this test as part of a "merge" commit that says in the kernel logs.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
