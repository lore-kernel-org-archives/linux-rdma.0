From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: iblinkinfo; remove non-supported -c option from man page
Date: Mon, 25 Apr 2011 19:49:37 -0700
Message-ID: <C073632F-D262-45F2-A6C5-A97F85900409@llnl.gov>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-5--938537302
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail-5--938537302
Content-Disposition: attachment;
	filename=0001-infiniband-diags-iblinkinfo-remove-non-supported-c-o.patch
Content-Type: application/octet-stream;
	name="0001-infiniband-diags-iblinkinfo-remove-non-supported-c-o.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20a398a098d0c21f0993cd3b8e3cd7485d87d6dff8=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0ADate:=20Sun,=20=
17=20Apr=202011=2003:06:21=20-0700=0ASubject:=20[PATCH=201/2]=20=
infiniband-diags:=20iblinkinfo;=20remove=20non-supported=20-c=20option=20=
from=20man=20page=0A=0ASigned-off-by:=20Ira=20Weiny=20<weiny2-i2BcT+NCU+M@public.gmane.org>=0A=
---=0A=20man/iblinkinfo.8=20|=20=20=20=203=20---=0A=201=20files=20=
changed,=200=20insertions(+),=203=20deletions(-)=0A=0Adiff=20--git=20=
a/man/iblinkinfo.8=20b/man/iblinkinfo.8=0Aindex=20940d008..a66db6d=20=
100644=0A---=20a/man/iblinkinfo.8=0A+++=20b/man/iblinkinfo.8=0A@@=20=
-34,9=20+34,6=20@@=20Print=20only=20switches=20which=20have=20a=20port=20=
in=20the=20"Down"=20state.=0A=20\fB\-v=20<lt,hoq,vlstall>\fR=0A=20Verify=20=
additional=20switch=20settings=20(<LifeTime>,<HoqLife>,<VLStallCount>)=0A=
=20.TP=0A-\fB\-c\fR=0A-Print=20port=20capabilities=20(enabled=20and=20=
supported=20values)=0A-.TP=0A=20\fB\-C=20<ca_name>\fR=20=20=20=20use=20=
the=20specified=20ca_name=20for=20the=20search.=0A=20.TP=0A=20\fB\-P=20=
<ca_port>\fR=20=20=20=20use=20the=20specified=20ca_port=20for=20the=20=
search.=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail-5--938537302--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
