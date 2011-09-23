From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 12:44:21 -0400
Message-ID: <CAKzyTswr6EMFPn1fBNujP1Lgb8b6MEcJ1uPbVqEt_nE1Er7dPw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<CAKzyTsyH0rop69rTGUW_+kgfohyN-XiCLV4JsO9NLzyH9KpQAA@mail.gmail.com>
	<CAKzyTszJ8qbPMYgMFhAzkJVnGmgetggSU7BYN+1RxrVB3tBYqA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E67777@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0334206083=="
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E67777@ORSMSX101.amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, "Ira Weiny (weiny2@llnl.gov)" <weiny2@llnl.gov>
List-Id: linux-rdma@vger.kernel.org

--===============0334206083==
Content-Type: multipart/alternative; boundary=0016367fa516681d6704ad9e852b

--0016367fa516681d6704ad9e852b
Content-Type: text/plain; charset=UTF-8

On Fri, Sep 23, 2011 at 12:40 PM, Hefty, Sean <sean.hefty@intel.com> wrote:

> So far, it seems that the choices are:
>
> 1. Remove ibstat and use ibv_devinfo instead
> 2. Change ibstat to obtain the fdr10 information using ibverbs
> 3. Move the is_fdr10 functionality into OS specific files or code sections
> of ibstat
> 4. Change ibstat to obtain fdr10 data using MADs or some other OS
> independent mechanism
> 5. Change ibumad so that it provides the fdr10 data
>   Note: umad has OS dependent implementation anyway, but the windows umad
> would
>         depend on the data being available from ibverbs
> 6. ???
>
> Can someone explain why the information can't come from the umad_port::rate
> field?
>

Because fdr10 is non standard, there's no rate for this; it overloads QDR
based rates as both are 10 Gbps but have different link encodings.

-- Hal


>
> - Sean
>

--0016367fa516681d6704ad9e852b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Fri, Sep 23, 2011 at 12:40 PM, Hefty,=
 Sean <span dir=3D"ltr">&lt;<a href=3D"mailto:sean.hefty@intel.com">sean.he=
fty@intel.com</a>&gt;</span> wrote:<br><blockquote style=3D"margin: 0px 0px=
 0px 0.8ex; padding-left: 1ex; border-left-color: rgb(204, 204, 204); borde=
r-left-width: 1px; border-left-style: solid;" class=3D"gmail_quote">
So far, it seems that the choices are:<br>
<br>
1. Remove ibstat and use ibv_devinfo instead<br>
2. Change ibstat to obtain the fdr10 information using ibverbs<br>
3. Move the is_fdr10 functionality into OS specific files or code sections =
of ibstat<br>
4. Change ibstat to obtain fdr10 data using MADs or some other OS independe=
nt mechanism<br>
5. Change ibumad so that it provides the fdr10 data<br>
 =C2=A0 Note: umad has OS dependent implementation anyway, but the windows =
umad would<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 depend on the data being available from ibverb=
s<br>
6. ???<br>
<br>
Can someone explain why the information can&#39;t come from the umad_port::=
rate field?<br></blockquote><div>=C2=A0</div><div>Because fdr10 is non stan=
dard, there&#39;s no rate for this; it overloads QDR based rates as both ar=
e 10 Gbps but have different link encodings.</div>
<div>=C2=A0</div><div>-- Hal</div><div>=C2=A0</div><blockquote style=3D"mar=
gin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-left-color: rgb(204, 204,=
 204); border-left-width: 1px; border-left-style: solid;" class=3D"gmail_qu=
ote">
<font color=3D"#888888"><br>
- Sean<br>
</font></blockquote></div><br>

--0016367fa516681d6704ad9e852b--

--===============0334206083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--===============0334206083==--
