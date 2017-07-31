From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 20:08:04 +0300
Message-ID: <20170731170804.GE13672@mtr-leonro.local>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
 <20170731164705.GB28204@obsidianresearch.com>
 <20170731165453.GD13672@mtr-leonro.local>
 <20170731170018.GA19061@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pgNHpQPJFoUYTAIP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731170018.GA19061-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pgNHpQPJFoUYTAIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 11:00:18AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 31, 2017 at 07:54:53PM +0300, Leon Romanovsky wrote:
> > I want to take RDMA one step more,
> > https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
> >
> > I called the topic name "persistent", but the right name is "predictable".
>
> Once renaming is possible then having udev rework the names isn't a
> big step anymore.

You need predictable starting point to perform automatic rename,
currently neither index, neither names are not.

>
> Jason

--pgNHpQPJFoUYTAIP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/Y/MACgkQ5GN7iDZy
WKcJSw//c5VsZvmYFeUh1u5mK0qHKClJ6pO/scbUMOPZawEZh/sdspgH1fzQV0aW
IjdoZHqPl+99iBA+NOkfjzthMUv2uyaORKYDfyKrbBmNsYUxrv3vbcUUxUABTvQA
edHElHN02p3lTdmXyaq464K5xEDsQPaW+cJpP8am42Mw28zZbsZU2gIvtbxZpqeE
cz7jkhxWQgU4KekXkkyzCg4Dbzdb3nbrUnenNH27a0Qpm2FZc0/wN0+CoWKDz7N4
TancGWVeaBzeBShjdbG29fm3zpx8LjrZdyt2L3vupwphjx+RJs78gfhzHWh584N3
yr9YDeZayHigQxXo+g5X9TGTOsMUjMeVigtPi5fFIPuRBOS4Pg0bUJPEToDkppxf
HkFT/s0Z+znt2JZh4E8dl3jaLBxhqEFqeo1rciJuVC06nbluNTZzq+sPQcO2v4wC
kxL3QWwlcalxQ88PZWsTlBff6uwtGz+tLzVwRpOeNs0UDwaEt5jV838+ToW3gcz0
Mey8ZMIPxl7o3rBlJoeuZ6i45RxhXKwWHqWGk5nJ3/VylwfA2iGk6P1zPMlJ+u9G
/4C/4uInZvcjzejLV62sZ+Ahaopbnhdj//UGgmcsA8mM6tzgyzJ3SpNrUGr8LnXX
BAoxqJqaYbCOTUm+WIzwREAQSS2wAen6XipaFCob/mBC8PBRbe4=
=pHFH
-----END PGP SIGNATURE-----

--pgNHpQPJFoUYTAIP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
