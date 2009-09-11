From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 09:20:58 -0400
Message-ID: <f0e08f230909110620n3171c722v1f0624c5787122da@mail.gmail.com>
References: <829ded920909102246o18b25caagf84bfe352f699a82@mail.gmail.com>
	<C6CFE86C.15626%Barry.Mavin@recital.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0638101327=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <C6CFE86C.15626%Barry.Mavin@recital.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Mime-version: 1.0
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Barry Mavin <Barry.Mavin@recital.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, Keshetti Mahesh <keshetti.mahesh@gmail.com>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

--===============0638101327==
Content-Type: multipart/alternative; boundary=0016e65c8d32d4694c04734d2f20

--0016e65c8d32d4694c04734d2f20
Content-Type: text/plain; charset=UTF-8

On Fri, Sep 11, 2009 at 2:13 AM, Barry Mavin <Barry.Mavin@recital.com>wrote:

> When I start the subnet manager on redhat 5.3 with:
>
> # service opensm restart
>
> I get the following messages in the log file.
>
> Sep 11 11:41:46 252576 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
> failed from port 0x0002c90300047b91 (ibas1 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252688 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
> failed from port 0x0002c90300044c61 (ibds2 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252731 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
> failed from port 0x0002c90300047b7d (ibds1 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252929 [43170940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
> failed from port 0x0002c90300047b75 (ibas2 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
>
> What is the cause of these?
>

 Those ports are unable to join some multicast group likely due to rate or
MTU mismatch with the group. What are their rates/MTUs ? See opensm man page
on partition configuration for the default partition for information on how
to change the MTU/rate.

-- Hal


>
> ---
> Regards
> Barry Mavin
> Recital Corporation
> Chairman and CEO
> Website: http://www.recital.com
> MSN Messenger: Barry_Mavin@msn.com
> Skype: BarryMavin
> Direct line worldwide: +1 9785224139
>
>
>
> > From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
> > Date: Fri, 11 Sep 2009 11:16:44 +0530
> > To: Barry Mavin <Barry.Mavin@recital.com>
> > Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list
> > <general@lists.openfabrics.org>
> > Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
> > 'ibcheckspeed' and 'ibcheckportspeed' to scripts
> >
>  >> # ibtracert 10.10.10.1 10.10.10.3
> >
> > ibtracert only supports source/destination addresses to be specified
> > in LID/GUID format. See man page of ibtracert.
> >
> > -
> > Keshetti Mahesh
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--0016e65c8d32d4694c04734d2f20
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Fri, Sep 11, 2009 at 2:13 AM, Barry Mavin <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:Barry.Mavin@recital.com" target=3D"_bl=
ank">Barry.Mavin@recital.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">When I start the subnet manager =
on redhat 5.3 with:<br><br># service opensm restart<br><br>I get the follow=
ing messages in the log file.<br>
<br>Sep 11 11:41:46 252576 [4EF83940] 0x01 -&gt; __osm_mcmr_rcv_join_mgrp: =
ERR<br>1B12: __validate_more_comp_fields, __validate_port_caps, or JoinStat=
e =3D 0<br>failed from port 0x0002c90300047b91 (ibas1 HCA-1), sending<br>
IB_SA_MAD_STATUS_REQ_INVALID<br>Sep 11 11:41:46 252688 [4EF83940] 0x01 -&gt=
; __osm_mcmr_rcv_join_mgrp: ERR<br>1B12: __validate_more_comp_fields, __val=
idate_port_caps, or JoinState =3D 0<br>failed from port 0x0002c90300044c61 =
(ibds2 HCA-1), sending<br>
IB_SA_MAD_STATUS_REQ_INVALID<br>Sep 11 11:41:46 252731 [4EF83940] 0x01 -&gt=
; __osm_mcmr_rcv_join_mgrp: ERR<br>1B12: __validate_more_comp_fields, __val=
idate_port_caps, or JoinState =3D 0<br>failed from port 0x0002c90300047b7d =
(ibds1 HCA-1), sending<br>
IB_SA_MAD_STATUS_REQ_INVALID<br>Sep 11 11:41:46 252929 [43170940] 0x01 -&gt=
; __osm_mcmr_rcv_join_mgrp: ERR<br>1B12: __validate_more_comp_fields, __val=
idate_port_caps, or JoinState =3D 0<br>failed from port 0x0002c90300047b75 =
(ibas2 HCA-1), sending<br>
IB_SA_MAD_STATUS_REQ_INVALID<br><br>What is the cause of these?<br></blockq=
uote>
<div>=C2=A0</div>
<div>=C2=A0Those ports are unable to join some multicast group likely due t=
o rate or MTU mismatch with the group. What are their rates/MTUs ? See open=
sm man page on partition configuration for the default partition for inform=
ation on how to change the MTU/rate.</div>

<div>=C2=A0</div>
<div>-- Hal</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span></span>
<div><br>---<br>Regards<br>Barry Mavin<br>Recital Corporation<br></div>Chai=
rman and CEO<br>Website: <a href=3D"http://www.recital.com/" target=3D"_bla=
nk">http://www.recital.com</a><br>MSN Messenger: <a href=3D"mailto:Barry_Ma=
vin@msn.com" target=3D"_blank">Barry_Mavin@msn.com</a><br>
Skype: BarryMavin<br>Direct line worldwide: +1 9785224139<br>
<div><br><br><br>&gt; From: Keshetti Mahesh &lt;<a href=3D"mailto:keshetti.=
mahesh@gmail.com" target=3D"_blank">keshetti.mahesh@gmail.com</a>&gt;<br></=
div>&gt; Date: Fri, 11 Sep 2009 11:16:44 +0530<br>&gt; To: Barry Mavin &lt;=
<a href=3D"mailto:Barry.Mavin@recital.com" target=3D"_blank">Barry.Mavin@re=
cital.com</a>&gt;<br>

<div>&gt; Cc: OFED mailing list &lt;<a href=3D"mailto:linux-rdma@vger.kerne=
l.org" target=3D"_blank">linux-rdma@vger.kernel.org</a>&gt;, OFED mailing l=
ist<br>&gt; &lt;<a href=3D"mailto:general@lists.openfabrics.org" target=3D"=
_blank">general@lists.openfabrics.org</a>&gt;<br>
&gt; Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Ad=
d<br>&gt; &#39;ibcheckspeed&#39; and &#39;ibcheckportspeed&#39; to scripts<=
br>&gt;<br></div>
<div>
<div></div>
<div>&gt;&gt; # ibtracert 10.10.10.1 10.10.10.3<br>&gt;<br>&gt; ibtracert o=
nly supports source/destination addresses to be specified<br>&gt; in LID/GU=
ID format. See man page of ibtracert.<br>&gt;<br>&gt; -<br>&gt; Keshetti Ma=
hesh<br>
<br>--<br>To unsubscribe from this list: send the line &quot;unsubscribe li=
nux-rdma&quot; in<br>the body of a message to <a href=3D"mailto:majordomo@v=
ger.kernel.org" target=3D"_blank">majordomo@vger.kernel.org</a><br>More maj=
ordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-info.html"=
 target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</div></div></blockquote></div><br>

--0016e65c8d32d4694c04734d2f20--

--===============0638101327==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0638101327==--
