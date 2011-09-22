From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 20:20:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E67532@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > =A0libibnetdisc/src/ibnetdisc.c | =A0 =A02 +-
> > =A0src/ibportstate.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++--
> > =A02 files changed, 3 insertions(+), 3 deletions(-)
> > =A0mode change 100644 =3D> 100755 libibnetdisc/src/ibnetdisc.c
> > =A0mode change 100644 =3D> 100755 src/ibportstate.c
>=20
> A minor nit: is this mode change really necessary ? (I know Visual
> Studio does enable the execute bit without asking.)

No - these mode changes should not be there.  I removed them further do=
wn in the patch, but missed it here.  I modified the files using Eclips=
e from a Windows system.  Maybe there's some setting that I missed.

Ira, please let me know if you want me to generate a new patch.

> Has it been considered to disable the MSVC warnings about possible
> truncation instead of inserting a cast ? MSVC generates such warnings
> while gcc does not.

The entire windows tree is built using the WinDDK compiler.  I haven't =
found a way to disable that warning that works.  Since the warning is r=
eal, an explicit cast at least lets someone reading the code know that =
the author took truncation into account.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
