From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 3/5] IB/core: Call
 ib_unregister_mad_agent() only for valid agents
Date: Tue, 17 Feb 2015 14:59:56 +0100
Message-ID: <1424181596.32606.43.camel@opteya.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
	 <1423137232-24587-4-git-send-email-ogerlitz@mellanox.com>
	 <1424122092.32606.36.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424122092.32606.36.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, MikeMarciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 16 f=C3=A9vrier 2015 =C3=A0 22:28 +0100, Yann Droneaud a =C3=A9=
crit :
> Le jeudi 05 f=C3=A9vrier 2015 =C3=A0 13:53 +0200, Or Gerlitz a =C3=A9=
crit :
> > From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > In some error flows, ib_mad_unregister_agent is being invoked also =
in cases where
>                       ^^^^^^^^^^^^^^^^^^^^^^^
>                       ib_unregister_mad_agent()
>=20
> > the ib_mad_register_agent call failed (resulting in an illegal poin=
ter in the
>      ^^^^^^^^^^^^^^^^^^^^^
>      ib_register_mad_agent()
>=20
> > agent field).  This causes a kernel crash in the error flow.
> >=20
> > Fix this by calling ib_unregister_mad_agent only for cases where
> > ib_register_mad_agent succeeded.
> >=20
>=20
> The code was checking for struct ib_mad_agent *agent not being NULL,=20
> while ib_register_mad_agent() returns a ERR_PTR() in case of error
> ... bad :(
>=20

After reading Jason's comments [1], I don't understand the purpose of
this patch. How can an ERR_PTR() value be present in the arrays ?

A quick review makes me think that mthca and mlx4 error paths lacks NUL=
L
assignment after calling ib_unregister_mad_agent(). In other words, qib
might be correct while the others should be fixed.

[1] http://mid.gmane.org/20150205174337.GB31711-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org

> > Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx4/mad.c        |    2 +-
> >  drivers/infiniband/hw/mthca/mthca_mad.c |    2 +-
> >  drivers/infiniband/hw/qib/qib_mad.c     |    2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/=
hw/mlx4/mad.c
> > index 82a7dd8..6be0d2c 100644
> > --- a/drivers/infiniband/hw/mlx4/mad.c
> > +++ b/drivers/infiniband/hw/mlx4/mad.c
> > @@ -907,7 +907,7 @@ int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
> >  err:
> >  	for (p =3D 0; p < dev->num_ports; ++p)
> >  		for (q =3D 0; q <=3D 1; ++q)
> > -			if (dev->send_agent[p][q])
> > +			if (!IS_ERR(dev->send_agent[p][q]))
> >  				ib_unregister_mad_agent(dev->send_agent[p][q]);
> > =20
> >  	return ret;
> > diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infi=
niband/hw/mthca/mthca_mad.c
> > index 8881fa3..5f1a7ce 100644
> > --- a/drivers/infiniband/hw/mthca/mthca_mad.c
> > +++ b/drivers/infiniband/hw/mthca/mthca_mad.c
> > @@ -317,7 +317,7 @@ int mthca_create_agents(struct mthca_dev *dev)
> >  err:
> >  	for (p =3D 0; p < dev->limits.num_ports; ++p)
> >  		for (q =3D 0; q <=3D 1; ++q)
> > -			if (dev->send_agent[p][q])
> > +			if (!IS_ERR(dev->send_agent[p][q]))
> >  				ib_unregister_mad_agent(dev->send_agent[p][q]);
> > =20
> >  	return ret;
> > diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniba=
nd/hw/qib/qib_mad.c
> > index 636be11..6c7cc80 100644
> > --- a/drivers/infiniband/hw/qib/qib_mad.c
> > +++ b/drivers/infiniband/hw/qib/qib_mad.c
> > @@ -2499,7 +2499,7 @@ int qib_create_agents(struct qib_ibdev *dev)
> >  err:
> >  	for (p =3D 0; p < dd->num_pports; p++) {
> >  		ibp =3D &dd->pport[p].ibport_data;
> > -		if (ibp->send_agent) {
> > +		if (!IS_ERR(ibp->send_agent)) {
> >  			agent =3D ibp->send_agent;
> >  			ibp->send_agent =3D NULL;
> >  			ib_unregister_mad_agent(agent);
>=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
