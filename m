From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bug report: ConnectX-5 unable to use non-default P_Key
Date: Sun, 3 Sep 2017 20:32:51 +0300
Message-ID: <20170903173251.GQ10539@mtr-leonro.local>
References: <1503960898.52034.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r/w8vo2lxBmCPGjQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503960898.52034.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--r/w8vo2lxBmCPGjQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 06:54:58PM -0400, Doug Ledford wrote:
> This is with plain 4.13-rc7.
>
> Attempts to bring up the 0x8002 P_Key IPoIB device using dhcp fail and
> NetworkManager releases the device.

In rawhide, the enhanced IPoIB is enabled by default and the upstream
version has limitation which you are experienced. This is the main
reason, why we didn't enable it by default. Alex and his team are working
to prepare upstream patches from our MLNX_OFED solution to allow such
configuration and I'll forward them as soon as they will be ready.

Thanks

--r/w8vo2lxBmCPGjQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmsPMMACgkQ5GN7iDZy
WKfuTQ/9Es4RVAeBRXMflns/R/blm6W1s6fFqiEl9oPsPqvlDeIGRV3Xq3A5xdWw
9I4eQiHuctGBTyY/HvatBHikWHZFnYtKhvDd+e0Flk/7TkxySNkccRHy0wE0dMAt
vw93WT0y9578jpOEnbYV3Q6IEc24CQ0Uyl0ECsrov4jJxR2qXaTZxWJJW0psfOal
BUfP9S61f2X/RhrrJpHmoogO3dxXz/1D7wB3DIIXSBopuK6SybSHdddp+RiOUqfA
b3GzUyoz7K+97BSteRsQYnUUuEr42CTfoaXJdQB8XPkPcgtmyT8eLfDKjAQqRRAW
yrzygUphk2x/kqvM6JhcKx8mLP1quYUlikmIihrvcrlVgHRsYvjDewde9foLwAXG
YL5H5CDwL230bFmOrlmUIxpQL/98tgPt8KUOmrxNFwJ26Z2INY03sjXoWFBCEhZy
uyJ1uQYgaVcuebBHM4aW2qAwthDjE+/M1nwvYFiq4wBpFRyx1QKPicQwFeUQSSQK
WbsqRVkDigsTiV1kHgaxWraKQ00ZvIeMesPkNsDXQYUXiq0DA93IIoF5zyRJuVLX
FTMKfVHxTdAauMkjzn906/L5MyxP/0JHS2dfmEeC8drt8kIBRT0hFPQCzsTyTJWr
YToM749TfeKMQT9WdNaRpEVrlt6hr53tSsU2Ki3lvkEohDP1g3E=
=7kAr
-----END PGP SIGNATURE-----

--r/w8vo2lxBmCPGjQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
