From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH] umad.c: memset() ib_user_mad_reg_req structure to 0
 beforeinvoking ioctl()
Date: Tue, 5 Jul 2011 17:11:08 +0200
Message-ID: <20110705171108.6ab4237d@b012350-ux>
References: <20110704115314.7c15c6ac@b012350-ux>
	<4E12F85D.4010801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E12F85D.4010801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 05 Jul 2011 07:41:17 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 7/4/2011 5:53 AM, sebastien dugue wrote:
> >=20
> > This fixes the following warning issued by valgrind:
> >=20
> > =3D=3D5287=3D=3D Syscall param ioctl(generic) points to uninitialis=
ed byte(s)
> > =3D=3D5287=3D=3D    at 0x3C466D95D7: ioctl (in /lib64/libc-2.12.so)
> > =3D=3D5287=3D=3D    by 0x526C292: umad_register (umad.c:947)
> > =3D=3D5287=3D=3D    by 0x568D206: smp_engine_init (query_smp.c:228)
> > =3D=3D5287=3D=3D    by 0x5689F8F: ibnd_discover_fabric (ibnetdisc.c=
:537)
> > =3D=3D5287=3D=3D    by 0x411700: devmgr_discover_fabric (devmgr_dis=
cover.c:66)
> >=20
> > Signed-off-by: Jean-Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
> >=20
> > ---
> >=20
> > diff --git a/src/umad.c b/src/umad.c
> > index 45a9423..cac46a4 100644
> > --- a/src/umad.c
> > +++ b/src/umad.c
> > @@ -892,6 +892,7 @@ int umad_register_oui(int fd, int mgmt_class, u=
int8_t rmpp_version,
> >  		return -EINVAL;
> >  	}
> > =20
> > +	memset(&req, 0, sizeof(req));
> >  	req.qpn =3D 1;
> >  	req.mgmt_class =3D mgmt_class;
> >  	req.mgmt_class_version =3D 1;
> > @@ -928,6 +929,7 @@ int umad_register(int fd, int mgmt_class, int m=
gmt_version,
> >  	    ("fd %d mgmt_class %u mgmt_version %u rmpp_version %d method_=
mask %p",
> >  	     fd, mgmt_class, mgmt_version, rmpp_version, method_mask);
> > =20
> > +	memset(&req, 0, sizeof(req));
> >  	req.qpn =3D qp =3D (mgmt_class =3D=3D 0x1 || mgmt_class =3D=3D 0x=
81) ? 0 : 1;
> >  	req.mgmt_class =3D mgmt_class;
> >  	req.mgmt_class_version =3D mgmt_version;
>=20
> I think this is a "false positive" in valgrind. memset of the request
> isn't really needed for either of these APIs as all input fields are
> filled in by the caller and the only one which isn't is id which is a=
n
> output field.

  Ok then, it's no needed.

  Thanks,

  S=C3=A9bastien.

>=20
> -- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
