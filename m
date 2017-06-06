From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 08:52:29 +0300
Message-ID: <20170606055229.GT6868@mtr-leonro.local>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <20170605172058.GB20477@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SvyA5ywaG/v2A5dH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605172058.GB20477-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--SvyA5ywaG/v2A5dH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 11:20:58AM -0600, Jason Gunthorpe wrote:
> On Wed, May 10, 2017 at 02:25:23PM +0300, ahmad omary wrote:
>
> > struct ibv_dm *ibv_alloc_dm(struct ibv_context *context,
> >    struct ibv_alloc_dm_attr *dm_attr);
> >
> > struct ibv_alloc_dm_attr{
> > size_t length;
> > uint32_t comp_mask; /*enable future extensions*/
> > }
>
> Can we please stop this madness where every function call needs to
> accept a struct?
>
> It is perfectly fine to add new function calls if new arguments are
> needed someday.

IMHO, generally speaking, it is better and cleaner to have similar functions
signatures for all APIs which is exported to user.

>
> > int ibv_memcpy_dm(struct ibv_dm *dm, struct ibv_memcpy_dm_attr *
> > memcpy_dm_attr);
>
> To be clear, this is has to be a sycall, right?

Yes

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SvyA5ywaG/v2A5dH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk2QxwACgkQ5GN7iDZy
WKdQjBAApB3FC2Y09tZJu8uaxhtmkMSXdScG/HI8ZwVv1bfzkYtBZMXMqLOhYhn/
WUqXwZXFl42lcrResO/s6c/tliAT5m06R+n2D4JxhrRY/bcVFKUvL8q61uScyytK
ozfe+bG4+qz9Uv7FUMJ8sVqO1jyhiiziRa+JGyIvCxax1pu2WI6RDxCgnhPN11QY
6CYPi4f0oxHALuVSaH0Xeei7rZaZZx/yftPW247KjwSxtei5ip1uxH+cLhbO545Q
GcMkKV3ZHVXPeHrv4TA8BvsM7u3DfTSkNliuXnTpwoejbBYli8GU6SnG+KppyPrK
jjtRK8FVCYjBLgMCnnZmQUB76WHlUq2NFnP2aQFq7qQn1PVhNtaKnCuvB097tdqu
4sN5fiL3KbwQzm0kr9OWKlWmZUzOadyKnEtlvoqRmkZ05bkgNghEwunP64UlBSSW
/4yAiDRdTeanIyUBHONdBjzB/fadsoa5LZK5YRh87O8Mg+F1YcECrrzQEzxauYKx
zl9/lOfnUSI1iLhakCpnaRFXQy5HdYztk9hk5FNuSucwtRz7Dsby5lcp/fGerjBA
VeR2nbHrAar0kqzGZgmGa0/G+Ipz6bGHzpftBV1aVq0G70oICVTHWLWacnvSeT6y
NSISFfqnqP1oYHwEnS/1pl+MoufxMNOzvIEJDhWU+dxoNuY4f70=
=zEV3
-----END PGP SIGNATURE-----

--SvyA5ywaG/v2A5dH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
