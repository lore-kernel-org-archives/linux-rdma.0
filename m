From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/15] IB/rxe: Add a runtime check in alloc_index()
Date: Thu, 5 Jan 2017 08:43:19 +0200
Message-ID: <20170105064319.GY12077@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353638.3592.30.camel@sandisk.com>
 <20170104172704.GU12077@mtr-leonro.local>
 <1483555108.3101.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AFQGHouA0VN8Ovbt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483555108.3101.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AFQGHouA0VN8Ovbt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 04, 2017 at 06:38:45PM +0000, Bart Van Assche wrote:
> On Wed, 2017-01-04 at 19:27 +0200, Leon Romanovsky wrote:
> > On Mon, Jan 02, 2017 at 10:41:58AM +0000, Bart Van Assche wrote:
> > > Since index values equal to or above 'range' can trigger memory
> > > corruption, complain if index >= range.
> >
> > It looks like severe bug and the proper error folding is needed, if it
> > is a real situation.
>
> Code in other functions guarantees that this condition won't be hit. The warning
> I added is intended to catch bugs if that other code would ever be modified.

It sounds reasonable.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks.

>
> Bart.

--AFQGHouA0VN8Ovbt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlht6wcACgkQ5GN7iDZy
WKf3dRAAhoL4l2aefnJXHqRVJUb9g/Ej+bxhgbf01tu5BJk+AZ02RzndWvkgAca+
azseD61bAeo1L9R4fvDJqvhkfmgWQubuWysgM4vFNkvrRheDHihoI2lMmIOlMqnv
jXGnOpFrbWqH7FzC2daF0OSbuGS62imS2PG/Tf58gFTV5yDN72tCsxPJ5I5TEHlT
fidRu4IT7YGmBgq7CFHOhGGC45JZCAqTPb0PfEDDydPC8w89u2F15sHvSQ8G+e9Y
dU8Azjs1VOzZMVRXSMBetomR7uPHvpgXdgpopq2HJQ2Bv11rBkyUqg5zoY2zrFCa
V1tLTUdexWax9npaD6797ylWWbg4UR2F0C86zknMRPosEsSaPCb3KfS9LeEEIFyv
rB32ew9qp8ASqJQyN+/hk8GbEeAWx9zKq8CuANED3rspIsFzviLHPSHAhtFw4eSs
GhL2RQcJ2mRm0jn89Q6JkLxnzQwUfJh/lBLSlm08lXpG46Mmy1JsgZAlP+JPIGmM
Cn524uVIHkZuVqfpM0bABhKtdykpcgMwQkr5Tsv3pklW0ZebvQPQI7oATpThct2+
ylCa3raS3sqa0P2fNzTXuhFjBwBHzZc+Em+5e3PX7FiLN79KxR6b0IcQzpmEUQrf
N7HsCYJFnU7hilvwWrdW4h0S3COJV0pUF6OJVfxnyJm5gszUbjU=
=foB2
-----END PGP SIGNATURE-----

--AFQGHouA0VN8Ovbt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
