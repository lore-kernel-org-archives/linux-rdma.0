From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/srp: fix mr allocation when the device supports
 sg gaps
Date: Wed, 28 Dec 2016 07:49:39 +0200
Message-ID: <20161228054939.GC26885@mtr-leonro.local>
References: <1482864552-27605-1-git-send-email-maxg@mellanox.com>
 <1482864552-27605-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482864552-27605-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 27, 2016 at 08:49:12PM +0200, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> If the device support arbitrary sg list mapping (device cap
> IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
> IB_MR_TYPE_SG_GAPS.
>
> Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjUnMACgkQ5GN7iDZy
WKfvRg//bkGEkkqzqk360D5LSdAbNIk2gSKiGjXluMaOJ+r8ooMDoNCXC87nam7Z
fF3B6GDNaemvtQoq3hQItA6zGmH6PeYUMqK3iBoLmKo92EqUvrxYOqmr0KUbE9x3
2eJdZHsow1C6DuGK4H/IW9YDF5mq0Nv9dmg3sgGx3+6ac+TtMNqNZ/dIpVQ+VJGG
NxvMCagNqTUE430YytSov3w3nXPYbMOLiKv6bJduWyRTyMJ5Bfx5EXCF45o9cFpV
K7DCCB8RTdIvT9dIMrFsI5i68vBxIIy8x9igr3TyAxvOEaEFZIM43MUVpDfDlGmk
lbsXtT0l56g1pFnnjoyKWFJSaj61evo7empsmBRhUcDZdgVmVUhl/tM6ZFCBi2xX
BgZjORSrWLXSEYbb+oJnoR62stuRdUt0civY1OmYo7eY9hEmLGUgO/tu+ymI+4FK
d4NJdRPFUrX2h9YWfuwjq+R1iueLtzWuFbUbducSqYfnLYzS4yJgNCE9GcL6V1T2
64VnNQPK4hxLv3O0WJYJe5iePfLCr0D5TVo2nEfIl5Q7h2Krlm9Q/N/pHVWsbQUA
3GdN/saPlflcZC29T378JMWJ6wy4QXWp4wym9s2Q7gyEOkr19ydA+jf1Wha2ELe3
Ujk0frNYPfpEUJf2vwKpPqQlB1mhORrYQer0zDonT3YgFy66LAI=
=nGVR
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
