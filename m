From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible circular locking when unloading device driver
Date: Mon, 12 Oct 2015 16:17:53 +0300
Message-ID: <CAJ3xEMhPGAQQssgQsrk=k9WoBUTprJwTbzWUDqyg8Ft04x+AYA@mail.gmail.com>
References: <561B6D29.10001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561B6D29.10001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 11:19 AM, Sagi Grimberg
<sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> I stepped on this lockdep circular locking complaint on 4.3-rc when
> unloading the device driver (mlx5 in my case). Has anyone seen this?

yes, this lockdep party between s_active and rtnl_mutex is seen since
3.7 and was reported here couple of times.

@ some point I was suspecting this got introduced with the ipoib rtnl
childs patches I did, but no-one ever proved this with bisection,
AFAIK.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
