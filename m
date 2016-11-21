From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 19:38:20 +0200
Message-ID: <20161121173820.GC23083@leon.nu>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
 <20161121121408.GC4158@leon.nu>
 <20161121165253.GA22237@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161121165253.GA22237-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: multipart/mixed; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2016 at 09:52:53AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 21, 2016 at 02:14:08PM +0200, Leon Romanovsky wrote:
> > >
> > > In ib_ucm_write function there is a wrong prefix:
> > >
> > > + pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",
> >
> > I did it intentionally to have the same errors for all flows.
>
> Lets actually use a good message too please?
>
>  pr_err_once("ucm_write: process %d (%s) changed security contexts after opening FD, this is not allowed.\n",
>
> Jason

--OROCMA9jn6tkzFBc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-IB-core-qib-Remove-WARN-that-is-not-kernel-bug.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 70f95b2d35aea42e5b97e7d27ab2f4e8effcbe67 Mon Sep 17 00:00:00 2001
=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 21 Nov 2016 13:30:59 +0200
Subject: [PATCH rdma-next V2] IB/{core, qib}: Remove WARN that is not kerne=
l bug

WARNINGs mean kernel bugs, in this case, they are placed
to mark programming errors and/or malicious attempts.

BUG/WARNs that are not kernel bugs hinder automated testing efforts.

Signed-off-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
 * Improved error prints.
---
 drivers/infiniband/core/ucm.c            | 5 ++++-
 drivers/infiniband/core/ucma.c           | 5 ++++-
 drivers/infiniband/core/uverbs_main.c    | 5 ++++-
 drivers/infiniband/hw/qib/qib_file_ops.c | 5 ++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 7713ef0..579f9a7 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1104,8 +1104,11 @@ static ssize_t ib_ucm_write(struct file *filp, const=
 char __user *buf,
 	struct ib_ucm_cmd_hdr hdr;
 	ssize_t result;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("ucm_write: process %d (%s) changed security contexts after =
opening file descriptor, this is not allowed.\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (len < sizeof(hdr))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 9520154..e12f8fa 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const c=
har __user *buf,
 	struct rdma_ucm_cmd_hdr hdr;
 	ssize_t ret;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("ucma_write: process %d (%s) changed security contexts after=
 opening file descriptor, this is not allowed.\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (len < sizeof(hdr))
 		return -EINVAL;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/cor=
e/uverbs_main.c
index 44b1104..38c79ad 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -746,8 +746,11 @@ static ssize_t ib_uverbs_write(struct file *filp, cons=
t char __user *buf,
 	int srcu_key;
 	ssize_t ret;

-	if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
+	if (!ib_safe_file_access(filp)) {
+		pr_err_once("uverbs_write: process %d (%s) changed security contexts aft=
er opening file descriptor, this is not allowed.\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (count < sizeof hdr)
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/=
hw/qib/qib_file_ops.c
index 382466a..2d1eacf 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -2066,8 +2066,11 @@ static ssize_t qib_write(struct file *fp, const char=
 __user *data,
 	ssize_t ret =3D 0;
 	void *dest;

-	if (WARN_ON_ONCE(!ib_safe_file_access(fp)))
+	if (!ib_safe_file_access(fp)) {
+		pr_err_once("qib_write: process %d (%s) changed security contexts after =
opening file descriptor, this is not allowed.\n",
+			    task_tgid_vnr(current), current->comm);
 		return -EACCES;
+	}

 	if (count < sizeof(cmd.type)) {
 		ret =3D -EINVAL;
--
2.7.4


--OROCMA9jn6tkzFBc--

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYMzEMAAoJEORje4g2cliniLUP/0FKqEBgjWKbYt5tw6q2KRyD
A2hq0U8JKEk+0hUEDWDpx61HKtExZQ9x66feyjvOZ8F7XEEaFIy55xGWxcwvXjPG
XFoJt2zO2rmJeEDeGvk8G3JbDLXPd0ajcvepwdrzZR/DTMc9bgxGDATTHgFRMMeh
NcTjFCDUeHqwnNxKPpij1p/c3WODbuYMk0kGe0sAsmd1sCJD75+FiA/YMkClWJWY
jkuRpCXqQ7fsyPvnXaH02deZ/nv3dW75+8eMhBYD9jAMXKiyEHmNVMvddMwkjDKy
VvEWhI2H+Wawd6Sin40ygOp2ahZxmATG4dmvJc1oq7K5Vlg0wEKv/kkKiM0o+jCX
me8nFILzu8u9p5JX4/W94sYT7QElvWWeV0AH5rHOVFJxXYsox6PdNvzIk8eERL6d
zqt1vyJ/YbveZow7tp4Kbvg2YDaPAzZwKWGEkWO9knqAcBtUqjIZ3aHP2U4G9DSS
TIIX2LNJPd5n4PE4nSuOYf+JRNdLtAb/guunFH7iAWLPaEwtTVhHXgZBg1kcfETY
xoTsPs46CK2rTaDy+Gw78L8U/nkp6fg1eu75rBs3M7USmT3kbBNgaX3UiS57ijPD
colRk6fLOawIbbP85eXCZiwgKnoH6v14dyt91a9GqX3YB1fn170p44L6k6vWJ2SM
LPHkttbjrhmtXmmISgEY
=QCES
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
