From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/17] IB/core: Add support for extended query device
 caps
Date: Wed, 10 Dec 2014 13:59:27 +0100
Message-ID: <1418216367.11111.40.camel@opteya.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
	 <1415723783-2138-7-git-send-email-haggaie@mellanox.com>
	 <CAL1RGDXsYmWD2_ncMmRrMgAGn1bBaL9tNQ2mAYDG-kySF4037A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXsYmWD2_ncMmRrMgAGn1bBaL9tNQ2mAYDG-kySF4037A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le mardi 09 d=C3=A9cembre 2014 =C3=A0 13:43 -0800, Roland Dreier a =C3=A9=
crit :
> I was getting ready to apply the ODP series, but then I noticed:
>=20
> On Tue, Nov 11, 2014 at 8:36 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
> > diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infini=
band/core/uverbs_main.c
> > index 71ab83fde472..974025028790 100644
> > --- a/drivers/infiniband/core/uverbs_main.c
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -122,7 +122,8 @@ static int (*uverbs_ex_cmd_table[])(struct ib_u=
verbs_file *file,
> >                                     struct ib_udata *ucore,
> >                                     struct ib_udata *uhw) =3D {
> >         [IB_USER_VERBS_EX_CMD_CREATE_FLOW]      =3D ib_uverbs_ex_cr=
eate_flow,
> > -       [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     =3D ib_uverbs_ex_de=
stroy_flow
> > +       [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     =3D ib_uverbs_ex_de=
stroy_flow,
> > +       [IB_USER_VERBS_EX_CMD_QUERY_DEVICE]     =3D ib_uverbs_ex_qu=
ery_device
> >  };
> >
> >  static void ib_uverbs_add_one(struct ib_device *device);
>=20
> > diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/=
ib_user_verbs.h
> > index 26daf55ff76e..ed8c3d9da42c 100644
> > --- a/include/uapi/rdma/ib_user_verbs.h
> > +++ b/include/uapi/rdma/ib_user_verbs.h
> > @@ -90,8 +90,9 @@ enum {
> >  };
> >
> >  enum {
> > +       IB_USER_VERBS_EX_CMD_QUERY_DEVICE =3D IB_USER_VERBS_CMD_QUE=
RY_DEVICE,
> >         IB_USER_VERBS_EX_CMD_CREATE_FLOW =3D IB_USER_VERBS_CMD_THRE=
SHOLD,
> > -       IB_USER_VERBS_EX_CMD_DESTROY_FLOW
> > +       IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
> >  };
>=20
> And this makes no sense to me.  I thought the whole point of "EX"
> commands was to add then after IB_USER_VERBS_CMD_THRESHOLD.
>=20
> In this case, if you make IB_USER_VERBS_EX_CMD_QUERY_DEVICE =3D
> IB_USER_VERBS_CMD_QUERY_DEVICE then doesn't the entry in
> uverbs_cmd_table[] for normal query device get overwritten with
> ib_uverbs_ex_query_device()??
>=20

IB_USER_VERBS_CMD_THRESHOLD was introduced as part of commit
400dbc96583f ('IB/core: Infrastructure for extensible uverbs commands')=
=2E

When I've 'upgraded' it to more extensible scheme, in commit
f21519b23c1b ('IB/core: extended command: an improved infrastructure=20
for uverbs commands'), I've put the extended commands in a different=20
namespace, with the idea we could later convert non-extended commands=20
to extended ones and phase out the older ABI in the future.

I seems that what I've envisioned is starting to happen.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
