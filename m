From: Jaswinder Singh Rajput <jaswinder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] infiniband: fops_get is not required for core,
 uverbs_main.c
Date: Sat, 26 Sep 2009 13:46:01 +0530
Message-ID: <1253952962.3897.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


fops_get is useless as 'uverbs_event_fops' will always be 'true'.
This also fix compilation warning :

  CC [M]  drivers/infiniband/core/uverbs_main.o
drivers/infiniband/core/uverbs_main.c: In function =E2=80=98ib_uverbs_a=
lloc_event_file=E2=80=99:
drivers/infiniband/core/uverbs_main.c:522: warning: the address of =E2=80=
=98uverbs_event_fops=E2=80=99 will always evaluate as =E2=80=98true=E2=80=
=99

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband=
/core/uverbs_main.c
index d3fff9e..a59ddd1 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -513,13 +513,8 @@ struct file *ib_uverbs_alloc_event_file(struct ib_=
uverbs_file *uverbs_file,
 		goto err;
 	}
=20
-	/*
-	 * fops_get() can't fail here, because we're coming from a
-	 * system call on a uverbs file, which will already have a
-	 * module reference.
-	 */
 	filp =3D alloc_file(uverbs_event_mnt, dget(uverbs_event_mnt->mnt_root=
),
-			  FMODE_READ, fops_get(&uverbs_event_fops));
+			  FMODE_READ, &uverbs_event_fops);
 	if (!filp) {
 		ret =3D -ENFILE;
 		goto err_fd;
--=20
1.6.0.6


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
