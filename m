From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.8 release
Date: Thu, 18 Feb 2016 00:45:35 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980D5FD6B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7530119039355307812=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg/>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============7530119039355307812==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_54347E5A035A054EAE9D05927FB467F980D5FD6BORSMSX101amrcor_"

--_000_54347E5A035A054EAE9D05927FB467F980D5FD6BORSMSX101amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



New release for uDAPL (2.1.8) is available at http://downloads.openfabrics.=
org/dapl/dapl-2.1.8.tar.gz



Vlad, please pull into OFED 3.18-2



     md5sum: 47cc7eb0302c20ab4fc08910e17e3c47 dapl-2.1.8.tar.gz



For v2.1 package install RPM packages as follow:



     dapl-2.1.8-1

     dapl-utils-2.1.8-1

     dapl-devel-2.1.8-1

     dapl-debuginfo-2.1.8-1



Release notes: http://downloads.openfabrics.org/dapl/documentation/uDAPL_re=
lease_notes.txt



Summary of changes:



Release 2.1.8



 mpxyd: fix segfault in proxy_out debug logging

 mpxyd: fix debug memory buffer log function

 dtest: -D option is not valid with scif providers

 dtest/dapltest: add new automated test suite for HOST to MIC testing

 openib: update attributes correctly for iWARP transports

 openib_common: set providers mtu to active_mtu instead of 2048

 mpxyd: set affinity default to 2 for best performance

 mcm: cleanup unused variable in dapls_ib_mr_register

 dtest: enhancement to test, -D option for data check

 mcm: add support for Intel Omni-Path driver (hfi) via mic MFO mode

 mpxyd: fix ordering issues with the CCL Proxy receive side forwarding mech=
anism

 dtest: report results only if one of the pingpong tests are run

 mpxyd: with abnormal CM termination a CM object can be referenced after QP=
 destroy

 mpxyd: proxy out WR resources exhausted with MFO mode endpoints

 release note update for CCL Proxy and Platform BIOS recommendations

 dtestx: add dat_ib_open_query only option with -q

 scm: CONN_PENDING: SOCKOPT ERR Connection refused ->





Release commit: http://git.openfabrics.org/?p=3D~ardavis/dapl.git;a=3Dcommi=
t;h=3Dc9a7fd2e658efa9021cc386d1b8ec3691a903959



Regards, Arlin


--_000_54347E5A035A054EAE9D05927FB467F980D5FD6BORSMSX101amrcor_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
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
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<pre><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,sans-s=
erif"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">New release for uDAPL (2.1.8) is available=
 at <a href=3D"http://downloads.openfabrics.org/dapl/dapl-2.1.8.tar.gz">htt=
p://downloads.openfabrics.org/dapl/dapl-2.1.8.tar.gz</a><o:p></o:p></span><=
/pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Vlad, please pull into OFED 3.18-2 <o:p></=
o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;&nbsp;&nbsp;&nbsp; md5sum: 47cc7eb03=
02c20ab4fc08910e17e3c47 dapl-2.1.8.tar.gz <o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">For v2.1 package install RPM packages as f=
ollow:<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;&nbsp;&nbsp;&nbsp; dapl-2.1.8-1<o:p>=
</o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;&nbsp;&nbsp;&nbsp; dapl-utils-2.1.8-=
1&nbsp; <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dapl-devel-2=
.1.8-1<o:p></o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;&nbsp;&nbsp;&nbsp; dapl-debuginfo-2.=
1.8-1<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Release notes: <a href=3D"http://downloads=
.openfabrics.org/dapl/documentation/uDAPL_release_notes.txt">http://downloa=
ds.openfabrics.org/dapl/documentation/uDAPL_release_notes.txt</a><o:p></o:p=
></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Summary of changes:<o:p></o:p></span></pre=
>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Release 2.1.8<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> <o:p></o:p></span></pre>
<pre><span style=3D"color:black">&nbsp;mpxyd: fix segfault in proxy_out deb=
ug logging<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mpxyd: fix debug memory buffer log functi=
on<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> dtest: -D option is not valid with scif p=
roviders<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> dtest/dapltest: add new automated test su=
ite for HOST to MIC testing<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> openib: update attributes correctly for i=
WARP transports<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> openib_common: set providers mtu to activ=
e_mtu instead of 2048<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mpxyd: set affinity default to 2 for best=
 performance<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mcm: cleanup unused variable in dapls_ib_=
mr_register<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> dtest: enhancement to test, -D option for=
 data check<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mcm: add support for Intel Omni-Path driv=
er (hfi) via mic MFO mode<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mpxyd: fix ordering issues with the CCL P=
roxy receive side forwarding mechanism<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> dtest: report results only if one of the =
pingpong tests are run<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mpxyd: with abnormal CM termination a CM =
object can be referenced after QP destroy<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> mpxyd: proxy out WR resources exhausted w=
ith MFO mode endpoints<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> release note update for CCL Proxy and Pla=
tform BIOS recommendations<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> dtestx: add dat_ib_open_query only option=
 with -q<o:p></o:p></span></pre>
<pre><span style=3D"color:black"> scm: CONN_PENDING: SOCKOPT ERR Connection=
 refused -&gt;<o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Release commit: <a href=3D"http://git.open=
fabrics.org/?p=3D~ardavis/dapl.git;a=3Dcommit;h=3Dc9a7fd2e658efa9021cc386d1=
b8ec3691a903959">http://git.openfabrics.org/?p=3D~ardavis/dapl.git;a=3Dcomm=
it;h=3Dc9a7fd2e658efa9021cc386d1b8ec3691a903959</a><o:p></o:p></span></pre>
<pre><span style=3D"color:black"><o:p>&nbsp;</o:p></span></pre>
<pre><span style=3D"color:black">Regards, Arlin<o:p></o:p></span></pre>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_54347E5A035A054EAE9D05927FB467F980D5FD6BORSMSX101amrcor_--

--===============7530119039355307812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/mailman/listinfo/ewg
--===============7530119039355307812==--
