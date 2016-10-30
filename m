From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC ABI V5 01/10] RDMA/core: Refactor IDR to be per-device
Date: Sun, 30 Oct 2016 11:13:46 +0200
Message-ID: <20161030091346.GQ3617@leon.nu>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
 <1477579398-6875-2-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0A445F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Mh8CTEa8Ax54aLHp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A445F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Mh8CTEa8Ax54aLHp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2016 at 10:53:13PM +0000, Hefty, Sean wrote:
> > The current code creates an IDR per type. Since types are currently
> > common for all vendors and known in advance, this was good enough.
> > However, the proposed ioctl based infrastructure allows each vendor
> > to declare only some of the common types and declare its own specific
> > types.
> >
> > Thus, we decided to implement IDR to be per device and refactor it to
> > use a new file.
>
> I think this needs to be more abstract.  I would consider introducing the concept of an 'ioctl provider', with the idr per ioctl provider.  You could then make each ib_device an ioctl provider.  (Just embed the structure).  I believe this will be necessary to support the rdma_cm, ib_cm, as well as devices that export different sets of ioctls, where an ib_device isn't necessarily available.

IDR management is internal to kernel and it looks like an easy one to extend in the future.

>
> Essentially, I would treat plugging into the uABI independent from plugging into the kernel verbs API.  Otherwise, I think we'll end up with multiple ioctl 'frameworks'.
>
> - Sean
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Mh8CTEa8Ax54aLHp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFbnKAAoJEORje4g2clinexoP/j+f9q2lqhM5mfUY6tuoMk3M
3Liv6CPKtzA4Sk/c41APYWPH1Z6Ov8QyJqV+X1lxB+ZYevxNLeqWTLK9JeS/YdUo
UeRio1arhZAeZDQmNfTM2CjM14XHgWjQ+iowaTsGpd1o0Og4/1UG19lOdT1T7Ft3
Txo0RS7z2qoU7hKikaappVpFgOarE/PJCLvV2ik5WCMsSLMmAIDqGXOnm3Fry13F
uZ8LHSZ+XM2avYIcgTiww9GEJKUdOHJQUYM68Ydv+hJtTri54kq3qd0cFyYN0v+L
v2waNhzgA6t4YGUr0X+lFSveXHxW8kN7eT4/9BdBAbyqTETUG4WHIOYxjCyg0K15
MPF9Jyu1VKE42gcw4nDNCs2Y2Qiqu2liJE1gQrKjgIlBhsyOUwXUIHsUeFh+KhrM
RPAXCt9PrY6QYWAkIUYcu9XwFvQH2ZXO8f7MolF3VLMXRY8uo800K2hlmuc+WEeW
QzCXnzQM+tjlBQm8fSzA7Jea79sAftfIneWNaDIvo79t0lXfF2bORH+bxxkcknZc
8EWI/i1JS05IN++5N8FUza7mdFen1r/+BUevX17WIRa7/FRh9rKnR2uUTNG6xp5m
lEC8XZ5u/0gWZwajl1QH1/ddPnfKzNIC2S3lyfv1tPZ/AVpQJja0A7UOrS5KikTl
NhfVYA5hj8duEHlFUdTG
=Snnc
-----END PGP SIGNATURE-----

--Mh8CTEa8Ax54aLHp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
