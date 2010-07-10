From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib_qib: Allow writes to the diag_counters to be able to clear
 them
Date: Fri, 9 Jul 2010 17:56:15 -0700
Message-ID: <20100709175615.2e093989.weiny2@llnl.gov>
References: <20100707173313.675cd665.weiny2@llnl.gov>
	<AANLkTin_OHC8r__FDXPY6QhCaXDYgNFDY9SeE8ffdc35@mail.gmail.com>
	<20100708110446.97317098.weiny2@llnl.gov>
	<AANLkTik07Zp9uONyzBTAH4UnviviS-lopUJ42rZ5iQ_m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik07Zp9uONyzBTAH4UnviviS-lopUJ42rZ5iQ_m-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 9 Jul 2010 12:33:14 -0700
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On Thu, Jul 8, 2010 at 8:04 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> >
> > On Thu, 8 Jul 2010 10:37:26 -0700
> > Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> >
> > > On Thu, Jul 8, 2010 at 2:33 AM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote=
:
> > > > From 80eecc4046455999254fb312c4ba229b3a52d4c6 Mon Sep 17 00:00:=
00 2001
> > > > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > Date: Wed, 7 Jul 2010 17:35:34 -0700
> > > > Subject: [PATCH] ib_qib: Allow writes to the diag_counters to b=
e able to clear them
> > > >
> > > >
> > > > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > ---
> > > > =A0drivers/infiniband/hw/qib/qib_sysfs.c | =A0 16 +++++++++++++=
++-
> > > > =A01 files changed, 15 insertions(+), 1 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/in=
finiband/hw/qib/qib_sysfs.c
> > > > index dab4d9f..91cd1b8 100644
> > > > --- a/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > +++ b/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > @@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_ktype =3D=
 {
> > > >
> > > > =A0#define QIB_DIAGC_ATTR(N) \
> > > > =A0 =A0 =A0 =A0static struct qib_diagc_attr qib_diagc_attr_##N =
=3D { \
> > > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __stringify=
(N), .mode =3D 0444 }, \
> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __stringify=
(N), .mode =3D 0664 }, \
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.counter =3D offsetof(struct qib=
_ibport, n_##N) \
> > > > =A0 =A0 =A0 =A0}
> > > >
> > > > @@ -403,8 +403,22 @@ static ssize_t diagc_attr_show(struct kobj=
ect *kobj, struct attribute *attr,
> > > > =A0 =A0 =A0 =A0return sprintf(buf, "%u\n", *(u32 *)((char *)qib=
p + dattr->counter));
> > > > =A0}
> > > >
> > > > +static ssize_t diagc_attr_store(struct kobject *kobj, struct a=
ttribute *attr,
> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 c=
onst char *buf, size_t size)
> > > > +{
> > > > + =A0 =A0 =A0 struct qib_diagc_attr *dattr =3D
> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(attr, struct qib_dia=
gc_attr, attr);
> > > > + =A0 =A0 =A0 struct qib_pportdata *ppd =3D
> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(kobj, struct qib_ppo=
rtdata, diagc_kobj);
> > > > + =A0 =A0 =A0 struct qib_ibport *qibp =3D &ppd->ibport_data;
> > > > +
> > > > + =A0 =A0 =A0 *(u32 *)((char *)qibp + dattr->counter) =3D simpl=
e_strtol(buf, NULL, 0);
> > > > + =A0 =A0 =A0 return 4;
> > >
> > > The above line is not correct -- it should probably be something =
like
> > > "return size;". See also
> > > http://**git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.=
git;a=3Dblob;f=3DDocumentation/filesystems/sysfs.txt.
> >
> > My mistake. =A0From the document above the return should be:
> >
> > return strnlen(buf, PAGE_SIZE);
> >
> > Correct?
> >
> > Also I think I should check for invalid values as well.
>=20
> (resending as plain text)
>=20
> The documented I referred to was written before the "size" argument
> was added to sysfs store methods.

Are you sure?  The document's signature for store methods includes the =
size
argument?

> I'm not sure it is still required
> that the "buf" argument that is passed to store methods is
> '\0'-terminated. So both "return 4" and "return strnlen(buf,
> PAGE_SIZE)" can potentially return a value that is larger than the
> "size" argument, which I think is incorrect.
>=20
> Sorry that I pointed you to misleading documentation.

Also, the document is the same as the one in Roland's latest master.  I=
s the
document wrong?  I have not found anything newer (22 February 2009).

Ira

>=20
> Bart.
>=20



--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
