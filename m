From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH v2] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Sun, 22 May 2011 20:46:37 -0700
Message-ID: <B4F482DA-6C66-4AC9-A583-D2091E8F32C4@llnl.gov>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov> <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com> <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE@llnl.gov> <1828884A29C6694DAF28B7E6B8A8237301085B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-10--749800703
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237301085B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-10--749800703
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On May 20, 2011, at 4:23 PM, Hefty, Sean wrote:

>>> 	mad_agent_priv->agent.mr =3D =
ib_get_dma_mr(port_priv->qp_info[qpn].qp-
>>> pd,
>>> 						 IB_ACCESS_LOCAL_WRITE);
>>>=20
>>> in which case it may be safer to check for the NULL pointer.  Can =
you
>> confirm if this was the spot?
>>=20
>> Yes it was that spot.  I did think of that today after I sent the =
patch.
>>=20
>> Do you think it would be safer just to check for both pointers QP0 =
and 1
>> (depending on the registration)?
>=20
> Yes, it seems safer and easier to maintain if we just validated the =
pointer.
>=20
> - Sean

New patch attached.

Ira


--Apple-Mail-10--749800703
Content-Disposition: attachment;
	filename=0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-the.patch
Content-Type: application/octet-stream;
	name="0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-the.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20c4db4c727704cd94d37a57252e0636c2adf1e040=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0ADate:=20Thu,=20=
19=20May=202011=2018:19:28=20-0700=0ASubject:=20[PATCH]=20Return=20=
EPROTONOSUPPORT=20when=20an=20RDMA=20device=20lacks=20the=20QP=20=
required.=0A=0ASigned-off-by:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0A---=0A=20=
drivers/infiniband/core/mad.c=20|=20=20=20=208=20++++++++=0A=201=20files=20=
changed,=208=20insertions(+),=200=20deletions(-)=0A=0Adiff=20--git=20=
a/drivers/infiniband/core/mad.c=20b/drivers/infiniband/core/mad.c=0A=
index=20b2dba21..fc97883=20100644=0A---=20=
a/drivers/infiniband/core/mad.c=0A+++=20b/drivers/infiniband/core/mad.c=0A=
@@=20-275,6=20+275,13=20@@=20struct=20ib_mad_agent=20=
*ib_register_mad_agent(struct=20ib_device=20*device,=0A=20=09=09goto=20=
error1;=0A=20=09}=0A=20=0A+=09/*=20Verify=20the=20QP=20requested=20is=20=
supported.=20=20For=20example,=20Ethernet=20devices=0A+=09=20*=20will=20=
not=20have=20QP0=20*/=0A+=09if=20(!port_priv->qp_info[qpn].qp)=20{=0A+=09=
=09ret=20=3D=20ERR_PTR(-EPROTONOSUPPORT);=0A+=09=09goto=20error1;=0A+=09=
}=0A+=0A=20=09/*=20Allocate=20structures=20*/=0A=20=09mad_agent_priv=20=3D=
=20kzalloc(sizeof=20*mad_agent_priv,=20GFP_KERNEL);=0A=20=09if=20=
(!mad_agent_priv)=20{=0A@@=20-2738,6=20+2745,7=20@@=20static=20void=20=
init_mad_qp(struct=20ib_mad_port_private=20*port_priv,=0A=20=09=
spin_lock_init(&qp_info->snoop_lock);=0A=20=09qp_info->snoop_table=20=3D=20=
NULL;=0A=20=09qp_info->snoop_table_size=20=3D=200;=0A+=09qp_info->qp=20=3D=
=20NULL;=0A=20=09atomic_set(&qp_info->snoop_count,=200);=0A=20}=0A=20=0A=
--=20=0A1.7.1=0A=0A=

--Apple-Mail-10--749800703--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
