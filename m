From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: recent qib patch
Date: Tue, 28 Apr 2015 18:32:25 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC256FE908@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Al Viro (viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org)" <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Al,

In commit=20

commit 4961772560d2f19695c73ece943716033ad62ac2
Author: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Date:=A0=A0 Sat Apr 4 00:11:32 2015 -0400

=A0=A0=A0 infinibad: weird APIs switched to ->write_iter()

=A0=A0=A0=A0=A0=A0=A0 Things Not To Do When Writing A Driver, part 1001=
st:
=A0=A0=A0 have writev() and write() on the same file doing completely
=A0=A0=A0 different things.=A0 As in, "interpret very different sets of
=A0=A0=A0 commands".

=A0=A0=A0=A0=A0=A0=A0 We _can_ handle that, but it's a bloody bad idea.
=A0=A0=A0 Don't do that in new drivers.=A0 Ever.

=A0=A0=A0 Signed-off-by: Al Viro viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org

You note an objection to qib's (and ipath's) use of the write overload =
for control messages.

What would be an acceptable mechanism for control v.s. data path?

It looks to me like this current implementation might have been to avoi=
d using ioctl.

Mike



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
