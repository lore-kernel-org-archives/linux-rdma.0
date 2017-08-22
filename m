From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 REPOST 10/10] Documentation: Hardware tag matching
Date: Tue, 22 Aug 2017 11:28:58 +0300
Message-ID: <20170822082858.GU1724@mtr-leonro.local>
References: <20170817125212.3173-1-leon@kernel.org>
 <20170817125212.3173-11-leon@kernel.org>
 <20170821160437.GD4401@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HtRZva1Vzv8iP5ye"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170821160437.GD4401-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HtRZva1Vzv8iP5ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 10:04:37AM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 17, 2017 at 03:52:12PM +0300, Leon Romanovsky wrote:
> > From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add document providing definitions of terms and core explanations
> > for tag matching (TM) protocols, eager and rendezvous,
> > TM application header, tag list manipulations and matching process.
>
> When adding a new common verbs it needs to be documented to a level
> where someone else can implement it.
>
> At least describe the new header format and how the matching process
> must work..

The actual work and new verbs will be added to rdma-core and will be
documented there.

Thanks

>
> Jason

--HtRZva1Vzv8iP5ye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmb60oACgkQ5GN7iDZy
WKfSpw//Ry0q+G9TJXIsEpej4Ql4p2EQzic3TZ7bdNBVIC1cY0bkMhFJIzhtbnOU
tFoD57KtyVK401s+aIaNDo+pg3qESD+Cy0YU637N3oNVJBL/wjXWmszbDYrG0kyS
EF50TSIJedd4I5WkGsQR6KMr/PnCh1Hku2GJsKBrO0rzCXrA4UvcZy/T3J7v4SEo
Nbf510FR+ysd2riUMVJ5Y61wr3f89r9sG7jVXeF9QxhwgkLq0r6NAOl7/Ie7ee4t
PEdWIxxztcugOGmt6mmhlvzP65OlKbjU3issy3vJPu9ZQq7FKZcI/xagPojB/ftB
QdYg59/5eMRfCXbn9C4/nKXOy2ShR6m9+vSKchZUbpMeUWRoNwIPuGt26lB0fSzr
hTmBP+hAToqkkvB6nJczzEGjE676XTZHJCKj6S0AdCyQjRzzxvbmqTg1Ep9aR3mD
aGE4yyAKzUIqvReRy9xxKO0eDy+yhj8hdK3lZX9QAdZmGlunDY0JZG0RDYusBzug
+s6boVnWLXjrlv5SdGa0kWmLTfHX22seFyQKwnk2rzSwkA5YBGHTVal1x2n8LXlk
bYfdJ2sKk3UdE2FU/L4dCzgyYag7tj6H4SfGVbN8IiNm9MhJxCiIH0Bq64lN75LP
u+2UzbT2vX01yYEQLGscuV7W9FR3lbYAaRwlEj4MJtCIr+5yDmQ=
=ca3I
-----END PGP SIGNATURE-----

--HtRZva1Vzv8iP5ye--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
