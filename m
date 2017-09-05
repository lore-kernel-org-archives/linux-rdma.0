From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Tue, 5 Sep 2017 07:34:14 +0300
Message-ID: <20170905043414.GA18084@mtr-leonro.local>
References: <20170904152848.3471-1-yuval.shaia@oracle.com>
 <20170905040826.GB1070@mtr-leonro.local>
 <1504585010.3360.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504585010.3360.10.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 05, 2017 at 04:16:51AM +0000, Bart Van Assche wrote:
> On Tue, 2017-09-05 at 07:08 +0300, Leon Romanovsky wrote:
> > Why do we need to be dependent on CONFIG_BROKEN?
> > Is it still valid for IB stack?
>
> Hello Leon,

Thanks Bart,

It was 12 years ago and it is worth to try to build without BROKEN at all.

>
> As far as I know "&& BROKEN" makes sense but "|| BROKEN" not. The "|| BROKEN"
> part was introduced through the following patch:
>
>
> From a2b2f45be7e9138bde7fcba3b8e9257fea04d087 Mon Sep 17 00:00:00 2001
> From: Al Viro <viro-1walMZg8u8rXmaaqVzeoHQ@public.gmane.org>
> Date: Tue, 23 Aug 2005 22:45:41 +0100
> Subject: [PATCH] [PATCH] Kconfig fix (infiniband and PCI)
>
> infiniband uses PCI helpers all over the place (including the core parts) and
> won't build without PCI.
>
> Signed-off-by: Al Viro <viro-+pPCBgu9SkPzIGdyhVEDUDl5KyyQGfY2kSSpQ9I8OhVaa/9Udqfwiw@public.gmane.org>
> Signed-off-by: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 79c8e2dd9c33..32cdfb30e9b4 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -1,6 +1,7 @@
>  menu "InfiniBand support"
>
>  config INFINIBAND
> +	depends on PCI || BROKEN
>  	tristate "InfiniBand support"
>  	---help---
>  	  Core support for InfiniBand (IB).  Make sure to also select

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmuKUYACgkQ5GN7iDZy
WKfT3g/+OhEtZYuq937638EPwrYmFVa2fR0lSRDrkkxn909xUwX1k4Kqz2c6UVM3
QijehdEPY6JMJzA7WuFrearc82Hw+80V+FtVd7aynQ9WyUfdf9CTVZWDDQxNqCJr
9PFZaIcrv1a1gOGe/tNU3+Jyg3FBpTTS120jHdFDr558mfxxHrOV2gP3RrHUg9L4
xrdimQm0a9EbzMpNuP2mo+T6dOnvm0sT0QFmUVqtsNwHV6jM45OJuKS1C4vLRTRW
dMv2nCdSmnWzf1Rar8/rJH7vAZfz2IMNAyYmbJgtRswv4BL9QKmwWivjNFPLQ53f
N9T+Eh0b42m1ZmkhPpJt31M0MRP3nQOnY8M42Lt3jydv1cK3+ZSWpypQuYMogo/+
BG/xNqNFEl15p0bkKU+fY6UTzaiCHg4IqcB/PsGHUIE0gCv9283mi7KY2CkGGPz1
fVz+te0ScSH5lUYamzfA2etth8h16YJd7gb4wGMmFbLU3e3CEn4338tQes+gkYAy
WmpA801zuNIZCdTkbaU31HwFye5+9mTXv4GDPDO1IxPs/P2y8QMjSAQpgMLufMHU
kkjFTbJhjc54hJSR86q4/PUZKskiifnFQfPMj+WmVPP0Trx0000g7QcCWt6LEyYC
dmuubn89s0D+F1wDPqU/9BaQjwiKl3bnNlQkxpV+0yKbWbMIPK4=
=kxyY
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
