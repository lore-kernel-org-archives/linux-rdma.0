From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/qib: fix powerpc compile warnings
Date: Wed, 26 May 2010 13:15:47 -0700
Message-ID: <ada8w76xvv0.fsf@roland-alpha.cisco.com>
References: <20100526184205.11285.79404.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100526184205.11285.79404.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Wed, 26 May 2010 11:42:06 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Fix the compile warnings for uninitialized variables in qib_fs.c
 > when compiling for powerpc.

 > -	u64 *counters;
 > +	u64 *counters =3D NULL;

I do not believe this is the correct fix.  The problem is the code like=
:

	return simple_read_from_buffer(buf, count, ppos, counters,
		dd->f_read_cntrs(dd, *ppos, NULL, &counters));

which passes the pointer counters as a parameter to simple_read_from_bu=
ffer()
but relies on the call to dd->f_read_cntrs() to initialize the paramete=
r.
However the order of evaluation of function parameters is undefined in =
C.
So just initializing counters to NULL as you do means that you might be
passing in NULL instead of an uninitialized value -- not much improveme=
nt.

The reason this code works for you I think is that gcc on x86 evaluates
function parameters from right to left, and apparently powerpc does the
opposite (hence the warning).  You can see that by compiling the code
below -- with gcc -O2 -Wall, I see:

    a.c: In function =E2=80=98b=E2=80=99:
    a.c:14: warning: =E2=80=98ap=E2=80=99 is used uninitialized in this=
 function

so the warning comes from the particular order:

	extern int x(int **xp);
	extern int y(int *yp, int ypp);
	extern int z(int zpp, int *zp);
=09
	int a(void)
	{
		int *ap;
		return y(ap, x(&ap));
	}
=09
	int b(void)
	{
		int *ap;
		return z(x(&ap), ap);
	}

So I think the correct fix (which I queued up) is the following:

commit f27ec1d6db4aa3348ca7be896f1466599aecea3e
Author: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Date:   Wed May 26 13:15:06 2010 -0700

    IB/qib: Don't rely on (undefined) order of function parameter evalu=
ation
   =20
    Some of the qib sysfs code passes a buffer pointer into
    simple_read_from_buffer() but relies on a function call in another
    parameter of the same call to initialize that pointer.  Since the o=
rder
    of evaluation of function parameters is undefined, this will break =
if
    gcc chooses the wrong order.
   =20
    Fix this by splitting the code into two separate function calls.
   =20
    This was noticed because of warnings like the following on ppc:
   =20
        drivers/infiniband/hw/qib/qib_fs.c: In function 'portcntrs_2_re=
ad':
        drivers/infiniband/hw/qib/qib_fs.c:203: warning: 'counters' is =
used uninitialized in this function
   =20
    Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw=
/qib/qib_fs.c
index 7554704..edef852 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -144,10 +144,11 @@ static ssize_t dev_counters_read(struct file *fil=
e, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	u64 *counters;
+	size_t avail;
 	struct qib_devdata *dd =3D private2dd(file);
=20
-	return simple_read_from_buffer(buf, count, ppos, counters,
-		dd->f_read_cntrs(dd, *ppos, NULL, &counters));
+	avail =3D dd->f_read_cntrs(dd, *ppos, NULL, &counters);
+	return simple_read_from_buffer(buf, count, ppos, counters, avail);
 }
=20
 /* read the per-device counters */
@@ -155,10 +156,11 @@ static ssize_t dev_names_read(struct file *file, =
char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	char *names;
+	size_t avail;
 	struct qib_devdata *dd =3D private2dd(file);
=20
-	return simple_read_from_buffer(buf, count, ppos, names,
-		dd->f_read_cntrs(dd, *ppos, &names, NULL));
+	avail =3D dd->f_read_cntrs(dd, *ppos, &names, NULL);
+	return simple_read_from_buffer(buf, count, ppos, names, avail);
 }
=20
 static const struct file_operations cntr_ops[] =3D {
@@ -176,10 +178,11 @@ static ssize_t portnames_read(struct file *file, =
char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	char *names;
+	size_t avail;
 	struct qib_devdata *dd =3D private2dd(file);
=20
-	return simple_read_from_buffer(buf, count, ppos, names,
-		dd->f_read_portcntrs(dd, *ppos, 0, &names, NULL));
+	avail =3D dd->f_read_portcntrs(dd, *ppos, 0, &names, NULL);
+	return simple_read_from_buffer(buf, count, ppos, names, avail);
 }
=20
 /* read the per-port counters for port 1 (pidx 0) */
@@ -187,10 +190,11 @@ static ssize_t portcntrs_1_read(struct file *file=
, char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	u64 *counters;
+	size_t avail;
 	struct qib_devdata *dd =3D private2dd(file);
=20
-	return simple_read_from_buffer(buf, count, ppos, counters,
-		dd->f_read_portcntrs(dd, *ppos, 0, NULL, &counters));
+	avail =3D dd->f_read_portcntrs(dd, *ppos, 0, NULL, &counters);
+	return simple_read_from_buffer(buf, count, ppos, counters, avail);
 }
=20
 /* read the per-port counters for port 2 (pidx 1) */
@@ -198,10 +202,11 @@ static ssize_t portcntrs_2_read(struct file *file=
, char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	u64 *counters;
+	size_t avail;
 	struct qib_devdata *dd =3D private2dd(file);
=20
-	return simple_read_from_buffer(buf, count, ppos, counters,
-		dd->f_read_portcntrs(dd, *ppos, 1, NULL, &counters));
+	avail =3D dd->f_read_portcntrs(dd, *ppos, 1, NULL, &counters);
+	return simple_read_from_buffer(buf, count, ppos, counters, avail);
 }
=20
 static const struct file_operations portcntr_ops[] =3D {

--=20
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go=
 to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
