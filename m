From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 13:44:17 +0200
Message-ID: <20161121114417.GA4158@leon.nu>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kvUQC+jR9YzypDnK
Content-Type: multipart/mixed; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2016 at 11:30:21AM +0100, Dmitry Vyukov wrote:
> On Mon, Nov 21, 2016 at 11:25 AM, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Mon, 21 Nov 2016, Dmitry Vyukov wrote:
> >
> >> WARNINGs mean kernel bugs.
> >> The one in ucma_write() points to user programming error
> >> or a malicious attempt. This is not a kernel bug, remove it.
> >>
> >> BUG/WARNs that are not kernel bugs hinder automated testing effots.
> >>
> >> Signed-off-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Cc: syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> >>
> >> ---
> >> Changes since v1:
> >>  - added printk_once
> >> ---
> >>  drivers/infiniband/core/ucma.c | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> >> index 9520154..405d0ce 100644
> >> --- a/drivers/infiniband/core/ucma.c
> >> +++ b/drivers/infiniband/core/ucma.c
> >> @@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
> >>       struct rdma_ucm_cmd_hdr hdr;
> >>       ssize_t ret;
> >>
> >> -     if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
> >> +     if (!ib_safe_file_access(filp)) {
> >> +             printk_once("ucma_write: process %d (%s) tried to do something hinky\n",
> >> +                     task_tgid_vnr(current), current->comm);
> >>               return -EACCES;
> >> +     }
> >>
> >>       if (len < sizeof(hdr))
> >>               return -EINVAL;
> >
> > FWIW, WARN_ON_ONCE came with commit e6bd18f57aad ("IB/security: Restrict
> > use of the write() interface"). Would it make sense to change the other
> > places as well?
>
>
> I guess so.
> Can I ask somebody of infiniband maintainers to take care of this?

Please see below,
Hope it helps.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--lMM8JwqTlfDpEaS6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-IB-core-qib-Remove-WARN-that-is-not-kernel-bug.patch"
Content-Transfer-Encoding: quoted-printable

=46rom e0bfe4771591f9ffbcaa4e66d6257ed95e2d7188 Mon Sep 17 00:00:00 2001
=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 21 Nov 2016 13:30:59 +0200
Subject: [PATCH] IB/{core, qib}: Remove WARN that is not kernel bug

WARNINGs mean kernel bugs, in this case, they are placed
to mark programming errors and/or malicious attempts.

BUG/WARNs that are not kernel bugs hinder automated testing efforts.

Signed-off-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucm.c            | 5 ++++-
 drivers/infiniband/core/ucma.c           | 5 ++++-
 drivers/infiniband/core/uverbs_main.c    | 5 ++++-
 drivers/infiniband/hw/qib/qib_file_ops.c | 5 ++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 7713ef0..0076b55 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1104,8 +1104,11 @@ static ssize_t ib_ucm_write(struct file *filp, const=
 char __user *buf,
 	struct ib_ucm_cmd_hdr hdr;
 	ssize_t result;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (len < sizeof(hdr))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 9520154..31fa27f 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const c=
har __user *buf,
 	struct rdma_ucm_cmd_hdr hdr;
 	ssize_t ret;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("ucma_write: process %d (%s) tried to do something hinky\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (len < sizeof(hdr))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/cor=
e/uverbs_main.c
index 44b1104..329eb15 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -746,8 +746,11 @@ static ssize_t ib_uverbs_write(struct file *filp, cons=
t char __user *buf,
 	int srcu_key;
 	ssize_t ret;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("uverbs_write: process %d (%s) tried to do something hinky\n=
",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (count < sizeof hdr)
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/=
hw/qib/qib_file_ops.c
index 382466a..b43ea52 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2066,8 +2066,11 @@ static ssize_t qib_write(struct file *fp, const char=
 __user *data,
 	ssize_t ret =3D 0;
 	void *dest;

-	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
+	if (!ib_safe_file_access(fp)) {
+		pr_err_once("qib_write: process %d (%s) tried to do something hinky\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (count < sizeof(cmd.type)) {
 		ret =3D -EINVAL;
--
2.7.4


--lMM8JwqTlfDpEaS6--

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYMt4RAAoJEORje4g2clin6bIP/R9ESvMBfxBB+ZWdehwe82gF
0GJV9v/fYfxrhlJNbe0Uco2VkqpmNNJuOri9kaQukysXU/E65+u3aKMMr9xpOiB6
v6K53oNDPSlu2ak+pW6RpiYsUvo9kHHlUlOQWqhLacweTqSCOgN7KUZQ9fywUdts
EftEel9SrL5jJW5vO8n0EyLsO2NEhjDqWSjYrmvDsuejfTu30PSvjFGIRUeDkBOV
ZIImENVZySfESmcnKELlX/JvXmjTuR14U8e3WkaiVgo3+CiiAjaCAyRL5h7rGHtK
dPuZFZ1XC9Xb0XGnyspn24gLNoXyjpHZjWNGHJouxGW00katxB8h3+az/OJMVBLe
cWfsggIpty5UVU2+9LT72ItZIMYblsljOCfl6/sY1bg7mVqDxDLYgvzLpg4yF0YQ
O4qO5yvqtiQu+3CDdzRr2dSegYKAOQn7qAGNw7HN7dwPxkdg7LOT9Qmek9d/GF0D
VufksGd8YWgSi7gZjwql8BkiAMgU3tXbyy8Ux3D4srcSpXLKu2aMQxW//1BM5TWp
1LHN3gNa0dPT7n0oDjCzomSQA/M/ArQssUwtdLUt2QecsbVUwvk5KS5csdndiO0s
+7hgRXXF1/HR64y338Ue7ysTEk8V+Z0lEp9Kym/R6hFj8fjk6AOJ0+T3Ibsic27r
Kcl4A3SSxTbeynwIOdaZ
=HS4M
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
