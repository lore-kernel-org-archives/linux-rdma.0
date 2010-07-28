From: Irena Kruchkovsky <irena@mellanox.co.il>
Subject: [Patch] [Tools][infiniband-diags]
Date: Wed, 28 Jul 2010 14:36:21 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_"
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
To: Linux RDMA list <linux-rdma@vger.kernel.org>, Sasha Khapyorsky <sashak@voltaire.com>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_
Content-Type: multipart/alternative;
	boundary="_000_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_"

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

A patch that fixes the GUID output in ibstat to work correctly in windows 2=
003.

Index: D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c  (revision 6199=
)
+++ D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c               (=
revision 6200)
@@ -72,9 +72,9 @@
                printf("\tNumber of ports: %d\n", ca->numports);
                printf("\tFirmware version: %s\n", ca->fw_ver);
                printf("\tHardware version: %s\n", ca->hw_ver);
-              printf("\tNode GUID: 0x%016llx\n",
+             printf("\tNode GUID: 0x%016I64x\n",
                       (long long unsigned)ntohll(ca->node_guid));
-              printf("\tSystem image GUID: 0x%016llx\n",
+             printf("\tSystem image GUID: 0x%016I64x\n",
                       (long long unsigned)ntohll(ca->system_guid));
 }

@@ -122,7 +122,7 @@
                printf("%sLMC: %d\n", pre, port->lmc);
                printf("%sSM lid: %d\n", pre, port->sm_lid);
                printf("%sCapability mask: 0x%08x\n", pre, ntohl(port->capm=
ask));
-              printf("%sPort GUID: 0x%016llx\n", pre,
+             printf("%sPort GUID: 0x%016I64x\n", pre,
                       (long long unsigned)ntohll(port->port_guid));
                return 0;
 }


Example:

Previous output:
System image GUID: 0x000000000003cc13

Current output:
System image GUID: 0x0002c9020003cc13


--_000_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_
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

<p class=3DMsoNormal style=3D'text-autospace:none'>A patch that fixes the<s=
pan
style=3D'font-size:8.5pt;font-family:"Courier New"'> </span>GUID output in =
ibstat
to work correctly in windows 2003.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Index:
D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibstat.c<o:p></o:p></p>

<p class=3DMsoNormal>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<o:=
p></o:p></p>

<p class=3DMsoNormal>--- D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibs=
tat.c&nbsp; (revision
6199)<o:p></o:p></p>

<p class=3DMsoNormal>+++ D:/Windows/MLNX_VPI/tools/infiniband-diags/src/ibs=
tat.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; (revision
6200)<o:p></o:p></p>

<p class=3DMsoNormal>@@ -72,9 +72,9 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\tNumber
of ports: %d\n&quot;, ca-&gt;numports);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\tFirmware
version: %s\n&quot;, ca-&gt;fw_ver);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\tHardware
version: %s\n&quot;, ca-&gt;hw_ver);<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\tNode
GUID: 0x%016llx\n&quot;,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;\tNode
GUID: 0x%016I64x\n&quot;,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
(long long unsigned)ntohll(ca-&gt;node_guid));<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;\tSystem
image GUID: 0x%016llx\n&quot;,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;\tSystem
image GUID: 0x%016I64x\n&quot;,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
(long long unsigned)ntohll(ca-&gt;system_guid));<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>@@ -122,7 +122,7 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%sLMC:
%d\n&quot;, pre, port-&gt;lmc);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%sSM
lid: %d\n&quot;, pre, port-&gt;sm_lid);<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%sCapability
mask: 0x%08x\n&quot;, pre, ntohl(port-&gt;capmask));<o:p></o:p></p>

<p class=3DMsoNormal>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;%sPort
GUID: 0x%016llx\n&quot;, pre,<o:p></o:p></p>

<p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; printf(&quot;%sPort
GUID: 0x%016I64x\n&quot;, pre,<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
(long long unsigned)ntohll(port-&gt;port_guid));<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return
0;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;}<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Example:<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Previous output:<o:p></o:p></p>

<p class=3DMsoNormal>System image GUID: 0x000000000003cc13<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Current output:<o:p></o:p></p>

<p class=3DMsoNormal>System image GUID: 0x0002c9020003cc13<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

--_000_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_--

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_
Content-Type: application/octet-stream; name="ibstatGUID.patch"
Content-Description: ibstatGUID.patch
Content-Disposition: attachment; filename="ibstatGUID.patch"; size=1068;
	creation-date="Wed, 28 Jul 2010 14:17:32 GMT";
	modification-date="Wed, 28 Jul 2010 14:18:00 GMT"
Content-Transfer-Encoding: base64

SW5kZXg6IEQ6L1dpbmRvd3MvTUxOWF9WUEkvdG9vbHMvaW5maW5pYmFuZC1kaWFncy9zcmMvaWJz
dGF0LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCi0tLSBEOi9XaW5kb3dzL01MTlhfVlBJL3Rvb2xzL2luZmluaWJh
bmQtZGlhZ3Mvc3JjL2lic3RhdC5jCShyZXZpc2lvbiA2MTk5KQ0KKysrIEQ6L1dpbmRvd3MvTUxO
WF9WUEkvdG9vbHMvaW5maW5pYmFuZC1kaWFncy9zcmMvaWJzdGF0LmMJKHJldmlzaW9uIDYyMDAp
DQpAQCAtNzIsOSArNzIsOSBAQA0KIAlwcmludGYoIlx0TnVtYmVyIG9mIHBvcnRzOiAlZFxuIiwg
Y2EtPm51bXBvcnRzKTsKIAlwcmludGYoIlx0RmlybXdhcmUgdmVyc2lvbjogJXNcbiIsIGNhLT5m
d192ZXIpOwogCXByaW50ZigiXHRIYXJkd2FyZSB2ZXJzaW9uOiAlc1xuIiwgY2EtPmh3X3Zlcik7
Ci0JcHJpbnRmKCJcdE5vZGUgR1VJRDogMHglMDE2bGx4XG4iLAorCXByaW50ZigiXHROb2RlIEdV
SUQ6IDB4JTAxNkk2NHhcbiIsCiAJICAgICAgIChsb25nIGxvbmcgdW5zaWduZWQpbnRvaGxsKGNh
LT5ub2RlX2d1aWQpKTsKLQlwcmludGYoIlx0U3lzdGVtIGltYWdlIEdVSUQ6IDB4JTAxNmxseFxu
IiwKKwlwcmludGYoIlx0U3lzdGVtIGltYWdlIEdVSUQ6IDB4JTAxNkk2NHhcbiIsCiAJICAgICAg
IChsb25nIGxvbmcgdW5zaWduZWQpbnRvaGxsKGNhLT5zeXN0ZW1fZ3VpZCkpOwogfQogCkBAIC0x
MjIsNyArMTIyLDcgQEANCiAJcHJpbnRmKCIlc0xNQzogJWRcbiIsIHByZSwgcG9ydC0+bG1jKTsK
IAlwcmludGYoIiVzU00gbGlkOiAlZFxuIiwgcHJlLCBwb3J0LT5zbV9saWQpOwogCXByaW50Zigi
JXNDYXBhYmlsaXR5IG1hc2s6IDB4JTA4eFxuIiwgcHJlLCBudG9obChwb3J0LT5jYXBtYXNrKSk7
Ci0JcHJpbnRmKCIlc1BvcnQgR1VJRDogMHglMDE2bGx4XG4iLCBwcmUsCisJcHJpbnRmKCIlc1Bv
cnQgR1VJRDogMHglMDE2STY0eFxuIiwgcHJlLAogCSAgICAgICAobG9uZyBsb25nIHVuc2lnbmVk
KW50b2hsbChwb3J0LT5wb3J0X2d1aWQpKTsKIAlyZXR1cm4gMDsKIH0K

--_004_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--_004_E113D394D7C5DB4F8FF691FA7EE9DB443B390460E6MTLMAILmtlcom_--
