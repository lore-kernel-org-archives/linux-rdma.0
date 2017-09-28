From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Thu, 28 Sep 2017 22:37:40 +0300
Message-ID: <20170928193740.GH2297@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NQFQLHPkFLmdEfVA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928190502.GA33289-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NQFQLHPkFLmdEfVA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 12:05:02PM -0700, Vishwanathapura, Niranjana wrote:
> On Thu, Sep 28, 2017 at 09:57:53PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 28, 2017 at 11:47:28AM -0700, Vishwanathapura, Niranjana wrote:
> > > On Wed, Sep 27, 2017 at 11:26:17AM -0400, Doug Ledford wrote:
> > > > On Tue, 2017-09-26 at 11:12 -0700, Vishwanathapura, Niranjana wrote:
> > > > > The debugfs interface here is for VNIC port encapsulation
> > > > > configuration.
> > > > > They are not related to netdevice functionality.
> > > > >
> > > > > They are for debug purpose only and not the supported configuration
> > > > > mechanism.
> > > >
> > > > OK, if this isn't the supported configuration mechanism, then what is
> > > > the supported mechanism?
> > > >
> > >
> > > The supported mechanism is the Ethernet Manager providing the encapsulation
> > > configuration (as in the opa_vnic.txt documentation)
> > > This is just a debug interface to it.
> >
> > Add tracepoint for that.
> >
>
> For some reason, I couldn't find Leon's earlier response on my mutt! Will
> repond here.
>
> It is not really for tracing, but to have a simple debug read/write access
> to the encapsution configuration which allows us to triage issues.
>
> We find it useful on an ongoing basis, more like some standard NICs
> providing debugfs interface to read/write from/to some of its registers.

Usually if such interface is spotted during submission, it will be requested
to drop it. Ask Salil, who lately upstreamed new ETH driver and was asked
to remove it.

>
> It is much easier to have it upstreamed and available instead of maintaining
> these patches separately.

See, I didn't hear anyone here against adding such ability, but if you
want to hear such, you can always CC netdev :).

The question, we are asking is related to the interface chosen to do so - debugfs, and IMHO it is a mistake.

Thanks

>
> Niranjana
>
> > >
> > > Niranjana
> > >
> > > > -- >Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > >    GPG KeyID: B826A3330E572FDD
> > > >    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> > > >
>
>

--NQFQLHPkFLmdEfVA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNT4QACgkQ5GN7iDZy
WKdatQ//cV4C5ORuDgAbV6O4VwtNX53nI0AyylbGvS+PXTZnomLrvB0Q3F8SlkdR
Db+Q2WxFL28CmEX3FtN7SvfMdOd4T0vcEv2K+S6h1jhvanvzxnFjxHTQQJmYjF4W
qxggm1ewdUpRYMq/LNsaOagY0vh4nVgXtGKpAS2E4QwPfqD18whA76Q/McQuyqg9
xYHhwi6I1EL2Vum19FvNbyVyfuQUvUKBBw0s7bfFEQmW8qVq1p86CPruN0+V/W+B
tvOexMA50DqjPKTE2PCxY7N4Rbhg+d39li7DCJfCiAbxOk3QWbTmYg7Rw++UIetc
0baV4iLJsA4vBCuYAlvPHy/GxFy7pLeKDUo+BuVjOxhDp5G8vkSGujpa6/TuWT0z
fh7Pcn4qsXD02uu0xFkZ6/EXGl63MgOMXoq3IjcXFr7M3rJK/Fk/hD7geVQFryb8
txNyLnOFfp8gcS6IMWKdqt1IHkziKTmFA1kQ648tlhxQduvD/JYbh07F/8LhFr3C
cf/VFMj9ZrS0nwledcHNOdhLD7yS/FyY6e/kfJh0kaITPqP7id+MVto/QKHdh+Qm
3NTH+VEAXW0DfcMMO8CA66sn14GRUYWM6IuAYDXVqWDwVOKA3Q0Bk8sIXVRdTPS+
sHgxr7b4KorUebUmu1K1Hn4v4cPy53WhYBpTw7URH3L541xAlBo=
=7KXK
-----END PGP SIGNATURE-----

--NQFQLHPkFLmdEfVA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
