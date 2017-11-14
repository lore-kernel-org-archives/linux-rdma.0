From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Tue, 14 Nov 2017 20:27:20 +0200
Message-ID: <20171114182720.GC18825@mtr-leonro.local>
References: <20171114085143.GS18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g++0NlQhRgFs6nMu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114085143.GS18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--g++0NlQhRgFs6nMu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 10:51:43AM +0200, Leon Romanovsky wrote:
> The commit 25f07300bfb7 ("vmw_pvrdma: Add SRQ support") causes to build
> failures in Travis CI [1] and on my system too [2].
>
> Please fix.

I reverted the commit, please fix compilation error and resubmit.

Commit: 32bf4efb8605 ("Revert "vmw_pvrdma: Add SRQ support" because it causes build failures")
Thanks

--g++0NlQhRgFs6nMu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLNYcACgkQ5GN7iDZy
WKeuaBAAzXPPg8csJuLsZ+4hYCxCq3Bgfa1+HOmylzJZWTWN1F6Xjvh1sTh3pXqi
TaXnxbSU7TO9xvyeHIvqtCz/mOi8evluVLZNUCFHjQ0ZUrMqj5jn9RmJwmdlw3NF
gbMkgQTscZreED2G9erEFMmswXObmzUClT3xIomi03ytadygMNZcm4yz7OeyjdDB
2YE/CZzi6Cz1L6DPm4bLB8EIeqvyqDdVrNDIHFko4suADv/TRpch/IuAn7LReQYE
H+oaaGVa9pHIueOIM8pYFh1xLDqOtNmDqf/3Yre/KchCDZ5yWvmcEmKcpOFFUkB1
9a/q+Z+LGlhFgX1Eq/3jAoBU2ff0dIdbAIuErTno/U+ygrbQu+6VfUmnUKWiNYpl
/nOeVQHpyS2FR56q11BtVzY9fwOTc53rIY83kZYThipDupp/kZk/aF5WOJIsr1Kz
5Jz6V3pMbpYfMC9N1JWzIeJQ9SPWPC6CMvZYFjxWVbP4M9h0JagKRv9zIqkVE4td
01v83L2euvKmN5FZWUup5DGD4U5aCAHKWS8W5EZrmChl5JJ/63HMRvApdVW73iZf
5R803DzzlLh83WMLBHbDyLZVJ9AcqSudb/Oq3Rg1bfpDsrLw1EPI57ypeimlxIht
a0Mpy1PSoNcza+9Zu8Ki3Y8KzVGTWk+7pyOCdw28PoZdIEAwVJo=
=LUA9
-----END PGP SIGNATURE-----

--g++0NlQhRgFs6nMu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
