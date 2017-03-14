From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: v4.11-rc2: DMAR: Allocating domain for mlx4_0 failed
Date: Tue, 14 Mar 2017 09:29:57 +0200
Message-ID: <20170314072957.GP2079@mtr-leonro.local>
References: <1BCFE3F4-A455-4EFC-845E-1FAAF3902D55@oracle.com>
 <1489429487.2658.4.camel@sandisk.com>
 <D34904A2-BEB6-4833-B2CC-97FA7B5B1029@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ee6FjwWxuMujAVRe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D34904A2-BEB6-4833-B2CC-97FA7B5B1029-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ee6FjwWxuMujAVRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 13, 2017 at 02:27:51PM -0400, Chuck Lever wrote:
>
> > On Mar 13, 2017, at 2:25 PM, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> >
> > On Mon, 2017-03-13 at 14:21 -0400, Chuck Lever wrote:
> >> When I boot v4.11-rc1 or -rc2 on my systems, the CX-3 Pro cards
> >> are no longer plumbed. Booting with v4.10 works as expected.
> >
> > Hello Chuck,
> >
> > Please the patch that is available at the following URL:
> > https://www.spinics.net/lists/linux-rdma/msg47043.html.
>
> Thank you Bart, I will give that a try.

Yeah, without Bart's patch the IB stack is broken.

>
>
> --
> Chuck Lever
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ee6FjwWxuMujAVRe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljHm/UACgkQ5GN7iDZy
WKcYBhAAvCsyF+yBRVHj6Mj85jtLsS2ek7/c+QXptkpzKFO7lPpQhcFKr1y2A7ox
n1aivaAzasplGXuonMPenp/N9nAn07F1eWbTC+6qQoo5UcuN7x51V5kMmiY94C2A
+hwjSstlhDP8/6ktg1r7q4YhGE0BreZFFUUIaHiViPA8wG7Pf3IeyrtAvBUYqPQP
qjg5qnDxSf7mbuVFCLM/NoexZNt7ZBJZs9K+lpIT/LZWnC0vhKx1HZS2X0HCX8qT
wNokVceZx3jM6PrO/folyN88qY6SEvP3tq0NWdoZGQ5WeERzGqaQn7RxedmWV6Cd
QYOMbwIMGWtBccreaHk1CKtCiMaWHexulG89q97l1P/b+eAoxcQTokmhinPxajkN
GCbwWoeDIhovRyieDnFQ/hy89jO0lpb4D7qGOkySzn05dXru8RO6Nfz9ItaiJy4h
ovyjG1+izsaAjb1JG7N1LPQ6vy1Ey+mIdBHbA4JgQklpnpcC1mt75gW1RdeB9N6j
cSi0j+EQDnvnbq/1LTdOiIQnBtXTA/sb0so8K+J0w8bg0nBSWjp8pxiJQVja01Hq
+t1Pg5DnS53QlTZQxcTP/N1BUsMDZR9nX2WjC3nKUW7VNWOMk2I5GzA/1IZtH48X
oj/X/ziz3BdWsZmEKdnHUOhmiu2+7eBF1JBC5c9VWaptWe/nmCs=
=2gZO
-----END PGP SIGNATURE-----

--ee6FjwWxuMujAVRe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
