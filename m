From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Thu, 10 Sep 2009 09:23:35 -0400
Message-ID: <f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0578001608=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
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
To: Keshetti Mahesh <keshetti.mahesh@gmail.com>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

--===============0578001608==
Content-Type: multipart/alternative; boundary=0016e65b62ce5496990473391be6

--0016e65b62ce5496990473391be6
Content-Type: text/plain; charset=UTF-8

On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
<keshetti.mahesh@gmail.com>wrote:

> Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
> 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
> Reports error/warning messages if the LinkSpeedActive is configured as
> 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
>

ibportstate checks for more than this in terms of speed (and width)
anomalies.

Would it be better for these scripts to use that tool now ? Alternatively,
the additional speed/width anomaly checks could be implemented in these
scripts but it does involve checking the peer port so there's a little more
to it.

-- Hal


>
> Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
> ---
>  infiniband-diags/scripts/ibcheckportspeed.in |  146
> ++++++++++++++++++++++++++
>  infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
>  infiniband-diags/scripts/ibcheckspeed.in     |  135
> ++++++++++++++++++++++++
>  3 files changed, 282 insertions(+), 1 deletions(-)
>  create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
>  create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
>
<snip...>

--0016e65b62ce5496990473391be6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:keshetti.mahesh@gmail.com" target=
=3D"_blank">keshetti.mahesh@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Added &#39;ibcheckspeed&#39; and=
 &#39;ibcheckportspeed&#39;: Similar to<br>&#39;ibcheckwidth/ibcheckportwid=
th&#39; in functionality and implementation.<br>
Reports error/warning messages if the LinkSpeedActive is configured as<br>2=
.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.<br></blockquote>
<div>=C2=A0</div>
<div>ibportstate checks for more than this in terms of speed (and width) an=
omalies.</div>
<div>=C2=A0</div>
<div>Would it be better for these scripts to use that tool now ? Alternativ=
ely, the additional speed/width anomaly checks could be implemented in thes=
e scripts but it does involve checking the peer port so there&#39;s a littl=
e more to it.</div>

<div>=C2=A0</div>
<div>-- Hal</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span></span><br>Signed-off-by: =
Keshetti Mahesh &lt; <a href=3D"mailto:keshetti.mahesh@gmail.com" target=3D=
"_blank">keshetti.mahesh@gmail.com</a>&gt;<br>
---<br>=C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckportspeed.in=
/" target=3D"_blank">ibcheckportspeed.in</a> | =C2=A0146 ++++++++++++++++++=
++++++++<br>=C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckportwid=
th.in/" target=3D"_blank">ibcheckportwidth.in</a> | =C2=A0 =C2=A02 +-<br>
=C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckspeed.in/" target=
=3D"_blank">ibcheckspeed.in</a> =C2=A0 =C2=A0 | =C2=A0135 +++++++++++++++++=
+++++++<br>=C2=A03 files changed, 282 insertions(+), 1 deletions(-)<br>=C2=
=A0create mode 100644 infiniband-diags/scripts/<a href=3D"http://ibcheckpor=
tspeed.in/" target=3D"_blank">ibcheckportspeed.in</a><br>
=C2=A0create mode 100644 infiniband-diags/scripts/<a href=3D"http://ibcheck=
speed.in/" target=3D"_blank">ibcheckspeed.in</a><br></blockquote>
<div>&lt;snip...&gt;</div></div>

--0016e65b62ce5496990473391be6--

--===============0578001608==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0578001608==--
