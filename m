From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: improve backwards/standalone compatibility
Date: Mon, 25 Apr 2011 19:51:45 -0700
Message-ID: <B4ABEA89-7D47-474B-9AAB-08E48AB6BBF0@llnl.gov>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-7--938408722
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-7--938408722
Content-Disposition: attachment;
	filename=0002-infiniband-diags-improve-backwards-standalone-compat.patch
Content-Type: application/octet-stream;
	x-unix-mode=0640;
	name="0002-infiniband-diags-improve-backwards-standalone-compat.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20085432de49bcf6ebbcb927e2cac53da32cc9be94=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0ADate:=20Thu,=20=
21=20Apr=202011=2014:47:03=20-0700=0ASubject:=20[PATCH]=20=
infiniband-diags:=20improve=20backwards/standalone=20compatibility=0A=0A=
specifically=20allow=20for=20umad_port_t=20to=20not=20have=20link_layer=0A=
Furthermore=20"mad.h"=20should=20not=20have=20libibnetdisc=20OS=20=
specific=20defines.=0A=0ASigned-off-by:=20Ira=20Weiny=20=
<weiny2-i2BcT+NCU+M@public.gmane.org>=0A---=0A=20configure.in=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
|=20=20=20=207=20++++=0A=20libibnetdisc/include/infiniband/ibnetdisc.h=20=
=20=20=20=20|=20=20=20=202=20+=0A=20=
libibnetdisc/include/infiniband/ibnetdisc_osd.h=20|=20=20=2042=20=
+++++++++++++++++++++++=0A=20src/ibstat.c=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
|=20=20=20=202=20+=0A=204=20files=20changed,=2053=20insertions(+),=200=20=
deletions(-)=0A=20create=20mode=20100644=20=
libibnetdisc/include/infiniband/ibnetdisc_osd.h=0A=0Adiff=20--git=20=
a/configure.in=20b/configure.in=0Aindex=20003369d..8461a37=20100644=0A=
---=20a/configure.in=0A+++=20b/configure.in=0A@@=20-39,6=20+39,13=20@@=20=
AC_CHECK_LIB(ibmad,=20mad_dump_int,=20[],=0A=20=09=
AC_MSG_ERROR([mad_dump_int()=20not=20found.=20diags=20require=20=
libibmad.]))=0A=20AC_CHECK_LIB(ibmad,=20pma_query_via,=20[],=0A=20=09=
AC_MSG_ERROR([pma_query_via()=20not=20found.=20diags=20require=20more=20=
recent=20libibmad.]))=0A+AC_CHECK_MEMBER([struct=20=
umad_port.link_layer],=0A+=09=09=09[ac_have_umad_port_link_layer=3Dyes],=0A=
+=09=09=09[ac_have_umad_port_link_layer=3Dno],=0A+=09=09=09[#include=20=
<infiniband/umad.h>])=0A+if=20test=20"$ac_have_umad_port_link_layer"=20=3D=
=20"yes";=20then=0A+=20=20=20AC_DEFINE([HAVE_UMAD_PORT_LINK_LAYER],=201,=20=
[Define=20to=201=20if=20struct=20umad_port=20has=20link_layer=20member])=0A=
+fi=0A=20AC_CHECK_LIB(osmcomp,=20cl_thread_init,=20[],=0A=20=09=
AC_MSG_ERROR([cl_thread_init()=20not=20found.=20diags=20require=20=
libosmcomp.]))=0A=20fi=0Adiff=20--git=20=
a/libibnetdisc/include/infiniband/ibnetdisc.h=20=
b/libibnetdisc/include/infiniband/ibnetdisc.h=0Aindex=201efd1d6..7b42026=20=
100644=0A---=20a/libibnetdisc/include/infiniband/ibnetdisc.h=0A+++=20=
b/libibnetdisc/include/infiniband/ibnetdisc.h=0A@@=20-40,6=20+40,8=20@@=0A=
=20#include=20<infiniband/mad.h>=0A=20#include=20<iba/ib_types.h>=0A=20=0A=
+#include=20<infiniband/ibnetdisc_osd.h>=0A+=0A=20struct=20ibnd_chassis;=09=
=09/*=20forward=20declare=20*/=0A=20struct=20ibnd_port;=09=09/*=20=
forward=20declare=20*/=0A=20=0Adiff=20--git=20=
a/libibnetdisc/include/infiniband/ibnetdisc_osd.h=20=
b/libibnetdisc/include/infiniband/ibnetdisc_osd.h=0Anew=20file=20mode=20=
100644=0Aindex=200000000..4491511=0A---=20/dev/null=0A+++=20=
b/libibnetdisc/include/infiniband/ibnetdisc_osd.h=0A@@=20-0,0=20+1,42=20=
@@=0A+/*=0A+=20*=20Copyright=20(c)=202011=20Lawrence=20Livermore=20=
National=20Security.=20=20All=20rights=20reserved.=0A+=20*=0A+=20*=20=
This=20software=20is=20available=20to=20you=20under=20a=20choice=20of=20=
one=20of=20two=0A+=20*=20licenses.=20=20You=20may=20choose=20to=20be=20=
licensed=20under=20the=20terms=20of=20the=20GNU=0A+=20*=20General=20=
Public=20License=20(GPL)=20Version=202,=20available=20from=20the=20file=0A=
+=20*=20COPYING=20in=20the=20main=20directory=20of=20this=20source=20=
tree,=20or=20the=0A+=20*=20OpenIB.org=20BSD=20license=20below:=0A+=20*=0A=
+=20*=20=20=20=20=20Redistribution=20and=20use=20in=20source=20and=20=
binary=20forms,=20with=20or=0A+=20*=20=20=20=20=20without=20=
modification,=20are=20permitted=20provided=20that=20the=20following=0A+=20=
*=20=20=20=20=20conditions=20are=20met:=0A+=20*=0A+=20*=20=20=20=20=20=20=
-=20Redistributions=20of=20source=20code=20must=20retain=20the=20above=0A=
+=20*=20=20=20=20=20=20=20=20copyright=20notice,=20this=20list=20of=20=
conditions=20and=20the=20following=0A+=20*=20=20=20=20=20=20=20=20=
disclaimer.=0A+=20*=0A+=20*=20=20=20=20=20=20-=20Redistributions=20in=20=
binary=20form=20must=20reproduce=20the=20above=0A+=20*=20=20=20=20=20=20=20=
=20copyright=20notice,=20this=20list=20of=20conditions=20and=20the=20=
following=0A+=20*=20=20=20=20=20=20=20=20disclaimer=20in=20the=20=
documentation=20and/or=20other=20materials=0A+=20*=20=20=20=20=20=20=20=20=
provided=20with=20the=20distribution.=0A+=20*=0A+=20*=20THE=20SOFTWARE=20=
IS=20PROVIDED=20"AS=20IS",=20WITHOUT=20WARRANTY=20OF=20ANY=20KIND,=0A+=20=
*=20EXPRESS=20OR=20IMPLIED,=20INCLUDING=20BUT=20NOT=20LIMITED=20TO=20THE=20=
WARRANTIES=20OF=0A+=20*=20MERCHANTABILITY,=20FITNESS=20FOR=20A=20=
PARTICULAR=20PURPOSE=20AND=0A+=20*=20NONINFRINGEMENT.=20IN=20NO=20EVENT=20=
SHALL=20THE=20AUTHORS=20OR=20COPYRIGHT=20HOLDERS=0A+=20*=20BE=20LIABLE=20=
FOR=20ANY=20CLAIM,=20DAMAGES=20OR=20OTHER=20LIABILITY,=20WHETHER=20IN=20=
AN=0A+=20*=20ACTION=20OF=20CONTRACT,=20TORT=20OR=20OTHERWISE,=20ARISING=20=
FROM,=20OUT=20OF=20OR=20IN=0A+=20*=20CONNECTION=20WITH=20THE=20SOFTWARE=20=
OR=20THE=20USE=20OR=20OTHER=20DEALINGS=20IN=20THE=0A+=20*=20SOFTWARE.=0A=
+=20*=0A+=20*/=0A+=0A+#ifndef=20_IBNETDISC_OSD_H_=0A+#define=20=
_IBNETDISC_OSD_H_=0A+=0A+/*=20Define=20OS=20specific=20bits=20*/=0A+=0A=
+/*=20Linux=20*/=0A+#define=20IBND_EXPORT=0A+=0A+#endif=09=09=09=09/*=20=
_IBNETDISC_OSD_H_=20*/=0Adiff=20--git=20a/src/ibstat.c=20b/src/ibstat.c=0A=
index=20f51d17b..92fcd0f=20100644=0A---=20a/src/ibstat.c=0A+++=20=
b/src/ibstat.c=0A@@=20-122,7=20+122,9=20@@=20static=20int=20=
port_dump(umad_port_t=20*=20port,=20int=20alone)=0A=20=09printf("%sSM=20=
lid:=20%d\n",=20pre,=20port->sm_lid);=0A=20=09printf("%sCapability=20=
mask:=200x%08x\n",=20pre,=20ntohl(port->capmask));=0A=20=09=
printf("%sPort=20GUID:=200x%016"=20PRIx64=20"\n",=20pre,=20=
ntohll(port->port_guid));=0A+#ifdef=20HAVE_UMAD_PORT_LINK_LAYER=0A=20=09=
printf("%sLink=20layer:=20%s\n",=20pre,=20port->link_layer);=0A+#endif=0A=
=20=09return=200;=0A=20}=0A=20=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail-7--938408722--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
