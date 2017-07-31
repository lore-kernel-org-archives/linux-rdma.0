From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Kernel oops
Date: Mon, 31 Jul 2017 08:39:01 +0300
Message-ID: <20170731053901.GR13672@mtr-leonro.local>
References: <20170724211606.GA1705@obsidianresearch.com>
 <CAAKD3BAdB2aRk3WGdbeDYof6dUfkEwhQf27cG0FWe5DRuQ15NQ@mail.gmail.com>
 <CAAKD3BDFrTMMgX0nErD50rp2je=HC9zeaYWHDKf0mqQwc5fM9g@mail.gmail.com>
 <20170727204437.GA16986@obsidianresearch.com>
 <20170730102514.GQ13672@mtr-leonro.local>
 <20170731035208.GA30615@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FRaepaAnLTQkJ4tS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731035208.GA30615-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FRaepaAnLTQkJ4tS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 30, 2017 at 09:52:08PM -0600, Jason Gunthorpe wrote:
> On Sun, Jul 30, 2017 at 01:25:14PM +0300, Leon Romanovsky wrote:
> > > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Tested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >
> > > Please add a fixes line
> >
> > Hi Jason,
> >
> > I queued it [1] for submission, once the IPoIB fixes [2] will be
> > accepted, I'll submit it.
>
> Isn't fixing random kernel memory corruption triggerable by userspace
> exactly the sort of thing we should be rushing into Linus's tree?

I'm still looking on the easiest way to submit patches and want to see
that everything is working before "rushing".

Thanks

>
> Jason

--FRaepaAnLTQkJ4tS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll+wnQACgkQ5GN7iDZy
WKc4oA//asqYoQgmA6GC383AIVMhABEBV8W/z62WFNsL1LeuhXMoYvZpPpE22/pV
dSYHe2Tjyic0ChEYhiNYMWU+Ix64hqppZV7FDEjSyt9kAlDUj/TtYHa6XlDx6IJn
1B1cCUE/rk7f6ZbXmlEoPzuAQnMciz2bIOBjXjTtlWcYEpf/QbRFtPa4zQwoi8kH
V4Lbfw5XPRqXrvQwHjfgzGQAoLpKXIVxAvfisjpL3khUYd6Gu9+9b1EcmPNRBvI1
9bXw1tDahAEQpVPtDE9bRC3pi5y09UMJNPrOmXXqoOyyKPVJ/jyDn6vcfoOFwiXP
qNHuDlmCi1Bzj579x81P6bp/glTJdbJEU4B6f6kJwsMP1/lWT6Othyg3RSiprjCP
PbSXsGZbsTdLeK+9OSIe89tuCrYv5SG44nOFDmsOsOqjDo4KS/JqnS8H/ZK0SlZF
/l05165D/7teB4pPMfALSNhsfNYKe2lXLBeOYiPWFF8Tr2oFPd5IzasC7IAx2Ndx
QntWhJqRwgNtVIFRI6rdtHYX1Zgbawvhe9SgN9/eAFaWMSz3p39jvLPpJ4RYaLEN
WJzrlZ8LRpO6x2qnXIm5DWOarzHfFVRbsD7yRBcQI1yc080YUDLfw1eUsIPRartb
dFQOPZmSsybE38e0gISaSx0EtJtGdHywOsmkCp1UdW8Y+0FpzJw=
=K1fE
-----END PGP SIGNATURE-----

--FRaepaAnLTQkJ4tS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
