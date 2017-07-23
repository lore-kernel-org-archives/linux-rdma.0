From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Fix kernel panic from skb
 destructor
Date: Sun, 23 Jul 2017 08:21:39 +0300
Message-ID: <20170723052139.GZ3259@mtr-leonro.local>
References: <20170622141000.9899-1-leon@kernel.org>
 <a99bd03b-ea1d-983f-f76a-4798baa55fd4@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pvq4FPIYehQuVelz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a99bd03b-ea1d-983f-f76a-4798baa55fd4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pvq4FPIYehQuVelz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 22, 2017 at 01:14:26PM -0400, Doug Ledford wrote:
> On 6/22/2017 10:09 AM, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > In the time between rxe_send has finished and skb destructor
> > called, the QP's ref count might be 0, leading to a possible
> > QP destruction. This will lead to a kernel panic when the destructor
> > dereferences the QP.
> >
> > The operation of incrementing QP ref count at rxe_send and decrementing
> > from skb destructor will prevent this crash.
>
> This series has been applied to 4.13-rc, thanks.
>
> FWIW Leon, if you have a series, even if it's a short 2 patch series, I
> prefer a cover letter.  It doesn't need to be long, and can just be
> something like "I have two bug fixes for rxe in this series", but I
> dislike responding to a patch and saying I applied a series.

No problem, I'll do.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--pvq4FPIYehQuVelz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0MmMACgkQ5GN7iDZy
WKdxRxAAlJjLsiUe7bgrKGo6Ol/d+rGf+T89OipmAgGznZGZtXt4Kld6Dycy2OJg
K/SDmrDXW4zxpqTKoCxAV9AMbbVv/iTUNV4lJAKZ7QHF+MS5W0SIr1qGPKv/HhAv
/NGRc4bucLvwMjfIdSxJMFH5bUzk769fCJLATAuwe81cYFPCuQzG5IfxjMFjxgvS
6DmPLcBka1PUDrDWj9cSfYn6yrKYTFJy/t0GXg43+iK9wl6uhi6B95VmSevCye6Y
T6gai4v9ZaPuxpOdXLWW9jFSM6UGA+wYkE7EM5AoSGGSozKDwgr7WppWN2rbfoY/
xDhn+iNHu3hVgAoQYM8zs83WiB729EK6JaAILS9jkM86U3vnI537RvryCLV5zOQo
xu6VNBFFWumY0Ub+GIDz4YWrdZfs6evKydiZ3jxICUXrmRc4reNXDm9Jo7EVc0V3
CfbWbS4sUrA7LR1ECH1EJ9Wd6iIvKrNfLNLv0bJ6/gNFqLIF46ByztCXGGOpuYvY
uX5RCSJqx4wIIeuRlK0tYRF2rD+XmNqpe+5obZPbNg8eFOomfmO9jNuIZFbOiMZJ
r+DZvHz6gsraUOG1h65UDhG1KI/+TIrXp4MVkrQVM0Tt7woTIIoC2KLTRrujO5Vu
Dgz+taFPBSObS0obLqryJkdLxg8AR+Dp1l/P/RZd5JVRqypkXGw=
=ODVy
-----END PGP SIGNATURE-----

--pvq4FPIYehQuVelz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
