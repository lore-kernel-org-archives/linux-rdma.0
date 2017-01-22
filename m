From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Sun, 22 Jan 2017 10:05:08 +0200
Message-ID: <20170122080508.GE28570@mtr-leonro.local>
References: <20170112193508.GO20392@mtr-leonro.local>
 <20170112201622.GA14584@obsidianresearch.com>
 <20170113150824.GQ20392@mtr-leonro.local>
 <20170113171234.GA30551@obsidianresearch.com>
 <20170113203127.GT20392@mtr-leonro.local>
 <20170113212721.GB1463@obsidianresearch.com>
 <20170115083543.GA20392@mtr-leonro.local>
 <20170116201218.GA7890@obsidianresearch.com>
 <20170119131258.GT32481@mtr-leonro.local>
 <20170119173352.GA8109@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170119173352.GA8109-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 19, 2017 at 10:33:52AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 19, 2017 at 03:12:58PM +0200, Leon Romanovsky wrote:
>
> > Let's hope that we will find such brave man who will
> > remove this line. The removal of this one line will
> > require from him to do extensive testing and reviewing
> > different code paths.
>
> Why? We already fully support this configuration for RC

At minimum, i see here one new path which should be tested.
Configure small MTU -> Join multicast group -> Configure large MTU

Before removing min(..), in third step, we ensured that MTU won't exceed
multicast MTU in all flows.

After removing min(..), you will have a chance of flows there MTU limit
won't work.

And I just saying that it needs to be tested.

>
> Jason

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliEZ7QACgkQ5GN7iDZy
WKediw/9EOO+Y9iepPAbAhq0ZVKfEIM6HwUVz6tF2Tj/qe+pobrbSoogX14IDQFe
nQacVE2Je0G8L0iaVErkoCkRC4qpxrjUvAY5IrJO24c9eelCrs2mW3ybfA1YmNwM
yEiaBN6kbh11SLrTKiQtW0gb/3tvOmy4uf/yAkmQdnLO7P89B1hKhzMZX44v3kXm
REsHowxrYmEbkLQPJ4hb/+SZsJB1+hK5lw3e+IOXeQlYKZroSywXx7ftBkXy5e9c
SWv/R6NSD3wTe1bbcgydf9BjWP4ubY7sHN5PraloaYIdzQIsLAuDFUT/eoZHNeK2
o+1td2nOGA5mSjq/60+brAzdCc1KQ4ai3cNlfZsnB13oYH+d4GspeSuLpJiKEYUs
TkKTh0k9Av4cIjI5jPK33hprbLPKGnlEpMM6cUnaKWAW9TcTf1J+GiJWizeBUvgZ
lCqF7ehs/o+RaTlPrrQMjidT1gwFdAhEqlTEZMs0YSH2N9QyA/y8kYLgwo+jbaG1
CerVUuibzoTImnkSF0PddHsbr236q0D157LNxHftQrz3ePJi/YlfRxyXOZONscoL
qu96fBMvN4r4FGtHrmJwPOjpm3IFE4+ajnXU1Pg7iLtEtm8Ta+TnFL34uFJeIIB1
rUSBkgCEPFVI2UbpP9nbXx8Tl+lrbmcL2ltXWPLMNwiTTZ6RiAM=
=D13A
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
