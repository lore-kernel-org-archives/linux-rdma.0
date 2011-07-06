From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH] umad.c: memset() ib_user_mad_reg_req structure to
 0before invoking ioctl()
Date: Wed, 6 Jul 2011 09:08:37 +0200
Message-ID: <20110706090837.617de660@b012350-ux>
References: <20110704115314.7c15c6ac@b012350-ux>
	<CAO+b5-pKPdJC20s7dL18b97fd778GoT4TJ_J13NwbkEFz6bz4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pKPdJC20s7dL18b97fd778GoT4TJ_J13NwbkEFz6bz4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 5 Jul 2011 20:17:18 +0200
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> On Mon, Jul 4, 2011 at 11:53 AM, sebastien dugue
> <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> >
> > This fixes the following warning issued by valgrind:
> >
> > =3D=3D5287=3D=3D Syscall param ioctl(generic) points to uninitialis=
ed byte(s)
> > =3D=3D5287=3D=3D =C2=A0 =C2=A0at 0x3C466D95D7: ioctl (in /lib64/lib=
c-2.12.so)
> > =3D=3D5287=3D=3D =C2=A0 =C2=A0by 0x526C292: umad_register (umad.c:9=
47)
> > =3D=3D5287=3D=3D =C2=A0 =C2=A0by 0x568D206: smp_engine_init (query_=
smp.c:228)
> > =3D=3D5287=3D=3D =C2=A0 =C2=A0by 0x5689F8F: ibnd_discover_fabric (i=
bnetdisc.c:537)
> > =3D=3D5287=3D=3D =C2=A0 =C2=A0by 0x411700: devmgr_discover_fabric (=
devmgr_discover.c:66)
> >
> > Signed-off-by: Jean-Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
> >
> > ---
> >
> > diff --git a/src/umad.c b/src/umad.c
> > index 45a9423..cac46a4 100644
> > --- a/src/umad.c
> > +++ b/src/umad.c
> > @@ -892,6 +892,7 @@ int umad_register_oui(int fd, int mgmt_class, u=
int8_t rmpp_version,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > + =C2=A0 =C2=A0 =C2=A0 memset(&req, 0, sizeof(req));
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.qpn =3D 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.mgmt_class =3D mgmt_class;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.mgmt_class_version =3D 1;
> > @@ -928,6 +929,7 @@ int umad_register(int fd, int mgmt_class, int m=
gmt_version,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0("fd %d mgmt_class %u mgmt=
_version %u rmpp_version %d method_mask %p",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fd, mgmt_class, mgmt_vers=
ion, rmpp_version, method_mask);
> >
> > + =C2=A0 =C2=A0 =C2=A0 memset(&req, 0, sizeof(req));
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.qpn =3D qp =3D (mgmt_class =3D=3D 0x=
1 || mgmt_class =3D=3D 0x81) ? 0 : 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.mgmt_class =3D mgmt_class;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0req.mgmt_class_version =3D mgmt_version;
>=20
> A possible alternative approach is to develop a patch for Valgrind
> that makes Valgrind ignore padding fields and/or output fields in the
> pre-ioctl check. See also PRE(sys_ioctl) in source file
> coregrind/m_syswrap/syswrap-linux.c or the documentation file
> README_MISSING_SYSCALL_OR_IOCTL.

  Could be, but this is largely out of scope for me and I can live
with the warning knowing it's a false positive.

  Thanks,

  S=C3=A9bastien.

>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
