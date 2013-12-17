From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 for-3.13 03/10] IB/uverbs: remove implicit cast in INIT_UDATA()
Date: Tue, 17 Dec 2013 10:58:52 +0100
Message-ID: <b3b9d8cd45543c6b8f664d9e8206a0f6aa1df6ce.1387273677.git.ydroneaud@opteya.com>
References: <cover.1387273677.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, INIT_UDATA() does an implicit cast to a pointer,
so that 'response' address, eg. output buffer, can be used
as is to initialize a struct ib_udata:

        do {                                                    \
                (udata)->inbuf  =3D (void __user *) (ibuf);       \
                (udata)->outbuf =3D (void __user *) (obuf);       \
                (udata)->inlen  =3D (ilen);                       \
                (udata)->outlen =3D (olen);                       \
        } while (0)

=2E..

        INIT_UDATA(&udata, buf + sizeof cmd,
                   (unsigned long) cmd.response + sizeof resp,
                   in_len - sizeof cmd, out_len - sizeof  resp);

=2E..

Unfortunately, sparse reports an error if literal 0 is used
to initialize inbuf or outbuf, for example in:

        INIT_UDATA(&ucore,
                   (hdr.in_words) ? buf : 0,
                   (unsigned long)ex_hdr.response,
                   hdr.in_words * 8,
                   hdr.out_words * 8);

It was reported by kbuild test robot in message[1]:

  From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  Subject: "drivers/infiniband/core/uverbs_main.c:683:17:
      sparse: Using plain integer as NULL pointer",
  Message-Id: <528b3984.SVGs20ZWpcuR/Jls%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Replacing 0 by NULL in ib_uverbs_write() might turn off sparse warning,
but it trigger a GCC warning:

drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
drivers/infiniband/core/uverbs_main.c:685:200: warning: pointer/integer=
 type mismatch in conditional expression [enabled by default]

So fixing the sparse warning require broad changes in uverbs.

By removing the implicit cast INIT_UDATA(), this patch fixes the warnin=
gs
reported by sparse and allows the compiler to report a warning in case =
a
plain integer get used to initialize an udata pointer.

This patch requires
- calls to INIT_UDATA() to be modified to pass a pointer instead of an
  unsigned long,
- struct ib_udata to be modified to have a const void __user *inbuf fie=
ld[2],
  otherwise compiler will report warnings regarding const to non const
  conversion:

drivers/infiniband/core/uverbs_main.c: In function =E2=80=98ib_uverbs_w=
rite=E2=80=99:
drivers/infiniband/core/uverbs_main.c:682:24: attention : assignment di=
scards =E2=80=98const=E2=80=99 qualifier from pointer target type [enab=
led by default]
drivers/infiniband/core/uverbs_main.c:688:22: attention : assignment di=
scards =E2=80=98const=E2=80=99 qualifier from pointer target type [enab=
led by default]
drivers/infiniband/core/uverbs_cmd.c: In function =E2=80=98ib_uverbs_ge=
t_context=E2=80=99:
drivers/infiniband/core/uverbs_cmd.c:307:23: attention : assignment dis=
cards =E2=80=98const=E2=80=99 qualifier from pointer target type [enabl=
ed by default]
drivers/infiniband/core/uverbs_cmd.c: In function =E2=80=98ib_uverbs_al=
loc_pd=E2=80=99:
drivers/infiniband/core/uverbs_cmd.c:516:23: attention : assignment dis=
cards =E2=80=98const=E2=80=99 qualifier from pointer target type [enabl=
ed by default]
=2E..

[1] https://lists.01.org/pipermail/kbuild-all/2013-November/002120.html

[2] https://patchwork.kernel.org/patch/2846202/
    http://marc.info/?i=3D3050a98379b4342ea59d59aeaf1ce162171df928.1376=
847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Link: http://marc.info/?i=3Dcover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      | 12 ++++++------
 drivers/infiniband/core/uverbs_main.c | 13 ++++++++-----
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core=
/uverbs.h
index 9879568aed8c..0dca1975d59d 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -47,12 +47,12 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
=20
-#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
-	do {								\
-		(udata)->inbuf  =3D (const void __user *) (ibuf);		\
-		(udata)->outbuf =3D (void __user *) (obuf);		\
-		(udata)->inlen  =3D (ilen);				\
-		(udata)->outlen =3D (olen);				\
+#define INIT_UDATA(udata, ibuf, obuf, ilen, olen)	\
+	do {						\
+		(udata)->inbuf  =3D (ibuf);		\
+		(udata)->outbuf =3D (obuf);		\
+		(udata)->inlen  =3D (ilen);		\
+		(udata)->outlen =3D (olen);		\
 	} while (0)
=20
 /*
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband=
/core/uverbs_main.c
index 34386943ebcf..14d864371050 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -635,6 +635,7 @@ static ssize_t ib_uverbs_write(struct file *filp, c=
onst char __user *buf,
 		__u32 command;
=20
 		struct ib_uverbs_ex_cmd_hdr ex_hdr;
+		char __user *response;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
 		int err;
@@ -668,7 +669,9 @@ static ssize_t ib_uverbs_write(struct file *filp, c=
onst char __user *buf,
 		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 !=3D count)
 			return -EINVAL;
=20
-		if (ex_hdr.response) {
+		response =3D (char __user *)(unsigned long)ex_hdr.response;
+
+		if (response) {
 			if (!hdr.out_words && !ex_hdr.provider_out_words)
 				return -EINVAL;
 		} else {
@@ -677,14 +680,14 @@ static ssize_t ib_uverbs_write(struct file *filp,=
 const char __user *buf,
 		}
=20
 		INIT_UDATA(&ucore,
-			   (hdr.in_words) ? buf : 0,
-			   (unsigned long)ex_hdr.response,
+			   (hdr.in_words) ? buf : NULL,
+			   response,
 			   hdr.in_words * 8,
 			   hdr.out_words * 8);
=20
 		INIT_UDATA(&uhw,
-			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : 0,
-			   (ex_hdr.provider_out_words) ? (unsigned long)ex_hdr.response + u=
core.outlen : 0,
+			   (ex_hdr.provider_in_words) ? buf + ucore.inlen : NULL,
+			   (ex_hdr.provider_out_words) ? response + ucore.outlen : NULL,
 			   ex_hdr.provider_in_words * 8,
 			   ex_hdr.provider_out_words * 8);
=20
--=20
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
