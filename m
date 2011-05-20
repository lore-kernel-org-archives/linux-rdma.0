From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Fri, 20 May 2011 11:19:45 -0700
Message-ID: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-8--956612955
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-8--956612955
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

We had a script which was looping through the devices returned from =
ibstat and attempted to register a SMI agent on an ethernet device.  =
This caused a kernel panic.  We have fixed our script.  This patch =
prevents the panic.



--Apple-Mail-8--956612955
Content-Disposition: attachment;
	filename=0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-QP0.patch
Content-Type: application/octet-stream;
	name="0001-Return-EPROTONOSUPPORT-when-an-RDMA-device-lacks-QP0.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2082e627f392fc928f55354d0dfc5e7868ac01ead1=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0ADate:=20Thu,=20=
19=20May=202011=2018:19:28=20-0700=0ASubject:=20[PATCH]=20Return=20=
EPROTONOSUPPORT=20when=20an=20RDMA=20device=20lacks=20QP0=0A=0AThis=20=
prevents=20a=20NULL=20pointer=20dereference=20later=20which=20panics=20=
the=20kernel.=0A=0ASigned-off-by:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0A=
---=0A=20drivers/infiniband/core/mad.c=20|=20=20=20=207=20+++++++=0A=201=20=
files=20changed,=207=20insertions(+),=200=20deletions(-)=0A=0Adiff=20=
--git=20a/drivers/infiniband/core/mad.c=20=
b/drivers/infiniband/core/mad.c=0Aindex=20b2dba21..e30652a=20100644=0A=
---=20a/drivers/infiniband/core/mad.c=0A+++=20=
b/drivers/infiniband/core/mad.c=0A@@=20-208,6=20+208,13=20@@=20struct=20=
ib_mad_agent=20*ib_register_mad_agent(struct=20ib_device=20*device,=0A=20=
=09u8=20mgmt_class,=20vclass;=0A=20=0A=20=09/*=20Validate=20parameters=20=
*/=0A+=09if=20(qp_type=20=3D=3D=20IB_QPT_SMI=20&&=0A+=09=20=20=20=20=
rdma_port_get_link_layer(device,=20port_num)!=3D=0A+=09=20=20=20=20=
IB_LINK_LAYER_INFINIBAND)=20{=0A+=09=09ret=20=3D=20=
ERR_PTR(-EPROTONOSUPPORT);=0A+=09=09goto=20error1;=0A+=09}=0A+=0A=20=09=
qpn=20=3D=20get_spl_qp_index(qp_type);=0A=20=09if=20(qpn=20=3D=3D=20-1)=0A=
=20=09=09goto=20error1;=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail-8--956612955--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
