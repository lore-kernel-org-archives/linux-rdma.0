From: Tanin <fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Installation problems of OFED-1.5.2
Date: Wed, 23 Feb 2011 14:02:11 -0500
Message-ID: <AANLkTinLQ0zo1jbENOAoaDTVi6dmpPn3zTSfY12q-gxf@mail.gmail.com>
References: <AANLkTi=s7YtdX2+bb4pLY035OXQSqyf21JuxatDCL=N_@mail.gmail.com>
	<4D64CFEA.1030805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1766152831=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4D64CFEA.1030805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============1766152831==
Content-Type: multipart/alternative; boundary=90e6ba53acf401908d049cf7bc9f

--90e6ba53acf401908d049cf7bc9f
Content-Type: text/plain; charset=ISO-8859-1

Oh, yes. Thanks so much! After uninstall all libibverbs packages, the
OFED-1.5.3-rc5 successfully passed all building process:


Install iscsi-initiator-utils RPM:
Running rpm -iv
/atlas/data18a/litan/OFED-1.5.3-rc5/RPMS/sl-release-5.5-1/x86_64/iscsi-initiator-utils-2.0-869.2.x86_64.rpm

The default IPoIB interface configuration is based on DHCP.
Note that a special patch for DHCP is required for supporting IPoIB.
The patch is available under docs/dhcp
If you do not have DHCP, you must change this configuration in the following
steps.
IPoIB interfaces configured successfully
Press any key to continue ...
Installation finished successfully.
Press any key to continue...

It seems that the IPoIB is not configured due to DHCP issues.

And the OFED tools did not work also:

[litan@tera05 OFED-1.5.3-rc5]$ sudo ibv_devinfo
Failed to get IB devices list: Function not implemented
[litan@tera05 OFED-1.5.3-rc5]$ sudo ibstat
sudo: ibstat: command not found






On Wed, Feb 23, 2011 at 4:14 AM, Vladimir Sokolovsky <
vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 02/23/2011 05:12 AM, Tanin wrote:
>
>>  Dear all,
>>
>> I have recompiled the kernel to 2.6.18, and try to install  OFED-1.5.2
>> instead.
>>
>> Now the kernel version is
>>
>> [litan@tera04 OFED-1.5.2]$ uname -a
>> Linux tera04.ultralight.org 2.6.18-prep #1 SMP Tue Feb 22 18:51:00 EST
>> 2011
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> I have the full log file in the attachment. Dose it related to that I try
>> many times to install different version of OFED? Thanks a million!
>>
>>
> OFED's backport system is rely on kernel version.
> So, changing kernel version changes the set of patches and headers to be
> used for the compilation.
> You should keep the kernel version as close as possible to the original
> version.
> E.g.:
> If you compile 2.6.18 from kernel.org then you can name it 2.6.18-prep
> But, if you recompile 2.6.18-164.el5, then you should name it
>  2.6.18-164.<any extension>.el5
>
> Regards,
> Vladimir
>



-- 
Best regards,

-----------------------------------------------------------------------------------------------
Li, Tan
PhD Candidate & Research Assistant,
Electrical Engineering,
Stony Brook University, NY

Personal Web Site: https://sites.google.com/site/homepagelitan/Home

Email: fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

--90e6ba53acf401908d049cf7bc9f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Oh, yes. Thanks so much!=A0After uninstall all libibverbs packages, th=
e OFED-1.5.3-rc5 successfully passed all building process:</div>
<div>=A0</div>
<div>=A0</div>
<div>Install iscsi-initiator-utils RPM:<br>Running rpm -iv=A0 /atlas/data18=
a/litan/OFED-1.5.3-rc5/RPMS/sl-release-5.5-1/x86_64/iscsi-initiator-utils-2=
.0-869.2.x86_64.rpm</div>
<div>=A0</div>
<div><font color=3D"#3333ff">The default IPoIB interface configuration is b=
ased on DHCP.<br>Note that a special patch for DHCP is required for support=
ing IPoIB.<br>The patch is available under docs/dhcp<br>If you do not have =
DHCP, you must change this configuration in the following steps.<br>
</font><font color=3D"#66ff99">IPoIB interfaces configured successfully<br>=
</font>Press any key to continue ...</div>
<div>Installation finished successfully.<br><font color=3D"#66cccc">Press a=
ny key to continue...<br></font></div>
<div><br>It seems=A0that the IPoIB is not configured due to DHCP issues.</d=
iv>
<div>=A0</div>
<div>And the OFED tools did not work also:</div>
<div>=A0</div>
<div>[litan@tera05 OFED-1.5.3-rc5]$ sudo ibv_devinfo<br>Failed to get IB de=
vices list: Function not implemented<br></div>
<div>[litan@tera05 OFED-1.5.3-rc5]$ sudo ibstat<br>sudo: ibstat: command no=
t found<br></div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div>=A0</div>
<div><br>=A0</div>
<div class=3D"gmail_quote">On Wed, Feb 23, 2011 at 4:14 AM, Vladimir Sokolo=
vsky <span dir=3D"ltr">&lt;<a href=3D"mailto:vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org">vlad@=
dev.mellanox.co.il</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On 02/23/2011 05:12 AM, Tanin wrote:<br></div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">=A0Dear all,<br><br>I have recompiled the kernel to 2.6.1=
8, and try to install =A0OFED-1.5.2<br>instead.<br><br>Now the kernel versi=
on is<br><br>[litan@tera04 OFED-1.5.2]$ uname -a<br>Linux <a href=3D"http:/=
/tera04.ultralight.org/" target=3D"_blank">tera04.ultralight.org</a> 2.6.18=
-prep #1 SMP Tue Feb 22 18:51:00 EST 2011<br>
x86_64 x86_64 x86_64 GNU/Linux<br><br><br></div>
<div class=3D"im">I have the full log file in the attachment. Dose it relat=
ed to that I try<br>many times to install different version of OFED? Thanks=
 a million!<br><br></div></blockquote><br>OFED&#39;s backport system is rel=
y on kernel version.<br>
So, changing kernel version changes the set of patches and headers to be us=
ed for the compilation.<br>You should keep the kernel version as close as p=
ossible to the original version.<br>E.g.:<br>If you compile 2.6.18 from <a =
href=3D"http://kernel.org/" target=3D"_blank">kernel.org</a> then you can n=
ame it 2.6.18-prep<br>
But, if you recompile 2.6.18-164.el5, then you should name it =A02.6.18-164=
.&lt;any extension&gt;.el5<br><br>Regards,<br><font color=3D"#888888">Vladi=
mir<br></font></blockquote></div><br><br clear=3D"all"><br>-- <br>
<div>Best regards,</div>
<div>=A0</div>
<div>----------------------------------------------------------------------=
-------------------------<br>Li, Tan<br>PhD=A0Candidate &amp; Research Assi=
stant, <br>Electrical Engineering, <br>Stony Brook University, NY<br><br>
Personal Web Site: <a href=3D"https://sites.google.com/site/homepagelitan/H=
ome" target=3D"_blank">https://sites.google.com/site/homepagelitan/Home</a>=
<br><br>Email: <a href=3D"mailto:fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">fan=
qielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a></div>
<br>

--90e6ba53acf401908d049cf7bc9f--

--===============1766152831==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============1766152831==--
