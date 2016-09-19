From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: avoid putting a large struct rxe_qp on stack
Date: Mon, 19 Sep 2016 16:28:11 +0300
Message-ID: <20160919132811.GI3273@leon.nu>
References: <20160919115826.553858-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160919115826.553858-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2016 at 01:57:26PM +0200, Arnd Bergmann wrote:
> A race condition fix added an rxe_qp structure to the stack in order
> to be able to perform rollback in rxe_requester(), but the structure
> is large enough to trigger the warning for possible stack overflow:
>
> drivers/infiniband/sw/rxe/rxe_req.c: In function 'rxe_requester':
> drivers/infiniband/sw/rxe/rxe_req.c:757:1: error: the frame size of 2064 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> This changes the rollback function to only save the psn inside
> the qp, which is the only field we access in the rollback_qp
> anyway.
>
> Fixes: 3050b9985024 ("IB/rxe: Fix race condition between requester and completer")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Thanks Arnd,
It is much cleaner approach.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX3+frAAoJEORje4g2clinRvwP/20emKinhCI5tw5jDqq/iiix
/o+ts/ome1bIjordQDXPtGW6uzwnnQLG4jW1IHr3U2U2onjxfhtrUH4OfL1FM4Y8
whYnTHpKwbhprEkQo2K6LjDAlkvIINVOxgy7HIz2q+Qtl7OhBSHtxmSf2d7TMiZ4
vhG0ZoVPzn0VcYX5mwVZ/aOJqwrVIm1EgcWV3GIPD1pyB/eB9z6LgKX0ulXcGs3e
oQg4S8mp+fh5b4ZwqTZYz/eAkJp5mjNIBqSbAELOC1m6WZaboAWrys8tJbFwASfd
uQarrppeHh07qn5YqhNMNF3RRwQ7UeFH6YaARrGT67QBYGOe7RFLikjHtEz4EDaF
CYL5E7NcvNNXdS3nu7GIH4iQ+bU5exwdU4Eb9sAci06weJW0sQjOnVj2Mtg9QheM
fyM3v5+SitjVC2ww2nedrH73CPhqzIO3eFfPdhilyetnUAOEZUpLuq6dEzbgAhld
MU8rODdw21yAsEQPRMPzZjLLvwHlje0qSyz/iMaxVwtse5kbdbD5ekPiO6wuzmAc
8DiuWm4N2Y3wC3w3QxryXyM+RjXu7HfKT8txPHQRkIWBeodeYOSOIuwEW2w4GM2G
U9I+ISMSP/ZGBevm+e7iC44qKefsoz1wpQ2RijpamCjbzJ3ndP2SKppCpId7uTmn
rrOKuFvs7b3bW+4xULV2
=ekQc
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
