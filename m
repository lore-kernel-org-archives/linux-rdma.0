From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 2nd RDMA Miniconference Summary
Date: Mon, 18 Sep 2017 08:41:16 +0300
Message-ID: <20170918054116.GD5788@mtr-leonro.local>
References: <20170917125603.GA5788@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GpGaEY17fSl8rd50"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170917125603.GA5788-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "LWN.net" <lwn-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 17, 2017 at 03:56:03PM +0300, Leon Romanovsky wrote:

<...>

> *  uABI Update - Matan Barak

And this is the presentation: http://linux-rdma.org/docs/lpc-2017-kabi-matan-barak.pdf

> 	* main purpose: enable it by default
> 	* goals of uABI
> 		* resolve write() security issue
> 		* an extensible approach
> 			* #1 - extensible verbs
> 			* #2 - vendor specific - objects, methods and attributes
> 		* and more: automatic syntatic check, backward compatability, efficiency
> 	* The approach is similar to object oriented programming
> 		* Objects - cq, qp, ...
> 		* Methods- create qp, modify qp, create cq, ...
> 		* Attributes - qp handle, qp type, ...
> 	* Parsing trees types
> 		* Common feature-set - QP, CQ, MW, MR, PD
> 		* specific feature - device, CQ
> 		* driver-specific feature - e.g., MLX object, CQ, QP
> 	* The consolidated driver specific parsing tree will be created from the *supported* common/specific/driver-specific features listed above
> 	* user-space passes an ID that is a 16bit unique number to identify the operation
> 	* Method = name + ID + handler + attributes
> 	* Next
> 		* try the accepted patches yourself. already two verbs are implemented (cq create/destroy)
> 		* transition -
> 			* will need to move *all* verbs to resolve the security issue; will need to recode RDMA CM,...
> 			* But can start transition now to enjoy the extensibility and vendor specific perk
> 			* hopefully we could remove the "experimental" before we transition everything (will take time to convert all..., more than 2 years)
> 			* Red Hat won't take anything in experimental...
> 			* force new features to use the new API?
> 			* choose minimal verb list before removing the 'experimental'?
> 			* compat suggestion: have the old API actually use the new API under the hood
>

Thanks

--GpGaEY17fSl8rd50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm/XHwACgkQ5GN7iDZy
WKfySBAArzBoYD2I3j8a+EsVqMePPsKrKU8c+WOQJ0L5SJskFUNyiv6nCNkGSTeZ
5XKXVVlQZ/UN7Ly1//j2Jp/c18w6OPSSQ44G9/T73WWuArjwIrmUXsGqBXDzwHkr
3yKd3x6vQtmHoWcWKfW3Mo3tFB9+4tZ6NRak6oK5SqG+qNo2FbYznTetnG3jayA4
65chWvfcEzgqSyN/zacCCSzEMhzuR7Lln4E+/Ytg2lS7UtIjnFuZpvQyLcuTOVpJ
YP+vy+0qG0KyhbsOmzGWvzm0RBT1i8Kxtcf6I/AUm3QumKm7ONUnRQYZXcKMd9VB
vC3F3uVHDv/j/fNc05PHlV+Cigz47UmfqHo3/SlIX0K41wBq+NKTBMB7nZFYFMxM
OT8Ln6kl6JmmGCsbpyNl2ktoCn3xGBB1qmZGluQgWj7RElvcdAEjhlzlTsb1XWLs
q51YBe+hgOD0jMCbFOF+u5Y8PMXxwC34DXcEqZR0YhEntrj0OGCEaCJhs8QokvqK
kmdB9a+kMPyn5JqoTMnZGcF79byKr8tTEZtztJrwizc+dxd4HmT4Y9fxv0ECX6C+
4RptrzRc897LPWxDEnr0t3YyOkBDqxW3MlOgtiKbbDBox0O/qmx1r1ugQLX/17i3
+4Wma7x4z1Nx9jnO2dHkE42GtcC7y6qjNlr+zjywwZ2iSk36krw=
=Bxmm
-----END PGP SIGNATURE-----

--GpGaEY17fSl8rd50--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
