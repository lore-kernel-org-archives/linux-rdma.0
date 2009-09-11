From: Barry Mavin <Barry.Mavin@recital.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 19:04:40 +0530
Message-ID: <C6D04FC8.15676%Barry.Mavin@recital.com>
References: <f0e08f230909110620n3171c722v1f0624c5787122da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0289467090=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <f0e08f230909110620n3171c722v1f0624c5787122da@mail.gmail.com>
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
To: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, Keshetti Mahesh <keshetti.mahesh@gmail.com>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============0289467090==
Content-type: multipart/alternative;
	boundary="B_3335540680_7421720"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3335540680_7421720
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: quoted-printable

Thanks that resolved it

---
Regards
Barry Mavin
Recital Corporation





From: Hal Rosenstock <hal.rosenstock@gmail.com>
Date: Fri, 11 Sep 2009 09:20:58 -0400
To: Barry Mavin <Barry.Mavin@recital.com>
Cc: Keshetti Mahesh <keshetti.mahesh@gmail.com>, OFED mailing list
<linux-rdma@vger.kernel.org>, OFED mailing list
<general@lists.openfabrics.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
'ibcheckspeed' and 'ibcheckportspeed' to scripts



On Fri, Sep 11, 2009 at 2:13 AM, Barry Mavin <Barry.Mavin@recital.com>
wrote:
> When I start the subnet manager on redhat 5.3 with:
>=20
> # service opensm restart
>=20
> I get the following messages in the log file.
>=20
> Sep 11 11:41:46 252576 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0
> failed from port 0x0002c90300047b91 (ibas1 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252688 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0
> failed from port 0x0002c90300044c61 (ibds2 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252731 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0
> failed from port 0x0002c90300047b7d (ibds1 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
> Sep 11 11:41:46 252929 [43170940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
> 1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0
> failed from port 0x0002c90300047b75 (ibas2 HCA-1), sending
> IB_SA_MAD_STATUS_REQ_INVALID
>=20
> What is the cause of these?
=A0
=A0Those ports are unable to join some multicast group likely due to rate or
MTU mismatch with the group. What are their rates/MTUs ? See opensm man pag=
e
on partition configuration for the default partition for information on how
to change the MTU/rate.
=A0
-- Hal
=A0
>=20
> ---
> Regards
> Barry Mavin
> Recital Corporation
> Chairman and CEO
> Website: http://www.recital.com <http://www.recital.com/>
> MSN Messenger: Barry_Mavin@msn.com
> Skype: BarryMavin
> Direct line worldwide: +1 9785224139
>=20
>=20
>=20
>> > From: Keshetti Mahesh <keshetti.mahesh@gmail.com>
>> > Date: Fri, 11 Sep 2009 11:16:44 +0530
>> > To: Barry Mavin <Barry.Mavin@recital.com>
>> > Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list
>> > <general@lists.openfabrics.org>
>> > Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Ad=
d
>> > 'ibcheckspeed' and 'ibcheckportspeed' to scripts
>> >
>>> >> # ibtracert 10.10.10.1 10.10.10.3
>> >
>> > ibtracert only supports source/destination addresses to be specified
>> > in LID/GUID format. See man page of ibtracert.
>> >
>> > -
>> > Keshetti Mahesh
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html




--B_3335540680_7421720
Content-type: text/html;
	charset="ISO-8859-1"
Content-transfer-encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add &nbsp=
;'ibcheckspeed' and 'ibcheckportspeed' to scripts</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:11pt=
'>Thanks that resolved it<BR>
<BR>
---<BR>
Regards<BR>
Barry Mavin<BR>
Recital Corporation<BR>
<BR>
<BR>
<BR>
<BR>
<HR ALIGN=3DCENTER SIZE=3D"3" WIDTH=3D"95%"><B>From: </B>Hal Rosenstock &lt;<a hr=
ef=3D"hal.rosenstock@gmail.com">hal.rosenstock@gmail.com</a>&gt;<BR>
<B>Date: </B>Fri, 11 Sep 2009 09:20:58 -0400<BR>
<B>To: </B>Barry Mavin &lt;<a href=3D"Barry.Mavin@recital.com">Barry.Mavin@re=
cital.com</a>&gt;<BR>
<B>Cc: </B>Keshetti Mahesh &lt;<a href=3D"keshetti.mahesh@gmail.com">keshetti=
.mahesh@gmail.com</a>&gt;, OFED mailing list &lt;<a href=3D"linux-rdma@vger.ke=
rnel.org">linux-rdma@vger.kernel.org</a>&gt;, OFED mailing list &lt;<a href=3D=
"general@lists.openfabrics.org">general@lists.openfabrics.org</a>&gt;<BR>
<B>Subject: </B>Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: =
Add &nbsp;'ibcheckspeed' and 'ibcheckportspeed' to scripts<BR>
<BR>
<BR>
<BR>
On Fri, Sep 11, 2009 at 2:13 AM, Barry Mavin &lt;<a href=3D"Barry.Mavin@recit=
al.com">Barry.Mavin@recital.com</a>&gt; wrote:<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><=
SPAN STYLE=3D'font-size:11pt'>When I start the subnet manager on redhat 5.3 wi=
th:<BR>
<BR>
# service opensm restart<BR>
<BR>
I get the following messages in the log file.<BR>
<BR>
Sep 11 11:41:46 252576 [4EF83940] 0x01 -&gt; __osm_mcmr_rcv_join_mgrp: ERR<=
BR>
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0<B=
R>
failed from port 0x0002c90300047b91 (ibas1 HCA-1), sending<BR>
IB_SA_MAD_STATUS_REQ_INVALID<BR>
Sep 11 11:41:46 252688 [4EF83940] 0x01 -&gt; __osm_mcmr_rcv_join_mgrp: ERR<=
BR>
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0<B=
R>
failed from port 0x0002c90300044c61 (ibds2 HCA-1), sending<BR>
IB_SA_MAD_STATUS_REQ_INVALID<BR>
Sep 11 11:41:46 252731 [4EF83940] 0x01 -&gt; __osm_mcmr_rcv_join_mgrp: ERR<=
BR>
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0<B=
R>
failed from port 0x0002c90300047b7d (ibds1 HCA-1), sending<BR>
IB_SA_MAD_STATUS_REQ_INVALID<BR>
Sep 11 11:41:46 252929 [43170940] 0x01 -&gt; __osm_mcmr_rcv_join_mgrp: ERR<=
BR>
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState =3D 0<B=
R>
failed from port 0x0002c90300047b75 (ibas2 HCA-1), sending<BR>
IB_SA_MAD_STATUS_REQ_INVALID<BR>
<BR>
What is the cause of these?<BR>
</SPAN></FONT></BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial">=
<SPAN STYLE=3D'font-size:11pt'>=A0<BR>
=A0Those ports are unable to join some multicast group likely due to rate or =
MTU mismatch with the group. What are their rates/MTUs ? See opensm man page=
 on partition configuration for the default partition for information on how=
 to change the MTU/rate.<BR>
=A0<BR>
-- Hal<BR>
=A0<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><=
SPAN STYLE=3D'font-size:11pt'><BR>
---<BR>
Regards<BR>
Barry Mavin<BR>
Recital Corporation<BR>
Chairman and CEO<BR>
Website: <a href=3D"http://www.recital.com">http://www.recital.com</a> &lt;<a=
 href=3D"http://www.recital.com/">http://www.recital.com/</a>&gt; <BR>
MSN Messenger: <a href=3D"Barry_Mavin@msn.com">Barry_Mavin@msn.com</a><BR>
Skype: BarryMavin<BR>
Direct line worldwide: +1 9785224139<BR>
<BR>
<BR>
<BR>
&gt; From: Keshetti Mahesh &lt;<a href=3D"keshetti.mahesh@gmail.com">keshetti=
.mahesh@gmail.com</a>&gt;<BR>
&gt; Date: Fri, 11 Sep 2009 11:16:44 +0530<BR>
&gt; To: Barry Mavin &lt;<a href=3D"Barry.Mavin@recital.com">Barry.Mavin@reci=
tal.com</a>&gt;<BR>
&gt; Cc: OFED mailing list &lt;<a href=3D"linux-rdma@vger.kernel.org">linux-r=
dma@vger.kernel.org</a>&gt;, OFED mailing list<BR>
&gt; &lt;<a href=3D"general@lists.openfabrics.org">general@lists.openfabrics.=
org</a>&gt;<BR>
&gt; Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Ad=
d<BR>
&gt; 'ibcheckspeed' and 'ibcheckportspeed' to scripts<BR>
&gt;<BR>
&gt;&gt; # ibtracert 10.10.10.1 10.10.10.3<BR>
&gt;<BR>
&gt; ibtracert only supports source/destination addresses to be specified<B=
R>
&gt; in LID/GUID format. See man page of ibtracert.<BR>
&gt;<BR>
&gt; -<BR>
&gt; Keshetti Mahesh<BR>
<BR>
--<BR>
To unsubscribe from this list: send the line &quot;unsubscribe linux-rdma&q=
uot; in<BR>
the body of a message to <a href=3D"majordomo@vger.kernel.org">majordomo@vger=
.kernel.org</a><BR>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.html=
">http://vger.kernel.org/majordomo-info.html</a><BR>
</SPAN></FONT></BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial">=
<SPAN STYLE=3D'font-size:11pt'><BR>
<BR>
</SPAN></FONT>
</BODY>
</HTML>


--B_3335540680_7421720--


--===============0289467090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0289467090==--
