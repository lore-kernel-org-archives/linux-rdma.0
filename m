From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Mon, 16 Jul 2018 10:59:29 +0300
Message-ID: <20180716075929.GF3152@mtr-leonro.mtl.com>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <20180709122908.GJ22049@dhcp22.suse.cz>
 <20180710134040.GG3014@mtr-leonro.mtl.com>
 <20180710141410.GP14284@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0407170946=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20180710141410.GP14284-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Felix Kuehling <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>Mike Marciniszyn <mi>
List-Id: linux-rdma@vger.kernel.org


--===============0407170946==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2018 at 04:14:10PM +0200, Michal Hocko wrote:
> On Tue 10-07-18 16:40:40, Leon Romanovsky wrote:
> > On Mon, Jul 09, 2018 at 02:29:08PM +0200, Michal Hocko wrote:
> > > On Wed 27-06-18 09:44:21, Michal Hocko wrote:
> > > > This is the v2 of RFC based on the feedback I've received so far. The
> > > > code even compiles as a bonus ;) I haven't runtime tested it yet, mostly
> > > > because I have no idea how.
> > > >
> > > > Any further feedback is highly appreciated of course.
> > >
> > > Any other feedback before I post this as non-RFC?
> >
> > From mlx5 perspective, who is primary user of umem_odp.c your change looks ok.
>
> Can I assume your Acked-by?
>
> Thanks for your review!

For mlx and umem_odp pieces,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbTFBhAAoJEORje4g2clinrPEQAM3K+7WNo+Ro9U49mpUc8xr/
MGGxTsfNW12jUSp6FCTQU6e53hUr+Xkr7HLA9V2PRM848OAOjQlBUKgCGQ4Mb1hQ
jaWFDf5PTXMiSwutJGhqJXuaYkFyLiR6oE0hdGoaPFRQ6TDkWeqXmP7MDOvJe9ml
Ea4dAgif8LEjYjGNOCUGJ6Ur89jJmf4D6EFcWhHyin7XejnD3z4vX0VcRbVwY8tl
H7w7S/TRXNE9gGUTid8i6eC81IG+p+xOaG0JhLcf95F0/sz7Y2gwWUzHWUScrn7A
m7mLXJf+hMGM6oVYxE224xTUbKkVXfYjYLzY9BZ7NB9ycKdi6aDL4diB2w+83acB
SplvTEfXKFVQtSKVyo24NoxEIscZyIHrJu0BaE8d002tvAcE2uiSmgUbQ/grXooe
8Fl8vyau1974/hx4bP6/Fclol25CUtqCatVw+x4vysEqferddvmFW0xOTzUorpTP
bI7zb9Ozs3icZ90Hhxk1jBe1Jmw8XIPGTCv06yDQOufFHxi2UnL2qKVxIrPLh/s5
xkJzguy/TxXk210mWnbWmpmytgKNsUQSMmYqyUEfxtzWlRHYWD3Z6KVUAsPsuy8J
b/fCbYfHzCTP2X4Vm4eoYTxI7YzByBnyIK/eAz1eKVlYbJb8yXx0bqzRbmn6gizc
jWDNXsZCJJ8q58BpwivZ
=YBIL
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--

--===============0407170946==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==

--===============0407170946==--
