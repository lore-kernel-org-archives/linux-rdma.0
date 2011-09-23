From: Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 12:33:05 -0400
Message-ID: <CAKzyTsxT+_dXMk6UgRAUnSwodym_jwEOR8znN8bOPecHR=x01w@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<CAKzyTsyH0rop69rTGUW_+kgfohyN-XiCLV4JsO9NLzyH9KpQAA@mail.gmail.com>
	<CAKzyTszJ8qbPMYgMFhAzkJVnGmgetggSU7BYN+1RxrVB3tBYqA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E67718@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1094826933=="
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E67718@ORSMSX101.amr.corp.intel.com>
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

--===============1094826933==
Content-Type: multipart/alternative; boundary=0016364d2c791ce01c04ad9e5da0

--0016364d2c791ce01c04ad9e5da0
Content-Type: text/plain; charset=UTF-8

On Fri, Sep 23, 2011 at 12:21 PM, Hefty, Sean <sean.hefty@intel.com> wrote:

> > > The only way to determine whether fdr10 is active or not is via the
> > > vendor proprietary MAD. That info may be reflected in some other API
> > > (and/or file) so that MAD does not need to be reissued. In a separate
> > > thread on linux-rdma, there was discussion on a couple of different
> > > ways to do that from verbs and in this thread that there's no sysfs
> > > equivalent in Windows. You've already stated that the Windows support
> > > is using libibverbs for libibumad support so it seems appropriate to
> > > me to do the same here (in Windows at least).
> >
> > The proper place for is_fdr10 is in libibumad (and then we wouldn't be
> > discussing libibverbs w/ibstat) but that was not done to avoid a
> > change to the umad port structure.
>
> ibstat determines is_fdr10 by reading a file.  That same data could just as
> easily be exported as a port attribute, which would make it belong to
> ibverbs, rather than umad.
>
> If the only point of exporting is_fdr10 from the kernel is for an ib
> management diag to display the value, then it's not a useful value for verbs
> applications.
>

fdr10 is in the same category as active_speed. What's the use for that other
than display ? Anyhow, display seems useful to me to know the local port
speed.

-- Hal

--0016364d2c791ce01c04ad9e5da0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Fri, Sep 23, 2011 at 12:21 PM, Hefty,=
 Sean <span dir=3D"ltr">&lt;<a href=3D"mailto:sean.hefty@intel.com">sean.he=
fty@intel.com</a>&gt;</span> wrote:<br><blockquote style=3D"margin: 0px 0px=
 0px 0.8ex; padding-left: 1ex; border-left-color: rgb(204, 204, 204); borde=
r-left-width: 1px; border-left-style: solid;" class=3D"gmail_quote">
<div class=3D"im">&gt; &gt; The only way to determine whether fdr10 is acti=
ve or not is via the<br>
&gt; &gt; vendor proprietary MAD. That info may be reflected in some other =
API<br>
&gt; &gt; (and/or file) so that MAD does not need to be reissued. In a sepa=
rate<br>
&gt; &gt; thread on linux-rdma, there was discussion on a couple of differe=
nt<br>
&gt; &gt; ways to do that from verbs and in this thread that there&#39;s no=
 sysfs<br>
&gt; &gt; equivalent in Windows. You&#39;ve already stated that the Windows=
 support<br>
&gt; &gt; is using libibverbs for libibumad support so it seems appropriate=
 to<br>
&gt; &gt; me to do the same here (in Windows at least).<br>
&gt;<br>
&gt; The proper place for is_fdr10 is in libibumad (and then we wouldn&#39;=
t be<br>
&gt; discussing libibverbs w/ibstat) but that was not done to avoid a<br>
&gt; change to the umad port structure.<br>
<br>
</div>ibstat determines is_fdr10 by reading a file. =C2=A0That same data co=
uld just as easily be exported as a port attribute, which would make it bel=
ong to ibverbs, rather than umad.<br>
<br>
If the only point of exporting is_fdr10 from the kernel is for an ib manage=
ment diag to display the value, then it&#39;s not a useful value for verbs =
applications.<br>
</blockquote></div><div><br>fdr10 is in the same category as active_speed. =
What&#39;s the use for=C2=A0that other than display ? Anyhow, display seems=
 useful to me to know the local port speed.</div><div>=C2=A0</div><div>-- H=
al</div>

--0016364d2c791ce01c04ad9e5da0--

--===============1094826933==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ofw mailing list
ofw@lists.openfabrics.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
--===============1094826933==--
