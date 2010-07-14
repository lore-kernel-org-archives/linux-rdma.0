From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib_qib: Allow writes to the diag_counters to be able to clear
 them
Date: Tue, 13 Jul 2010 18:50:59 -0700
Message-ID: <20100713185059.0f6fd030.weiny2@llnl.gov>
References: <20100707173313.675cd665.weiny2@llnl.gov>
	<AANLkTin_OHC8r__FDXPY6QhCaXDYgNFDY9SeE8ffdc35@mail.gmail.com>
	<20100708110446.97317098.weiny2@llnl.gov>
	<AANLkTik07Zp9uONyzBTAH4UnviviS-lopUJ42rZ5iQ_m@mail.gmail.com>
	<20100709175615.2e093989.weiny2@llnl.gov>
	<AANLkTik7MnJGL3Hlz1vqkmyruK7pRwyBWgKfTd0Lknpe@mail.gmail.com>
	<AANLkTil_p-lJmUGMzzPPj6Dx52jh_xbhN2Zt5uLZM53E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTil_p-lJmUGMzzPPj6Dx52jh_xbhN2Zt5uLZM53E-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 13 Jul 2010 03:31:09 -0700
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On Sat, Jul 10, 2010 at 5:25 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>=
 wrote:
> >
> > On Sat, Jul 10, 2010 at 2:56 AM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> > >
> > > On Fri, 9 Jul 2010 12:33:14 -0700
> > > Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> > >
> > > > On Thu, Jul 8, 2010 at 8:04 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wro=
te:
> > > > >
> > > > > On Thu, 8 Jul 2010 10:37:26 -0700
> > > > > Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> > > > >
> > > > > > On Thu, Jul 8, 2010 at 2:33 AM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>=
 wrote:
> > > > > > > From 80eecc4046455999254fb312c4ba229b3a52d4c6 Mon Sep 17 =
00:00:00 2001
> > > > > > > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > > > > Date: Wed, 7 Jul 2010 17:35:34 -0700
> > > > > > > Subject: [PATCH] ib_qib: Allow writes to the diag_counter=
s to be able to clear them
> > > > > > >
> > > > > > >
> > > > > > > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > > > > ---
> > > > > > > =A0drivers/infiniband/hw/qib/qib_sysfs.c | =A0 16 +++++++=
++++++++-
> > > > > > > =A01 files changed, 15 insertions(+), 1 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/driv=
ers/infiniband/hw/qib/qib_sysfs.c
> > > > > > > index dab4d9f..91cd1b8 100644
> > > > > > > --- a/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > > > > +++ b/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > > > > @@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_kty=
pe =3D {
> > > > > > >
> > > > > > > =A0#define QIB_DIAGC_ATTR(N) \
> > > > > > > =A0 =A0 =A0 =A0static struct qib_diagc_attr qib_diagc_att=
r_##N =3D { \
> > > > > > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __str=
ingify(N), .mode =3D 0444 }, \
> > > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __str=
ingify(N), .mode =3D 0664 }, \
> > > > > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.counter =3D offsetof(stru=
ct qib_ibport, n_##N) \
> > > > > > > =A0 =A0 =A0 =A0}
> > > > > > >
> > > > > > > @@ -403,8 +403,22 @@ static ssize_t diagc_attr_show(struc=
t kobject *kobj, struct attribute *attr,
> > > > > > > =A0 =A0 =A0 =A0return sprintf(buf, "%u\n", *(u32 *)((char=
 *)qibp + dattr->counter));
> > > > > > > =A0}
> > > > > > >
> > > > > > > +static ssize_t diagc_attr_store(struct kobject *kobj, st=
ruct attribute *attr,
> > > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 const char *buf, size_t size)
> > > > > > > +{
> > > > > > > + =A0 =A0 =A0 struct qib_diagc_attr *dattr =3D
> > > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(attr, struct q=
ib_diagc_attr, attr);
> > > > > > > + =A0 =A0 =A0 struct qib_pportdata *ppd =3D
> > > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(kobj, struct q=
ib_pportdata, diagc_kobj);
> > > > > > > + =A0 =A0 =A0 struct qib_ibport *qibp =3D &ppd->ibport_da=
ta;
> > > > > > > +
> > > > > > > + =A0 =A0 =A0 *(u32 *)((char *)qibp + dattr->counter) =3D=
 simple_strtol(buf, NULL, 0);
> > > > > > > + =A0 =A0 =A0 return 4;
> > > > > >
> > > > > > The above line is not correct -- it should probably be some=
thing like
> > > > > > "return size;". See also
> > > > > > http://***git.kernel.org/?p=3Dlinux/kernel/git/torvalds/lin=
ux-2.6.git;a=3Dblob;f=3DDocumentation/filesystems/sysfs.txt.
> > > > >
> > > > > My mistake. =A0From the document above the return should be:
> > > > >
> > > > > return strnlen(buf, PAGE_SIZE);
> > > > >
> > > > > Correct?
> > > > >
> > > > > Also I think I should check for invalid values as well.
> > > >
> > > > (resending as plain text)
> > > >
> > > > The documented I referred to was written before the "size" argu=
ment
> > > > was added to sysfs store methods.
> > >
> > > Are you sure? =A0The document's signature for store methods inclu=
des the size
> > > argument?
> > >
> > > > I'm not sure it is still required
> > > > that the "buf" argument that is passed to store methods is
> > > > '\0'-terminated. So both "return 4" and "return strnlen(buf,
> > > > PAGE_SIZE)" can potentially return a value that is larger than =
the
> > > > "size" argument, which I think is incorrect.
> > > >
> > > > Sorry that I pointed you to misleading documentation.
> > >
> > > Also, the document is the same as the one in Roland's latest mast=
er. =A0Is the
> > > document wrong? =A0I have not found anything newer (22 February 2=
009).
> >
> > Let's ask the experts. The feedback on the sysfs documentation patc=
h
> > that I just submitted will tell us whether or not the sysfs
> > documentation is correct (http://*lkml.org/lkml/2010/7/10/72).
>=20
> I have just received a private e-mail that informed me that Andrew
> Morton was so kind to sign off that sysfs documentation patch and to
> add it to his -mm tree. So if nobody complains about that patch withi=
n
> the next few days, that patch will be integrated in a future version
> of the Linux kernel.

Sorry, I see where my mistake was.  Some of the store methods did have =
a count parameter and others (more importantly the sysfs_ops structure)=
 did not.  :-)

I will send out V3 shortly.  There was one more place the count paramet=
er was missing:

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesy=
stems/sysfs.txt
index d78ed0b..c853eee 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -333,7 +333,7 @@ Structure:
 struct bus_attribute {
         struct attribute        attr;
         ssize_t (*show)(struct bus_type *, char * buf);
-        ssize_t (*store)(struct bus_type *, const char * buf);
+        ssize_t (*store)(struct bus_type *, const char * buf, size_t c=
ount);
 };
=20
 Declaring:


I can send a patch if you like.

Thanks for the help,
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
