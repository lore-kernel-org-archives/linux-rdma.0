From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Mon, 9 Jan 2017 08:51:25 +0200
Message-ID: <20170109065125.GT15685@mtr-leonro.local>
References: <1483866889-10700-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170108143032.GA22478@infradead.org>
 <20170108150838.GA2106@shamir-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Ocr+Jy+jPJR1APa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170108150838.GA2106-wNzywhU3BCWJbeQQAEUYZUB3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/Ocr+Jy+jPJR1APa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 08, 2017 at 05:08:39PM +0200, Shamir Rabinovitch wrote:
> On Sun, Jan 08, 2017 at 06:30:32AM -0800, Christoph Hellwig wrote:
> > On Sun, Jan 08, 2017 at 04:14:49AM -0500, Shamir Rabinovitch wrote:
> > > CX3 firmware is unable to work with 64-bit coherent DMA. If IOMMU
> > > support 64-bit coherent DMA mlx4_core driver will try to use it
> > > and VF probe will fail due to firmware error.
> > >
> > > Force all mlx4_core coherent DMA to 32-bit only!
> >
> > If this is only an issue with VFs it should be limited to VF PCI IDs.
> > If not the changelog should be updated a bit.
>
> Agree. Thanks for the comment.
>
> I will do that once Mellanox review the patch and say how wide is
> this issue. Is this issue limited to specific Mellanox firmware ? Is
> this issue limited to specific HW ? I have asked Mellanox all those
> question via our support channel and still have not got any answers.

In regards to this patch, it takes time to answer it properly.
Thanks

>
> BR, Shamir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--/Ocr+Jy+jPJR1APa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzMu0ACgkQ5GN7iDZy
WKcEnRAAvWoRmixQXvyN7UWSkKcBNXI/UAGQexN48bVPnWotok+SENmFyvt+Gw+A
+fjx8qDGFzzhnsTlHRWfOAoV/scT7K8NV5kNG6e7s7FnrEq9XNZmpHHLOi05yMmH
ZavhP++HZM1HQ9wvOdlUkLfZPjSPpZzu51O2Zu3FZgsb9M5SUc9JaZxUI9gZPtKk
SGAapVIHDoPODq4URTCgUJU3iI+sjmscWohvUsrkb5gIGst82W5a9RoRO6qIDymH
J9uqbK3JM/BBdHGmqKEgGLefanoa5WLjh1KtleNJYtOIghQFM+MG/3xrW6o5svzb
xRqO181E9lm3vsYjXQBtoIRwGgmGKziX1oA5F9tb26AxtwN6V/vJdXwjDRfjp3y1
9vgLDF9dZqL5M2TLS2Fx8oV90Jbm5xoD1i9zUWIIIlzD3iOJb4FL71BMUWwtjRuE
czEZfq0HyTDolQ57/TUUKD3xhCYS2Hu8DrpwV4uH7RVhBWjIQ5qhoNl5Kgzx68/+
S5Cg6pWb2RbDtb0JuovzGcLBwxZtbDWTeFZLKDPcuci9+lHS4cfLrHEzj5OzMxWG
qAxivrKnTEoVjzaEM5Wj8Fonrs6WrHEOjZbDGUlvb3eCGb1EvynrJHKmdmlZRDR+
RqQw2Q25j3rHuFdKUkotSgjnECGamWUTGCw+8tjkmsxQ21FzB1o=
=l2pg
-----END PGP SIGNATURE-----

--/Ocr+Jy+jPJR1APa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
