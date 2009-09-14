From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
	'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Mon, 14 Sep 2009 14:51:03 -0400
Message-ID: <f0e08f230909141151g6e0df176tcb9bca2c040c06c7@mail.gmail.com>
References: <829ded920909100602h78614ac0jd4eb1ee8d7a3779b@mail.gmail.com>
	<f0e08f230909100623k75d69e52m965628c3305f2125@mail.gmail.com>
	<20090910090213.6888b7d5.weiny2@llnl.gov>
	<829ded920909102102o49f037cbhc53a849f1fcfdaa4@mail.gmail.com>
	<20090914110221.7e33b737.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1932228620=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <20090914110221.7e33b737.weiny2@llnl.gov>
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
To: Ira Weiny <weiny2@llnl.gov>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, Keshetti Mahesh <keshetti.mahesh@gmail.com>, OFED mailing list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

--===============1932228620==
Content-Type: multipart/alternative; boundary=0016e65c7bc4d86f9104738e2514

--0016e65c7bc4d86f9104738e2514
Content-Type: text/plain; charset=UTF-8

On Mon, Sep 14, 2009 at 2:02 PM, Ira Weiny <weiny2@llnl.gov> wrote:

> On Fri, 11 Sep 2009 09:32:39 +0530
> Keshetti Mahesh <keshetti.mahesh@gmail.com> wrote:
>
> > My badness. I have not used 'iblinkinfo' before.
> > So, I guess there is no need for the above script. Apart from that, I
> feel
> > there should be a program/script which will first scan the fabric to find
> the
> > maximum common supported width/speed and then report the warning messages
> > of the links/ports which are configured with active width/speed less
> > than the found
> > value. Is there any tool already exists which does the same ?
>
> Not that I know of.
>

ibportstate does this but is on a per port basis. This could be readily
scripted (ad hoc or in tree) for this purpose.

-- Hal

<snip...>



>
> While I could see the usefulness of such a tool in some environments I have
> gone down the path of making the OFED diags more generic and then writing
> some wrappers for our local needs.  Currently I have a script which runs
> iblinkinfo with the "-l" option and then returns total number of links at
> SDR, DDR, QDR as well as the number of links at 1, 4, or 12X.  I then leave
> it up to the sys admin to know if their cluster is homo or heterogenious and
> how many links should be at what speeds.  They can then use iblinkinfo to
> identify which links are incorrect for their particular installation.
>
> Ira
>
> >
> > -
> > Keshetti Mahesh
> >
> > On Thu, Sep 10, 2009 at 9:32 PM, Ira Weiny <weiny2@llnl.gov> wrote:
> > > Also, iblinkinfo will report links which it finds capable of either
> faster or wider operation.  iblinkinfo checks both ends of the link as Hal
> mentions.  It reports this with output like.
> > >
> > > Switch 0x0005ad0000092106 Cisco Switch SFS7000D:
> > > ...
> > >           7    8[  ] ==( 4X 2.5 Gbps Active/  LinkUp)==>       8   12[
>  ] "MT47396 Infiniscale-III Mellanox Technologies" ( Could be 5.0 Gbps)
> > > ...
> > >
> > > Also the portstatus console command in OpenSM will report links which
> are running at "reduced speed or width".  Although this does not check the
> remote port.
> > >
> > > OpenSM $ help portstatus
> > > portstatus [ca|switch|router]
> > > summarize port status
> > >   [ca|switch|router] -- limit the results to the node type specified
> > > OpenSM $ portstatus
> > > "ALL" port status:
> > >   115 port(s) scanned on 9 nodes in 26 us
> > >   85 down
> > >   30 active
> > >   32 at 4X
> > >   22 at 2.5 Gbps
> > >   8 at 5.0 Gbps
> > >   2 at 10.0 Gbps
> > >
> > > Possible issues:
> > >   2 disabled
> > >      0x0008f10400411b18 5 (ISR9024D Voltaire)
> > >      0x0005ad0000092106 13 (Cisco Switch SFS7000D)
> > >   6 with reduced speed
> > >      0x0008f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)
> > >      0x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)
> > >      0x0005ad0000092106 21 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 20 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 9 (Cisco Switch SFS7000D)
> > >      0x0005ad0000092106 8 (Cisco Switch SFS7000D)
> > >
> > >
> > > Ira
> > >
> > > On Thu, 10 Sep 2009 09:23:35 -0400
> > > Hal Rosenstock <hal.rosenstock@gmail.com> wrote:
> > >
> > >> On Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh
> > >> <keshetti.mahesh@gmail.com>wrote:
> > >>
> > >> > Added 'ibcheckspeed' and 'ibcheckportspeed': Similar to
> > >> > 'ibcheckwidth/ibcheckportwidth' in functionality and implementation.
> > >> > Reports error/warning messages if the LinkSpeedActive is configured
> as
> > >> > 2.5 Gbps when the LinkSpeedSupported is more than 2.5 Gbps.
> > >> >
> > >>
> > >> ibportstate checks for more than this in terms of speed (and width)
> > >> anomalies.
> > >>
> > >> Would it be better for these scripts to use that tool now ?
> Alternatively,
> > >> the additional speed/width anomaly checks could be implemented in
> these
> > >> scripts but it does involve checking the peer port so there's a little
> more
> > >> to it.
> > >>
> > >> -- Hal
> > >>
> > >>
> > >> >
> > >> > Signed-off-by: Keshetti Mahesh < keshetti.mahesh@gmail.com>
> > >> > ---
> > >> >  infiniband-diags/scripts/ibcheckportspeed.in |  146
> > >> > ++++++++++++++++++++++++++
> > >> >  infiniband-diags/scripts/ibcheckportwidth.in |    2 +-
> > >> >  infiniband-diags/scripts/ibcheckspeed.in     |  135
> > >> > ++++++++++++++++++++++++
> > >> >  3 files changed, 282 insertions(+), 1 deletions(-)
> > >> >  create mode 100644 infiniband-diags/scripts/ibcheckportspeed.in
> > >> >  create mode 100644 infiniband-diags/scripts/ibcheckspeed.in
> > >> >
> > >> <snip...>
> > >>
> > >
> > >
> > > --
> > > Ira Weiny
> > > Math Programmer/Computer Scientist
> > > Lawrence Livermore National Lab
> > > 925-423-8008
> > > weiny2@llnl.gov
> > >
>
>
> --
>  Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2@llnl.gov
>

--0016e65c7bc4d86f9104738e2514
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Mon, Sep 14, 2009 at 2:02 PM, Ira Weiny <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:weiny2@llnl.gov" target=3D"_blank">weiny=
2@llnl.gov</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">On Fri, 11 Sep 2009 09:32:39 +05=
30<br>
<div>Keshetti Mahesh &lt;<a href=3D"mailto:keshetti.mahesh@gmail.com" targe=
t=3D"_blank">keshetti.mahesh@gmail.com</a>&gt; wrote:<br><br></div>
<div>&gt; My badness. I have not used &#39;iblinkinfo&#39; before.<br>&gt; =
So, I guess there is no need for the above script. Apart from that, I feel<=
br>&gt; there should be a program/script which will first scan the fabric t=
o find the<br>
&gt; maximum common supported width/speed and then report the warning messa=
ges<br>&gt; of the links/ports which are configured with active width/speed=
 less<br>&gt; than the found<br>&gt; value. Is there any tool already exist=
s which does the same ?<br>
<br></div>Not that I know of.<br></blockquote>
<div>=C2=A0</div>
<div>ibportstate does this but is on a per port basis. This could be readil=
y scripted (ad hoc or in tree) for this purpose.</div>
<div>=C2=A0</div>
<div>-- Hal</div>
<div>=C2=A0</div>
<div>&lt;snip...&gt;</div>
<div>=C2=A0</div>
<div>=C2=A0</div>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><br>While I could see the useful=
ness of such a tool in some environments I have gone down the path of makin=
g the OFED diags more generic and then writing some wrappers for our local =
needs. =C2=A0Currently I have a script which runs iblinkinfo with the &quot=
;-l&quot; option and then returns total number of links at SDR, DDR, QDR as=
 well as the number of links at 1, 4, or 12X. =C2=A0I then leave it up to t=
he sys admin to know if their cluster is homo or heterogenious and how many=
 links should be at what speeds. =C2=A0They can then use iblinkinfo to iden=
tify which links are incorrect for their particular installation.<br>
<font color=3D"#888888"><br>Ira<br></font>
<div>
<div></div>
<div><br>&gt;<br>&gt; -<br>&gt; Keshetti Mahesh<br>&gt;<br>&gt; On Thu, Sep=
 10, 2009 at 9:32 PM, Ira Weiny &lt;<a href=3D"mailto:weiny2@llnl.gov" targ=
et=3D"_blank">weiny2@llnl.gov</a>&gt; wrote:<br>&gt; &gt; Also, iblinkinfo =
will report links which it finds capable of either faster or wider operatio=
n. =C2=A0iblinkinfo checks both ends of the link as Hal mentions. =C2=A0It =
reports this with output like.<br>
&gt; &gt;<br>&gt; &gt; Switch 0x0005ad0000092106 Cisco Switch SFS7000D:<br>=
&gt; &gt; ...<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=
=A08[ =C2=A0] =3D=3D( 4X 2.5 Gbps Active/ =C2=A0LinkUp)=3D=3D&gt; =C2=A0 =
=C2=A0 =C2=A0 8 =C2=A0 12[ =C2=A0] &quot;MT47396 Infiniscale-III Mellanox T=
echnologies&quot; ( Could be 5.0 Gbps)<br>
&gt; &gt; ...<br>&gt; &gt;<br>&gt; &gt; Also the portstatus console command=
 in OpenSM will report links which are running at &quot;reduced speed or wi=
dth&quot;. =C2=A0Although this does not check the remote port.<br>&gt; &gt;=
<br>
&gt; &gt; OpenSM $ help portstatus<br>&gt; &gt; portstatus [ca|switch|route=
r]<br>&gt; &gt; summarize port status<br>&gt; &gt; =C2=A0 [ca|switch|router=
] -- limit the results to the node type specified<br>&gt; &gt; OpenSM $ por=
tstatus<br>
&gt; &gt; &quot;ALL&quot; port status:<br>&gt; &gt; =C2=A0 115 port(s) scan=
ned on 9 nodes in 26 us<br>&gt; &gt; =C2=A0 85 down<br>&gt; &gt; =C2=A0 30 =
active<br>&gt; &gt; =C2=A0 32 at 4X<br>&gt; &gt; =C2=A0 22 at 2.5 Gbps<br>&=
gt; &gt; =C2=A0 8 at 5.0 Gbps<br>
&gt; &gt; =C2=A0 2 at 10.0 Gbps<br>&gt; &gt;<br>&gt; &gt; Possible issues:<=
br>&gt; &gt; =C2=A0 2 disabled<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0008f1040=
0411b18 5 (ISR9024D Voltaire)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000=
092106 13 (Cisco Switch SFS7000D)<br>
&gt; &gt; =C2=A0 6 with reduced speed<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x00=
08f10500200220 33 (Voltaire 4036 - 36 QDR ports switch)<br>&gt; &gt; =C2=A0=
 =C2=A0 =C2=A00x0008f10500200220 19 (Voltaire 4036 - 36 QDR ports switch)<b=
r>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 21 (Cisco Switch SFS7000=
D)<br>
&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 20 (Cisco Switch SFS7000D)=
<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 9 (Cisco Switch SFS700=
0D)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A00x0005ad0000092106 8 (Cisco Switch SFS=
7000D)<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt; Ira<br>
&gt; &gt;<br>&gt; &gt; On Thu, 10 Sep 2009 09:23:35 -0400<br>&gt; &gt; Hal =
Rosenstock &lt;<a href=3D"mailto:hal.rosenstock@gmail.com" target=3D"_blank=
">hal.rosenstock@gmail.com</a>&gt; wrote:<br>&gt; &gt;<br>&gt; &gt;&gt; On =
Thu, Sep 10, 2009 at 9:02 AM, Keshetti Mahesh<br>
&gt; &gt;&gt; &lt;<a href=3D"mailto:keshetti.mahesh@gmail.com" target=3D"_b=
lank">keshetti.mahesh@gmail.com</a>&gt;wrote:<br>&gt; &gt;&gt;<br>&gt; &gt;=
&gt; &gt; Added &#39;ibcheckspeed&#39; and &#39;ibcheckportspeed&#39;: Simi=
lar to<br>
&gt; &gt;&gt; &gt; &#39;ibcheckwidth/ibcheckportwidth&#39; in functionality=
 and implementation.<br>&gt; &gt;&gt; &gt; Reports error/warning messages i=
f the LinkSpeedActive is configured as<br>&gt; &gt;&gt; &gt; 2.5 Gbps when =
the LinkSpeedSupported is more than 2.5 Gbps.<br>
&gt; &gt;&gt; &gt;<br>&gt; &gt;&gt;<br>&gt; &gt;&gt; ibportstate checks for=
 more than this in terms of speed (and width)<br>&gt; &gt;&gt; anomalies.<b=
r>&gt; &gt;&gt;<br>&gt; &gt;&gt; Would it be better for these scripts to us=
e that tool now ? Alternatively,<br>
&gt; &gt;&gt; the additional speed/width anomaly checks could be implemente=
d in these<br>&gt; &gt;&gt; scripts but it does involve checking the peer p=
ort so there&#39;s a little more<br>&gt; &gt;&gt; to it.<br>&gt; &gt;&gt;<b=
r>
&gt; &gt;&gt; -- Hal<br>&gt; &gt;&gt;<br>&gt; &gt;&gt;<br>&gt; &gt;&gt; &gt=
;<br>&gt; &gt;&gt; &gt; Signed-off-by: Keshetti Mahesh &lt; <a href=3D"mail=
to:keshetti.mahesh@gmail.com" target=3D"_blank">keshetti.mahesh@gmail.com</=
a>&gt;<br>
&gt; &gt;&gt; &gt; ---<br>&gt; &gt;&gt; &gt; =C2=A0infiniband-diags/scripts=
/<a href=3D"http://ibcheckportspeed.in/" target=3D"_blank">ibcheckportspeed=
.in</a> | =C2=A0146<br>&gt; &gt;&gt; &gt; ++++++++++++++++++++++++++<br>&gt=
; &gt;&gt; &gt; =C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheckpor=
twidth.in/" target=3D"_blank">ibcheckportwidth.in</a> | =C2=A0 =C2=A02 +-<b=
r>
&gt; &gt;&gt; &gt; =C2=A0infiniband-diags/scripts/<a href=3D"http://ibcheck=
speed.in/" target=3D"_blank">ibcheckspeed.in</a> =C2=A0 =C2=A0 | =C2=A0135<=
br>&gt; &gt;&gt; &gt; ++++++++++++++++++++++++<br>&gt; &gt;&gt; &gt; =C2=A0=
3 files changed, 282 insertions(+), 1 deletions(-)<br>
&gt; &gt;&gt; &gt; =C2=A0create mode 100644 infiniband-diags/scripts/<a hre=
f=3D"http://ibcheckportspeed.in/" target=3D"_blank">ibcheckportspeed.in</a>=
<br>&gt; &gt;&gt; &gt; =C2=A0create mode 100644 infiniband-diags/scripts/<a=
 href=3D"http://ibcheckspeed.in/" target=3D"_blank">ibcheckspeed.in</a><br>
&gt; &gt;&gt; &gt;<br>&gt; &gt;&gt; &lt;snip...&gt;<br>&gt; &gt;&gt;<br>&gt=
; &gt;<br>&gt; &gt;<br>&gt; &gt; --<br>&gt; &gt; Ira Weiny<br>&gt; &gt; Mat=
h Programmer/Computer Scientist<br>&gt; &gt; Lawrence Livermore National La=
b<br>
&gt; &gt; 925-423-8008<br>&gt; &gt; <a href=3D"mailto:weiny2@llnl.gov" targ=
et=3D"_blank">weiny2@llnl.gov</a><br>&gt; &gt;<br><br><br></div></div>--<br=
>
<div>
<div></div>
<div>Ira Weiny<br>Math Programmer/Computer Scientist<br>Lawrence Livermore =
National Lab<br>925-423-8008<br><a href=3D"mailto:weiny2@llnl.gov" target=
=3D"_blank">weiny2@llnl.gov</a><br></div></div></blockquote></div><br>

--0016e65c7bc4d86f9104738e2514--

--===============1932228620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1932228620==--
