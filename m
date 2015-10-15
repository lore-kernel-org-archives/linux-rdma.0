From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/core: Print error when umem fails due to locked memory limit.
Date: Thu, 15 Oct 2015 10:21:56 -0400
Message-ID: <1444918916-17928-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It can be rather tedious to find why userspace is failing when only
thing kernel report is -ENOMEM. This add an error message so that
user can figure out why they are getting -ENOMEM.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/u=
mem.c
index 38acb3c..a66929e 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -169,6 +169,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *con=
text, unsigned long addr,
 	lock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
=20
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		pr_err("locked memory quota exhausted (see ulimit -l)\n");
 		ret =3D -ENOMEM;
 		goto out;
 	}
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
