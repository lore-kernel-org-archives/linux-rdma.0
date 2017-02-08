From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 8 Feb 2017 16:52:48 +0200
Message-ID: <20170208145248.GE6005@mtr-leonro.local>
References: <20170207174600.27218-1-leon@kernel.org>
 <20170208082850.GA11087@infradead.org>
 <20170208100043.GC6005@mtr-leonro.local>
 <20170208115349.GA18879@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8bbyobZNN6im4lYw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208115349.GA18879-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8bbyobZNN6im4lYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 03:53:49AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 08, 2017 at 12:00:43PM +0200, Leon Romanovsky wrote:
> > These constants are part of much larger enum ib_qp_attr_mask. IMHO copy
> > two values from that enum isn't good, but copy whole enum (mostly not
> > needed for the users) is bad either. So I decided to open code it as a fix
> > for -rc7.
>
> At least add comments mentioning the proper symbolic values then.

Sure, I'll send an update.

Thanks

--8bbyobZNN6im4lYw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlibML4ACgkQ5GN7iDZy
WKcBEg/+LKa5m6nh2bgyzXUEFi885gTj6RDV/r8qwIskdku8/7gH7YDPCDIorVM1
gzooGrP62M7vDaClPoFyt0JmF+EbPOX9MXfH0g8W037rlBbcNR2QXVI9VieJX3g/
qPU70QI4WTO16jBEEUPp0f0Jmv+g0KOcyLwUDBG8yyU70MxQ+GV6vbCpkS6n+0l5
M0MDn5D7rJ8mCzoiBhsCi6E6snjxtnLWGkRq1Z4ZV82gbVTH5MCKpGv226UQp/G6
mxPmuFJLFqlosPx9dhHyMTQLbKemNFIJ2PbjgX78M3tAviJqPR0qse2RhhP0lBGe
s+wOfmaQZQHLHiiGpzfPOwOE6kteUkWN61Gl5gZiZWDd5pkPaflWVhdmH+QZVdEV
5BtPTuD/dAFAwDMI9czzOi62LBNnZBdWollKNbRenmkGIlP94PoBGM3CDLavIjW3
3+9ExJ/vaqz1hNNW9Vbfk5atii7/TDeR8IAYoeuXqJ0mo5F6hO1TXmmcj1iPOqiG
FpzukJP4077vdT5/RxbAAjEabU1b2KrFF0WSMC4zmnIq6iL0H0gTeHCf9wZUgUdS
SNtMhJFE+uKYeWhaoA0awWTrxyYs8GK2Bb24EBh+pAGnJhHr4fv1OlAuWZDP2XBi
TOwJLGO6bxGDq0vjMa3WGBQTHMOSK/CqW2ZTtsIaCSR0UaqwoM4=
=wQXv
-----END PGP SIGNATURE-----

--8bbyobZNN6im4lYw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
