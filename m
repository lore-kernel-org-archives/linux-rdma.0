From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cxgb4: missing dereference in poll_cq
Date: Thu, 13 Oct 2016 11:58:51 +0300
Message-ID: <20161013085851.GY9282@leon.nu>
References: <1476113253-16880-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UEl6xVrmin0CpRyj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476113253-16880-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--UEl6xVrmin0CpRyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 10, 2016 at 05:27:33PM +0200, Christoph Hellwig wrote:
> Sparse complains about using plain integer as NULL pointer here, but
> I suspect we really want to check the value anyway, and Steve
> confirmed that's indeed the case.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.

--UEl6xVrmin0CpRyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/0zLAAoJEORje4g2clinTfYP/02N+NXdNT49jrcrkOLjTtWZ
6b/SrGbrvMxUZSgxCcT/rxHpo5U4nnkZnCqqrfEiEa3VOJ8+TAk0rD3JjPzq3ME6
obms5S0u3Camksgc0ByctNmQRM1F6hTiXucIvFPlN26Q6jTr8izQJj6g5xVXxWrN
zOYrlz1kU+1629bEabcYNmZqdY63jriIB0q1ILITQmMyQtHIk8/z24kdfnVZWc0c
8NyovR5fDdqi4oq7N4fQn4K29qOQAd0Q7XaSFhvXeHjcluOjrSApAXdEV4Dar9Af
0xM0PLpRT8L7I0pA6r521pB6lBzZ03vm3OEYloSy9pBYmJUOH+9a31OfWYhMf5L7
znVqGRrSWeg/5Ks1JcBj4/ibKwRWQDM3Drds9C9BazjGiu1eyofoY7Emc+TtaMwW
Si6jfUr17mzqtztbVAWDwo+xERjnpY31kOs38upz4fbnqmgFwGmpDsTe3avjMZBF
qvxeULgb6kfA6L81KlmJ8tmxbsFlxkcNYEcQWQzO60E1NYILIeM2hRau4B/vh5Ct
TTdQt/UKfrk2+9xusTisqSa1XxlWMA9ILQnR1aLE99ApA60BAwMDhlhAjNTCJ+rD
v4BCfGHYGN6Owc/g1yupQc+rVL/YCIaccW8w7LN2cz/CX8H61AOcHXO/Cpfa9LCP
4f2aR5cUrIrSMT5JkqJ/
=JgVe
-----END PGP SIGNATURE-----

--UEl6xVrmin0CpRyj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
