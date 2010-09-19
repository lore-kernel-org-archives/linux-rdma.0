From: Irena Gannon <irena@mellanox.co.il>
Subject: [patch][tests][perftest] Make the server and client agree
	to	work via IPv4.
Date: Sun, 19 Sep 2010 15:54:28 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_"
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_
Content-Type: multipart/alternative;
	boundary="_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_"

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Irena Gannon (irena@mellanox.co.il<mailto:irena@mellanox.co.=
il>)

This patch makes the server and client agree to work via IPv4.
This way the socket connection that is opened in the beginning to exchange =
data does not fail because one of the sides works through IPv4 and the othe=
r through IPv6.

Index: D:/Windows/MLNX_VPI/tests/perftest/perftest_resources.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tests/perftest/perftest_resources.c             (re=
vision 6544)
+++ D:/Windows/MLNX_VPI/tests/perftest/perftest_resources.c          (revis=
ion 6545)
@@ -359,10 +359,13 @@
                }

                for (t =3D res; t; t =3D t->ai_next) {
+                             if (t->ai_family !=3D AF_INET)
+                                             continue;
                                sockfd =3D socket(t->ai_family, t->ai_sockt=
ype, t->ai_protocol);
                                if (sockfd !=3D INVALID_SOCKET) {
                                                if (!connect(sockfd, t->ai_=
addr, t->ai_addrlen))
                                                                break;
+                                             printf("Error at socket(): %l=
d\n", WSAGetLastError());
                                                closesocket(sockfd);
                                                sockfd =3D INVALID_SOCKET;
                                }
@@ -404,6 +407,8 @@
                }

                for (t =3D res; t; t =3D t->ai_next) {
+                             if (t->ai_family !=3D AF_INET)
+                                             continue;
                                sockfd =3D socket(t->ai_family, t->ai_sockt=
ype, t->ai_protocol);
                                if (sockfd !=3D INVALID_SOCKET) {
                                                n =3D 1;

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DWordSection1>

<p class=3DMsoNormal>Signed-off-by: Irena Gannon (<a
href=3D"mailto:irena@mellanox.co.il">irena@mellanox.co.il</a>)<o:p></o:p></=
p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>This patch makes the server and client agree to work v=
ia IPv4.<o:p></o:p></p>

<p class=3DMsoNormal>This way the socket connection that is opened in the b=
eginning
to exchange data does not fail because one of the sides works through IPv4 =
and
the other through IPv6.<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>Index: D:/Windows/MLNX_VPI/tests/perftest/perftest_res=
ources.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>--- D:/Windows/MLNX_VPI/tests/perftest/perftest_resour=
ces.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; (revision
6544)<o:p></o:p></p>

<p class=3DMsoNormal>+++ D:/Windows/MLNX_VPI/tests/perftest/perftest_resour=
ces.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (revision
6545)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -359,10 +359,13 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for
(t =3D res; t; t =3D t-&gt;ai_next) {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(t-&gt;ai_family !=3D AF_INET)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<o:p=
></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sockfd
=3D socket(t-&gt;ai_family, t-&gt;ai_socktype, t-&gt;ai_protocol);<o:p></o:=
p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(sockfd !=3D INVALID_SOCKET) {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if
(!connect(sockfd, t-&gt;ai_addr, t-&gt;ai_addrlen))<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; break;<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;=
Error
at socket(): %ld\n&quot;, WSAGetLastError());<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; closesocket(sockfd);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; sockfd
=3D INVALID_SOCKET;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>@@ -404,6 +407,8 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for
(t =3D res; t; t =3D t-&gt;ai_next) {<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(t-&gt;ai_family !=3D AF_INET)<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<o:p=
></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sockfd
=3D socket(t-&gt;ai_family, t-&gt;ai_socktype, t-&gt;ai_protocol);<o:p></o:=
p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if
(sockfd !=3D INVALID_SOCKET) {<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; n
=3D 1;<o:p></o:p></p>

</div>

</body>

</html>

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_--

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_
Content-Type: application/octet-stream; name="perftest_resourcesIPv4.patch"
Content-Description: perftest_resourcesIPv4.patch
Content-Disposition: attachment; filename="perftest_resourcesIPv4.patch";
	size=905; creation-date="Sun, 19 Sep 2010 15:37:33 GMT";
	modification-date="Sun, 19 Sep 2010 15:37:51 GMT"
Content-Transfer-Encoding: base64

SW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdGVzdHMvcGVyZnRlc3QvcGVyZnRlc3RfcmVzb3Vy
Y2VzLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rlc3RzL3BlcmZ0ZXN0
L3BlcmZ0ZXN0X3Jlc291cmNlcy5jCShyZXZpc2lvbiA2NTQ0KQ0KKysrIEQ6L1dpbmRvd3MvTUxO
WF9WUEkvdGVzdHMvcGVyZnRlc3QvcGVyZnRlc3RfcmVzb3VyY2VzLmMJKHJldmlzaW9uIDY1NDUp
DQpAQCAtMzU5LDEwICszNTksMTMgQEANCiAJfQogCiAJZm9yICh0ID0gcmVzOyB0OyB0ID0gdC0+
YWlfbmV4dCkgeworCQlpZiAodC0+YWlfZmFtaWx5ICE9IEFGX0lORVQpCisJCQljb250aW51ZTsK
IAkJc29ja2ZkID0gc29ja2V0KHQtPmFpX2ZhbWlseSwgdC0+YWlfc29ja3R5cGUsIHQtPmFpX3By
b3RvY29sKTsKIAkJaWYgKHNvY2tmZCAhPSBJTlZBTElEX1NPQ0tFVCkgewogCQkJaWYgKCFjb25u
ZWN0KHNvY2tmZCwgdC0+YWlfYWRkciwgdC0+YWlfYWRkcmxlbikpCiAJCQkJYnJlYWs7CisJCQlw
cmludGYoIkVycm9yIGF0IHNvY2tldCgpOiAlbGRcbiIsIFdTQUdldExhc3RFcnJvcigpKTsKIAkJ
CWNsb3Nlc29ja2V0KHNvY2tmZCk7CiAJCQlzb2NrZmQgPSBJTlZBTElEX1NPQ0tFVDsKIAkJfQpA
QCAtNDA0LDYgKzQwNyw4IEBADQogCX0KIAogCWZvciAodCA9IHJlczsgdDsgdCA9IHQtPmFpX25l
eHQpIHsKKwkJaWYgKHQtPmFpX2ZhbWlseSAhPSBBRl9JTkVUKQorCQkJY29udGludWU7CiAJCXNv
Y2tmZCA9IHNvY2tldCh0LT5haV9mYW1pbHksIHQtPmFpX3NvY2t0eXBlLCB0LT5haV9wcm90b2Nv
bCk7CiAJCWlmIChzb2NrZmQgIT0gSU5WQUxJRF9TT0NLRVQpIHsKIAkJCW4gPSAxOwo=

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--_004_E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9MTLMAILmtlcom_--
