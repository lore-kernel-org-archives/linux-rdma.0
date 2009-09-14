From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Mon, 14 Sep 2009 09:19:06 -0400
Message-ID: <f0e08f230909140619o342758cdq79e00cc04071a33c@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
	<829ded920909132320m7e33d79cx959fba7e6addb513@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0201223874=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <829ded920909132320m7e33d79cx959fba7e6addb513@mail.gmail.com>
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

--===============0201223874==
Content-Type: multipart/alternative; boundary=00151747afa4a9e7e80473898257

--00151747afa4a9e7e80473898257
Content-Type: text/plain; charset=UTF-8

On Mon, Sep 14, 2009 at 2:20 AM, Keshetti Mahesh
<keshetti.mahesh@gmail.com>wrote:

> I have a small question. If there are all 5 Gbps (maximum supported
> speed) ports
> except one with 10 Gbps in a subnet then what is the expected behavior
> of OpenSM
> while setting active link speed ?


It depends on the peer port and the link between them.


> Does OpenSM force the port with 10
> Gbps to operate
> at 5 Gbps or not ?
>

SM (including OpenSM) sets PortInfo enabled components based on peer ports'
supported components and link negotiation determines the active components.

So in the case where one port supports 10 Gbps speed and it's peer port only
supports 5, the SM sets LinkSpeedEnabled components on the peer ports to 5
Gbps (encoded as 3). In the case where the peer port supports 10 Gbps, it is
set to 10 Gbps (encoded as 5 or 7 depending on what is supported). The link
then negotiates to one of the enabled speeds and sets LinkSpeedActive
accoridingly.

-- Hal



>
> --
> Keshetti Mahesh
>
> On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2@llnl.gov> wrote:
>  > Also, iblinkinfo will report links which it finds capable of either
> faster or wider operation.  iblinkinfo checks both ends of the link as Hal
> mentions.  It reports this with output like.
> >
> > Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
> > ...
> >           7    8[  ] ==( 4X 2.5 Gbps Active/  LinkUp)==>       8   12[  ]
> "MT47396 Infiniscale-III Mellanox Technologies" ( Could be 5.0 Gbps)
> > ...
> >
> > Also the portstatus console command in OpenSM will report links which are
> running at "reduced speed or width".  Although this does not check the
> remote port.
> >
> > OpenSM $ help portstatus
> > portstatus [ca|switch|router]
> > summarize port status
> >   [ca|switch|router] -- limit the results to the node type specified
> > OpenSM $ portstatus
> > "ALL" port status:
> >   115 port(s) scanned on 9 nodes in 26 us
> >   85 down
> >   30 active
> >   32 at 4X
> >   22 at 2.5 Gbps
> >   8 at 5.0 Gbps
> >   2 at 10.0 Gbps
> >
> > Possible issues:
> >   2 disabled
> >      0x0008f10400411b18 5 (ISR9024D Voltaire)
> >      0x0005ad0000092106 13 (Cisco Switch SFS7000D)
> >   6 with reduced speed
> >      0x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
> >      0x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
> >      0x0005ad0000092106 21 (Cisco Switch SFS7000D)
> >      0x0005ad0000092106 20 (Cisco Switch SFS7000D)
> >      0x0005ad0000092106 9 (Cisco Switch SFS7000D)
> >      0x0005ad0000092106 8 (Cisco Switch SFS7000D)
> >
> >
> > Ira
> >
> > On Thu, 10 Sep 2009 09:23:35 -0400
> > Hal Rosenstock <hal.rosenstock@gmail.com> wrote:
> >
> >> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
> >> <keshetti.mahesh@gmail.com>wrote:
> >>
> >> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
> >> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
> >> > Reports error/warning messages if the LinkSpeedActive is configured as
> >> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
> >> >
> >>
> >> ibportstate checks for more than this in terms of speed (and width)
> >> anomalies.
> >>
> >> Would it be better for these scripts to use that tool now ?
> Alternatively,
> >> the additional speed/width anomaly checks could be implemented in these
> >> scripts but it does involve checking the peer port so there's a little
> more
> >> to it.
> >>
> >> -- Hal
> >>
> >>
> >> >
> >> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
> >> > ---
> >> >  infiniband-diags/scripts/ibcheckportspeed.in |  146
> >> > ++++++++++++++++++++++++++
> >> >  infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
> >> >  infiniband-diags/scripts/ibcheckspeed.in     |  135
> >> > ++++++++++++++++++++++++
> >> >  3 files changed, 282 insertions(+), 1 deletions(-)
> >> >  create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
> >> >  create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
> >> >
> >> <snip...>
> >>
> >
> >
> > --
> > Ira Weiny
> > Math Programmer/Computer Scientist
> > Lawrence Livermore National Lab
> > 925-423-8008
> > weiny2@llnl.gov
> >
>

--00151747afa4a9e7e80473898257
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Mon, Sep 14, 2009 at 2:20 AM, Keshetti Mahesh=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:keshetti.mahesh@gmail.com">keshett=
i.mahesh@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">I have a small question. If ther=
e are all 5 Gbps (maximum supported<br>speed) ports<br>except one with 10 G=
bps in a subnet then what is the expected behavior<br>
of OpenSM<br>while setting active link speed ? </blockquote>
<div>=C2=A0</div>
<div>It depends on the peer port and the link between them.</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Does OpenSM force the port with =
10<br>Gbps to operate<br>at 5 Gbps or not ?<br></blockquote>
<div>=C2=A0</div>
<div>SM (including OpenSM)=C2=A0sets=C2=A0PortInfo enabled components based=
 on peer ports&#39; supported=C2=A0components and link negotiation=C2=A0det=
ermines the active components.</div>
<div>=C2=A0</div>
<div>So in the case where=C2=A0one port=C2=A0supports 10=C2=A0Gbps=C2=A0spe=
ed and it&#39;s peer port only supports 5, the SM sets=C2=A0LinkSpeedEnable=
d components on the peer ports to 5 Gbps (encoded as 3). In the case where =
the peer port supports 10 Gbps,=C2=A0it is set to 10 Gbps (encoded as 5 or =
7 depending on what is supported).=C2=A0The link then negotiates to one of =
the enabled speeds and sets LinkSpeedActive accoridingly.</div>

<div>=C2=A0</div>
<div>-- Hal</div>
<div>=C2=A0</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><font color=3D"#888888"><br>--<b=
r></font>
<div class=3D"im">Keshetti Mahesh<br><br>On Thu, Sep 10, 2009 at 9:32 PM, I=
ra Weiny &lt;<a href=3D"mailto:weiny2@llnl.gov">weiny2@llnl.gov</a>&gt; wro=
te:<br></div>
<div>
<div></div>
<div class=3D"h5">&gt; Also, iblinkinfo will report links which it finds ca=
pable of either faster or wider operation. =C2=A0iblinkinfo checks both end=
s of the link as Hal mentions. =C2=A0It reports this with output like.<br>&=
gt;<br>
&gt; Switch 0x0005ad0000092106 Cisco Switch SFS7000D:<br>&gt; ...<br>&gt; =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A08[ =C2=A0] =3D=3D( 4X 2.5=
 Gbps Active/ =C2=A0LinkUp)=3D=3D&gt; =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 12[ =C2=
=A0] &quot;MT47396 Infiniscale-III Mellanox Technologies&quot; ( Could be 5=
.0 Gbps)<br>
&gt; ...<br>&gt;<br>&gt; Also the portstatus console command in OpenSM will=
 report links which are running at &quot;reduced speed or width&quot;. =C2=
=A0Although this does not check the remote port.<br>&gt;<br>&gt; OpenSM $ h=
elp portstatus<br>
&gt; portstatus [ca|switch|router]<br>&gt; summarize port status<br>&gt; =
=C2=A0 [ca|switch|router] -- limit the results to the node type specified<b=
r>&gt; OpenSM $ portstatus<br>&gt; &quot;ALL&quot; port status:<br>&gt; =C2=
=A0 115 port(s) scanned on 9 nodes in 26 us<br>
&gt; =C2=A0 85 down<br>&gt; =C2=A0 30 active<br>&gt; =C2=A0 32 at 4X<br>&gt=
; =C2=A0 22 at 2.5 Gbps<br>&gt; =C2=A0 8 at 5.0 Gbps<br>&gt; =C2=A0 2 at 10=
.0 Gbps<br>&gt;<br>&gt; Possible issues:<br>&gt; =C2=A0 2 disabled<br>&gt; =
=C2=A0 =C2=A0 =C2=A00x0008f10400411b18 5 (ISR9024D Voltaire)<br>
&gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 13 (Cisco Switch SFS7000D)<br>&=
gt; =C2=A0 6 with reduced speed<br>&gt; =C2=A0 =C2=A0 =C2=A00x0008f10500200=
220 33 (Voltaire 4036 - 36 QDR ports switch)<br>&gt; =C2=A0 =C2=A0 =C2=A00x=
0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)<br>
&gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 21 (Cisco Switch SFS7000D)<br>&=
gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 20 (Cisco Switch SFS7000D)<br>&g=
t; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 9 (Cisco Switch SFS7000D)<br>&gt;=
 =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 8 (Cisco Switch SFS7000D)<br>
&gt;<br>&gt;<br>&gt; Ira<br>&gt;<br>&gt; On Thu, 10 Sep 2009 09:23:35 -0400=
<br>&gt; Hal Rosenstock &lt;<a href=3D"mailto:hal.rosenstock@gmail.com">hal=
.rosenstock@gmail.com</a>&gt; wrote:<br>&gt;<br>&gt;&gt; On Thu, Sep 10, 20=
09 at 9:02 AM, Keshetti Mahesh<br>
&gt;&gt; &lt;<a href=3D"mailto:keshetti.mahesh@gmail.com">keshetti.mahesh@g=
mail.com</a>&gt;wrote:<br>&gt;&gt;<br>&gt;&gt; &gt; Added &#39;ibcheckspeed=
&#39; and &#39;ibcheckportspeed&#39;: Similar to<br>&gt;&gt; &gt; &#39;ibch=
eckwidth/ibcheckportwidth&#39; in functionality and implementation.<br>
&gt;&gt; &gt; Reports error/warning messages if the LinkSpeedActive is conf=
igured as<br>&gt;&gt; &gt; 2.5 Gbps when the LinkSpeedSupported is more tha=
n 2.5 Gbps.<br>&gt;&gt; &gt;<br>&gt;&gt;<br>&gt;&gt; ibportstate checks for=
 more than this in terms of speed (and width)<br>
&gt;&gt; anomalies.<br>&gt;&gt;<br>&gt;&gt; Would it be better for these sc=
ripts to use that tool now ? Alternatively,<br>&gt;&gt; the additional spee=
d/width anomaly checks could be implemented in these<br>&gt;&gt; scripts bu=
t it does involve checking the peer port so there&#39;s a little more<br>
&gt;&gt; to it.<br>&gt;&gt;<br>&gt;&gt; -- Hal<br>&gt;&gt;<br>&gt;&gt;<br>&=
gt;&gt; &gt;<br>&gt;&gt; &gt; Signed-off-by: Keshetti Mahesh &lt; <a href=
=3D"mailto:keshetti.mahesh@gmail.com">keshetti.mahesh@gmail.com</a>&gt;<br>
&gt;&gt; &gt; ---<br>&gt;&gt; &gt; =C2=A0infiniband-diags/scripts/<a href=
=3D"http://ibcheckportspeed.in/" target=3D"_blank">ibcheckportspeed.in</a> =
| =C2=A0146<br>&gt;&gt; &gt; ++++++++++++++++++++++++++<br>&gt;&gt; &gt; =
=C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckportwidth.in/" targ=
et=3D"_blank">ibcheckportwidth.in</a> | =C2=A0 =C2=A02 +-<br>
&gt;&gt; &gt; =C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckspeed=
.in/" target=3D"_blank">ibcheckspeed.in</a> =C2=A0 =C2=A0 | =C2=A0135<br>&g=
t;&gt; &gt; ++++++++++++++++++++++++<br>&gt;&gt; &gt; =C2=A03 files changed=
, 282 insertions(+), 1 deletions(-)<br>
&gt;&gt; &gt; =C2=A0create mode 100644 infiniband-diags/scripts/<a href=3D"=
http://ibcheckportspeed.in/" target=3D"_blank">ibcheckportspeed.in</a><br>&=
gt;&gt; &gt; =C2=A0create mode 100644 infiniband-diags/scripts/<a href=3D"h=
ttp://ibcheckspeed.in/" target=3D"_blank">ibcheckspeed.in</a><br>
&gt;&gt; &gt;<br>&gt;&gt; &lt;snip...&gt;<br>&gt;&gt;<br>&gt;<br>&gt;<br>&g=
t; --<br>&gt; Ira Weiny<br>&gt; Math Programmer/Computer Scientist<br>&gt; =
Lawrence Livermore National Lab<br>&gt; 925-423-8008<br>&gt; <a href=3D"mai=
lto:weiny2@llnl.gov">weiny2@llnl.gov</a><br>
&gt;<br></div></div></blockquote></div><br>

--00151747afa4a9e7e80473898257--

--===============0201223874==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0201223874==--
