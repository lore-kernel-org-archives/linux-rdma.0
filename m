From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: ib_qib: Allow writes to the diag_counters to be able to clear
	them
Date: Tue, 13 Jul 2010 12:31:09 +0200
Message-ID: <AANLkTil_p-lJmUGMzzPPj6Dx52jh_xbhN2Zt5uLZM53E@mail.gmail.com>
References: <20100707173313.675cd665.weiny2@llnl.gov>
	<AANLkTin_OHC8r__FDXPY6QhCaXDYgNFDY9SeE8ffdc35@mail.gmail.com>
	<20100708110446.97317098.weiny2@llnl.gov>
	<AANLkTik07Zp9uONyzBTAH4UnviviS-lopUJ42rZ5iQ_m@mail.gmail.com>
	<20100709175615.2e093989.weiny2@llnl.gov>
	<AANLkTik7MnJGL3Hlz1vqkmyruK7pRwyBWgKfTd0Lknpe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik7MnJGL3Hlz1vqkmyruK7pRwyBWgKfTd0Lknpe-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 10, 2010 at 5:25 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> w=
rote:
>
> On Sat, Jul 10, 2010 at 2:56 AM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> >
> > On Fri, 9 Jul 2010 12:33:14 -0700
> > Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> >
> > > On Thu, Jul 8, 2010 at 8:04 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote=
:
> > > >
> > > > On Thu, 8 Jul 2010 10:37:26 -0700
> > > > Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> > > >
> > > > > On Thu, Jul 8, 2010 at 2:33 AM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> w=
rote:
> > > > > > From 80eecc4046455999254fb312c4ba229b3a52d4c6 Mon Sep 17 00=
:00:00 2001
> > > > > > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > > > Date: Wed, 7 Jul 2010 17:35:34 -0700
> > > > > > Subject: [PATCH] ib_qib: Allow writes to the diag_counters =
to be able to clear them
> > > > > >
> > > > > >
> > > > > > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > > > > ---
> > > > > > =A0drivers/infiniband/hw/qib/qib_sysfs.c | =A0 16 +++++++++=
++++++-
> > > > > > =A01 files changed, 15 insertions(+), 1 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/driver=
s/infiniband/hw/qib/qib_sysfs.c
> > > > > > index dab4d9f..91cd1b8 100644
> > > > > > --- a/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > > > +++ b/drivers/infiniband/hw/qib/qib_sysfs.c
> > > > > > @@ -347,7 +347,7 @@ static struct kobj_type qib_sl2vl_ktype=
 =3D {
> > > > > >
> > > > > > =A0#define QIB_DIAGC_ATTR(N) \
> > > > > > =A0 =A0 =A0 =A0static struct qib_diagc_attr qib_diagc_attr_=
##N =3D { \
> > > > > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __strin=
gify(N), .mode =3D 0444 }, \
> > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .attr =3D { .name =3D __strin=
gify(N), .mode =3D 0664 }, \
> > > > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.counter =3D offsetof(struct=
 qib_ibport, n_##N) \
> > > > > > =A0 =A0 =A0 =A0}
> > > > > >
> > > > > > @@ -403,8 +403,22 @@ static ssize_t diagc_attr_show(struct =
kobject *kobj, struct attribute *attr,
> > > > > > =A0 =A0 =A0 =A0return sprintf(buf, "%u\n", *(u32 *)((char *=
)qibp + dattr->counter));
> > > > > > =A0}
> > > > > >
> > > > > > +static ssize_t diagc_attr_store(struct kobject *kobj, stru=
ct attribute *attr,
> > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const char *buf, size_t size)
> > > > > > +{
> > > > > > + =A0 =A0 =A0 struct qib_diagc_attr *dattr =3D
> > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(attr, struct qib=
_diagc_attr, attr);
> > > > > > + =A0 =A0 =A0 struct qib_pportdata *ppd =3D
> > > > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 container_of(kobj, struct qib=
_pportdata, diagc_kobj);
> > > > > > + =A0 =A0 =A0 struct qib_ibport *qibp =3D &ppd->ibport_data=
;
> > > > > > +
> > > > > > + =A0 =A0 =A0 *(u32 *)((char *)qibp + dattr->counter) =3D s=
imple_strtol(buf, NULL, 0);
> > > > > > + =A0 =A0 =A0 return 4;
> > > > >
> > > > > The above line is not correct -- it should probably be someth=
ing like
> > > > > "return size;". See also
> > > > > http://**git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-=
2.6.git;a=3Dblob;f=3DDocumentation/filesystems/sysfs.txt.
> > > >
> > > > My mistake. =A0From the document above the return should be:
> > > >
> > > > return strnlen(buf, PAGE_SIZE);
> > > >
> > > > Correct?
> > > >
> > > > Also I think I should check for invalid values as well.
> > >
> > > (resending as plain text)
> > >
> > > The documented I referred to was written before the "size" argume=
nt
> > > was added to sysfs store methods.
> >
> > Are you sure? =A0The document's signature for store methods include=
s the size
> > argument?
> >
> > > I'm not sure it is still required
> > > that the "buf" argument that is passed to store methods is
> > > '\0'-terminated. So both "return 4" and "return strnlen(buf,
> > > PAGE_SIZE)" can potentially return a value that is larger than th=
e
> > > "size" argument, which I think is incorrect.
> > >
> > > Sorry that I pointed you to misleading documentation.
> >
> > Also, the document is the same as the one in Roland's latest master=
=2E =A0Is the
> > document wrong? =A0I have not found anything newer (22 February 200=
9).
>
> Let's ask the experts. The feedback on the sysfs documentation patch
> that I just submitted will tell us whether or not the sysfs
> documentation is correct (http://lkml.org/lkml/2010/7/10/72).

I have just received a private e-mail that informed me that Andrew
Morton was so kind to sign off that sysfs documentation patch and to
add it to his -mm tree. So if nobody complains about that patch within
the next few days, that patch will be integrated in a future version
of the Linux kernel.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
