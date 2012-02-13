From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: user space FMR support
Date: Mon, 13 Feb 2012 15:13:50 -0800
Message-ID: <CABgxfbGDVEUS=017Ts7L2zfSzRnyF=t+xFKLXeqxT4Biiq=_xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To make a long story short ....  FMR = fast memory registration ...

I "had" been using a set of FMR patches that exported the existing
kernel FMR support to user space (with mlx4 driver) for about a year.
A mistake in re-installing the development cluster this morning wiped
out the private OFED package that contained the changes. I could
probably be able to repatch everything in a couple of days but it is a
very annoying process. I can't be the only person who needs the FMR in
user space (?).

Does anyone have a handy set of patches that can make public (or
better, push upstream with newer set of kernels) ?

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
