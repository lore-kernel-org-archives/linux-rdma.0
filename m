From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibmad: Remove libibnetdisc specific define
Date: Mon, 25 Apr 2011 19:50:41 -0700
Message-ID: <827E00F9-FF09-4698-B4CF-D5D1E38A7FF5@llnl.gov>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-6--938472919
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-6--938472919
Content-Disposition: attachment;
	filename=0001-libibmad-Remove-libibnetdisc-specific-define.patch
Content-Type: application/octet-stream;
	x-unix-mode=0640;
	name="0001-libibmad-Remove-libibnetdisc-specific-define.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20c6e974a83d2355bb60bde545abd0b3c8226ff323=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0ADate:=20Thu,=20=
21=20Apr=202011=2014:24:27=20-0700=0ASubject:=20[PATCH]=20libibmad:=20=
Remove=20libibnetdisc=20specific=20define=0A=0ASigned-off-by:=20Ira=20=
Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0A---=0A=20include/infiniband/mad_osd.h=20|=20=20=
=20=201=20-=0A=201=20files=20changed,=200=20insertions(+),=201=20=
deletions(-)=0A=0Adiff=20--git=20a/include/infiniband/mad_osd.h=20=
b/include/infiniband/mad_osd.h=0Aindex=20ee73561..923be55=20100644=0A---=20=
a/include/infiniband/mad_osd.h=0A+++=20b/include/infiniband/mad_osd.h=0A=
@@=20-44,7=20+44,6=20@@=0A=20#include=20<arpa/inet.h>=0A=20=0A=20#define=20=
MAD_EXPORT=0A-#define=20IBND_EXPORT=0A=20#define=20DEPRECATED=20=
__attribute__=20((deprecated))=0A=20=0A=20#endif=09=09=09=09/*=20=
_MAD_OSD_H_=20*/=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail-6--938472919--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
