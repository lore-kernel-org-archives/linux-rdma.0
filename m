From: "Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Subject: Re: iWARP tuning
Date: Fri, 4 Mar 2011 08:59:45 -0000
Message-ID: <005701cbda4a$82f9b8b0$88ed2a10$@com>
References: <AANLkTimhJv2Mdj3disORwbyudRZWF=DLvG8PCtg577a+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1808830092=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <AANLkTimhJv2Mdj3disORwbyudRZWF=DLvG8PCtg577a+-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-gb
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'Tanin' <fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.

--===============1808830092==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0058_01CBDA4A.82F9B8B0"
Content-Language: en-gb

This is a multi-part message in MIME format.

------=_NextPart_000_0058_01CBDA4A.82F9B8B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Is your NIC using TOE or a kernel based TCP/IP stack.

 

TCP requires the window size to match the B/W delay product.  By default, it
is only set to support high B/W LAN or low B/W WAN.   If you have a high B/W
WAN, which you would need for RDMA, then you need to increase the TCP
buffers and window size settings accordingly.   If it is TOE, then you will
be constrained by  whether they expose these settings and whether there is
sufficient memory on the card to  reach your B/W delay product.

 

From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
[mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Tanin
Sent: 04 March 2011 01:21
To: linux-rdma; ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Subject: [ewg] iWARP tuning

 

Dear all,

 

            We had conducted some tests on long distance data transfer using
iWARP. But the performance is bad. Does anyone has some idea on how to tune
the iWARP for better performance? Does iWARP support paralell data transfer?
Does the buffer size of the card tunable?

 

Thanks!

 



-- 

Best regards,

 

----------------------------------------------------------------------------
-------------------
Li, Tan
PhD Candidate & Research Assistant, 
Electrical Engineering, 
Stony Brook University, NY

Personal Web Site: https://sites.google.com/site/homepagelitan/Home

Email: fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

 


------=_NextPart_000_0058_01CBDA4A.82F9B8B0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><META =
HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 12 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-GB link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";color:#1F497=
D'>Is your NIC using TOE or a kernel based TCP/IP =
stack.<o:p></o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";color:#1F497=
D'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";color:#1F497=
D'>TCP requires the window size to match the B/W delay product.&nbsp; By =
default, it is only set to support high B/W LAN or low B/W =
WAN.&nbsp;&nbsp; If you have a high B/W WAN, which you would need for =
RDMA, then you need to increase the TCP buffers and window size settings =
accordingly.&nbsp;&nbsp; If it is TOE, then you will be constrained by =
&nbsp;whether they expose these settings and whether there is sufficient =
memory on the card to&nbsp; reach your B/W delay =
product.<o:p></o:p></span></p><p class=3DMsoNormal><span =
style=3D'font-size:11.0pt;font-family:"Calibri","sans-serif";color:#1F497=
D'><o:p>&nbsp;</o:p></span></p><div =
style=3D'border:none;border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0cm =
0cm 0cm'><p class=3DMsoNormal><b><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'>From:</span>=
</b><span lang=3DEN-US =
style=3D'font-size:10.0pt;font-family:"Tahoma","sans-serif"'> =
ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org =
[mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] <b>On Behalf Of =
</b>Tanin<br><b>Sent:</b> 04 March 2011 01:21<br><b>To:</b> linux-rdma; =
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org<br><b>Subject:</b> [ewg] iWARP =
tuning<o:p></o:p></span></p></div><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><div><p class=3DMsoNormal>Dear =
all,<o:p></o:p></p></div><div><p =
class=3DMsoNormal>&nbsp;<o:p></o:p></p></div><div><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; We had conducted some tests on long distance data transfer =
using iWARP. But the performance is bad. Does anyone has some idea =
on&nbsp;how to&nbsp;tune the iWARP&nbsp;for =
better&nbsp;performance?&nbsp;Does iWARP support paralell data =
transfer?&nbsp;Does&nbsp;the buffer size of the card =
tunable?<o:p></o:p></p></div><div><p =
class=3DMsoNormal>&nbsp;<o:p></o:p></p></div><div><p =
class=3DMsoNormal>Thanks!<o:p></o:p></p></div><div><p =
class=3DMsoNormal>&nbsp;<o:p></o:p></p></div><div><p =
class=3DMsoNormal><br clear=3Dall><br>-- <o:p></o:p></p></div><div><p =
class=3DMsoNormal>Best regards,<o:p></o:p></p></div><div><p =
class=3DMsoNormal>&nbsp;<o:p></o:p></p></div><div><p =
class=3DMsoNormal>-------------------------------------------------------=
----------------------------------------<br>Li, =
Tan<br>PhD&nbsp;Candidate &amp; Research Assistant, <br>Electrical =
Engineering, <br>Stony Brook University, NY<br><br>Personal Web Site: <a =
href=3D"https://sites.google.com/site/homepagelitan/Home" =
target=3D"_blank">https://sites.google.com/site/homepagelitan/Home</a><br=
><br>Email: <a href=3D"mailto:fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" =
target=3D"_blank">fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a><o:p></o:p></p></div><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html>
------=_NextPart_000_0058_01CBDA4A.82F9B8B0--


--===============1808830092==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============1808830092==--
