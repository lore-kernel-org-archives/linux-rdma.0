From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 13:41:23 +0300
Message-ID: <20160608104123.GJ3663@leon.nu>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <20160603052539.GB31196@infradead.org>
 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
 <1465379530.5365.91.camel@haakon3.risingtidesystems.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1y6imfT/xHuCvpN0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465379530.5365.91.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linrdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1y6imfT/xHuCvpN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 08, 2016 at 02:52:10AM -0700, Nicholas A. Bellinger wrote:
> Hey Moni & HCH, Co.
>=20
> (Adding Sagi CC')
>=20
> On Wed, 2016-06-08 at 11:49 +0300, Moni Shoua wrote:
> > On Fri, Jun 3, 2016 at 8:25 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> w=
rote:
> > > Do you have a changelog compred to the last version?
> > >
> >=20
> > - Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
> > - Rebase to newer kernel (was 4.4-rc6)
> > - Removed support in phys. MR
> > - Removed memory window codes (buggy)
> > - Mind  IS_ENABLED(CONFIG_IPV6)
> > - Dispatch IB event on port UP/DOWN
> > - Validate ICRC in receive
> > - Validate dgid in receive
> > - Scatter IPv4 header to right place for UD QP
> > - Other bug fixes
> > - Copyright dates were updated in file headers
> >=20
> >=20
> > > How well do FRWRs work, does this include Sagi's work in that area?
> > FRWR is not supported yet
> > > How well does posting of fenced WRs work?
> > We ran successfully some simple tests with IBV_SEND_FENCE
> >=20
>=20
> Great.
>=20
> A Soft-RoCE environment against v4.7-rc2 for iser and early nvme-fabrics
> code would be extremely useful.  :-)
>=20
> Can we get this code into 0-day build ASAP..?

Hi Nicholas,

Per your request, I added Soft-RoCE code to my tree for testing (kbuild
and linux-next tests). Please be aware that official RDMA tree is Doug's
tree and only appearance in his tree will be sign for acceptance.

https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=3Dt=
opic/rxe
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=3Dt=
esting/rdma-next

Thanks.

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1y6imfT/xHuCvpN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXV/ZTAAoJEORje4g2clin3S4QAIYPIUsNj/djF/JUm+vOQNhN
qx9ZRZPMurfX1aSHNrFAVH9Jm7DC9KpTZcZGMaC3CCEtEHjnqnTfFrruknA3FDQ8
7Ng3T62Zym7qz53Ex4YESbeg3/WuxdUcYC7PSBIVEp22sM0z2vlh1bmzMxHJlogK
6DHEg0QjEKslOy6Fz8TohiL82vKG5EGppSaDEotlscaXmWoljeuJzSrYUNyxfvAw
WyDiSJkVg5BFRdA2t+CvfHlMNu3AbC26jCLIV2WE3BnPqPgchbtW9deA6PcEVdmH
XeG3w/JhihX1Y190f5gn1Ir/wCbHUAXrLBc+Z7iVm57Dejhn3uYVdg3jBOIQDnEv
4UjgWempzS7s/bcqRmC+jlyLR/jy7lrSnlE49Pxi67VddtHHQct0BbqZdtj9Wam0
+FNi5I3kIicJvle/zZ9g5e62Ed33gSBwO/+d4ysgwf53AT8m0+2rFcvXKC74A4ux
fNU+dNY8ULRnZb5mB5dD+qsSoPqiuy27imx4JCa9s5D9JMeFZSGRUnNTeEcdLzKk
fCQGRjC+VKjPODgMUADmzekskKEmGmQf8OwZyo5T0qNUO2P5iVsBO1ydRkjmUc+q
3atLOQ7DCn72puSXupzYPWVNkaEvnoz0efLrFDj4O1bDsh+YHijUn2Mk8x+C+cve
YH0SAKUpck/ckn+3Xpmq
=D4tH
-----END PGP SIGNATURE-----

--1y6imfT/xHuCvpN0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
