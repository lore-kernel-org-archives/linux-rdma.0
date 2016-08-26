From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 26 Aug 2016 17:44:15 +0300
Message-ID: <20160826144415.GC594@leon.nu>
References: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e5da14cf-fd5a-895e-5fad-9020b6a7efb1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 25, 2016 at 03:29:12PM -0400, Doug Ledford wrote:

Hi Doug,

These two patches were supposed to be carried by us [1] and I explicitly
said that. Especially, the last patch in this series is wrong. Please
revert it. The proper patch is [2] and it was supposed to be sent right
after our shared code.

> Yuval Shaia (2):
>       IB/mlx4: Make function use_tunnel_data return void
>       IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one

[1] https://www.spinics.net/lists/linux-rdma/msg38580.html
[2]
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/commit/?h=topic/mlx-fixes&id=d5a1c56c3a49db6369b36aa04fbeabc7653ae107

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwFW/AAoJEORje4g2clin7WIP/1Xxgw7tLbXeQh1SLv9UQC0w
rSGTx7KxAiyHXGj4Q2Flh7Z8rHBjX4HqQGKydw3E3e/8D5L2NtAztoNJQfXJrmU7
W3+1Nu2WgSaaTsyYKGc00RPDjhmNqA7dYGpbHidxYzy5oVvqbyHTQp7MtL54TONx
GVIVEGi4k5/9cFWcZf1OfsEXt21hvonedYF0sDBiS2EB7VwQbeI1wHtD+Sxigr2y
/YIQ9Pxj6FU4gfK5Ztgv2le7Zm9gUkrVfvRpg+j3QkJ5k4lP9W23/tmcPBc9003t
5hEZiMOnBFMZq2juDpXNCuZUNB8S114027dHhv/na/Ujikt/XZKattQVNj77ZLlJ
reKvYlqNV8nWSihJYVWgWn+5VC/jWgrVaKdchKpUL+w/MtjwOuMPI7TbTLNDlyhW
p0yBrrPe/R2od+ZfuCYuCppRU+OjndPCAbU4MiPP+54UtsGqd94ZmzlyqINz8zsw
43CPIUT+irnLBuR7lo7JCVu541KbxLJwcnyb0YbbI55GE2LyDsiFkfPJiZG1pyuq
b2rAnbz439pSX0gRbAofiP+r3IZjPH+O18/UkvPZmBNLjUbXqlvi9Z1PxMnla9hp
46/8jJVfvxXFrr+FlfzDKWFfVkKqIcUej7ohBZ284rS6+E2W895pEZ+5DL2uu/R7
LPspEtOLxVVW8vRtm7PR
=HcDF
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
