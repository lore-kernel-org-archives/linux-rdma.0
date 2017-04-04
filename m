From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/IPoIB: Introduce RDMA netdev interface
 and IPoIB structs
Date: Tue, 4 Apr 2017 22:56:36 +0300
Message-ID: <20170404195636.GZ20443@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404191732.31895-2-leon@kernel.org>
 <20170404193730.GA10780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t3Rhqlz/9+3FgEet"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404193730.GA10780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--t3Rhqlz/9+3FgEet
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2017 at 01:37:30PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 10:17:27PM +0300, Leon Romanovsky wrote:
> >  struct ib_device {
> > +	/* Do not access @dma_device directly from ULP nor from HW drivers. */
> > +	struct device                *dma_device;
> > +
>
> Why is this hunk in this patch? I thought Bart was taking care of this
> topic?

This patch set is based on -rc3, Bart's commit is available in -rc4.
=E2=9E=9C  linux-rdma git:(topic/ipoib-accel) git describe 0957c29f78af
v4.11-rc3-10-g0957c29f78af

>
> Jason

--t3Rhqlz/9+3FgEet
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljj+nMACgkQ5GN7iDZy
WKd9Rg/9HaOt8Ov7c1c7BLiCdz9kSVhiLxzTn/Xbxw5uYxwkdmcyujGHNNZOvUHO
JdfuZZPfQdvwOea14Z5EXX3rx4Zm988dbXH3Ewu4bCjSS6/FP5Ivw31oEHbH1SGy
euH1fzxEW+SB5uXZVKxyDGcVZAlKUDpRz3Iaib8Q/tzydMc2PKFjnV9IJ3chV/U1
xAcjr6CjO238RDWCS25uynjiIV5qT3Y/M/13fgQuNkXOb2kbwLtTjfuVZUS+Mguh
M2pXAAf9Y7KOaoOZ14Xc7qaEJ3PEGz0f2aeHxJP7mX928Ev/5V8kCBXydFWn4kwC
hRa1YPZcmnoGIoYiqB1jh/KTVGoQ3m+ntdZgehmAPQFm92AGJCZngznJ/5u+WOQ5
x0sh2Hf6YOWgF21oMK2B+nNeLUheRcylYYJYIXv3MPI54fjDD0yvEoSpYT5wkNrn
ycUIPsJWjU4B1rh0jsYn70qi0SC6BftG7cGyPZl9ePQj737Xi9uz3rD2AwQrlbnf
WR1lL2XSV91E6mUlDMvZbBZXZhW4k4yauU7gqTJSf7QKPxV4gTeii7vM2OM/IIpk
nYru4kZFPvIkWtfDKkKVEAJZTEnXz4G3sH9h6HKpj5MfzHyzqH9inR+/m+hB9vwQ
5Wv2Qo/O8BEoWS63NO7lm8uu9uWuLUnxZiCXppaHFKNUrWz1aGg=
=iPth
-----END PGP SIGNATURE-----

--t3Rhqlz/9+3FgEet--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
