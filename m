From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Thu, 28 Sep 2017 21:57:53 +0300
Message-ID: <20170928185753.GG2297@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Wo0oCZYLrer5S3Oe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928184727.GA33282-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Wo0oCZYLrer5S3Oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 11:47:28AM -0700, Vishwanathapura, Niranjana wrote:
> On Wed, Sep 27, 2017 at 11:26:17AM -0400, Doug Ledford wrote:
> > On Tue, 2017-09-26 at 11:12 -0700, Vishwanathapura, Niranjana wrote:
> > > The debugfs interface here is for VNIC port encapsulation
> > > configuration.
> > > They are not related to netdevice functionality.
> > >
> > > They are for debug purpose only and not the supported configuration
> > > mechanism.
> >
> > OK, if this isn't the supported configuration mechanism, then what is
> > the supported mechanism?
> >
>
> The supported mechanism is the Ethernet Manager providing the encapsulation
> configuration (as in the opa_vnic.txt documentation)
> This is just a debug interface to it.

Add tracepoint for that.

>
> Niranjana
>
> > -- >Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >    GPG KeyID: B826A3330E572FDD
> >    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> >

--Wo0oCZYLrer5S3Oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNRjEACgkQ5GN7iDZy
WKdVaxAAyeJOMHCG9Gs4xhTSIyaFuAzyood/HzZ+ZlHr/GOPWXfyJnn+CmSoQrYC
IN107IFxrUA+2BVYCjtiLbhmeeoBu2jItKCsPKCnifrSW+RYS38tsAaCc5eWX/dA
V8vzx90ZHcPmWbpIX6SiOBt9Qr6jlzpMN3PfGEqDIhbfRuqEV32GLtFrDUy8k4yk
MJ4FiBolSuE+wIEWJ+l3LDoMthbjWDmFgPQ4MfnirW5JAKbksdWkTbon0odapjTy
coP3nULyfm+rHkFCkunq64DmKTngilOBZOsaZYUPMa4yojNxPg0yoxUKoLChm5vL
TA4jOOwLA1dGCBINRh7bqQbRwvddZzx2MhcNVZsGvf5xF1fC2rVBlkT8bSRnoHM/
0TRWmH+yGVHk/N8kNRTuyJRoZg0uJwhcPDwi7hPipT3VbIF9j8LehwUgvCgy29zA
l/K7vBOCGz/Ry0XXeRM9BYZRFdC0ftQTNGJsCsZ0hNjSltgyN9ipU+W1StnEZvwD
HGDIp7raxGnyDZYBH+ri1xNNujnTMlpYCf41H0erUueqA0A2quIG31TdUK6wetxy
ZYBHXacs3fhORAIADkXI47C1WLwyED3NF0SmkuV7ojcdiY+hJs3fdt+e2FYyhGUd
SXBBCAHXm8ASjtvs3fzuqaEl0eqZUqQNKKxmaVI/tI/i/M+wRMY=
=24EF
-----END PGP SIGNATURE-----

--Wo0oCZYLrer5S3Oe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
