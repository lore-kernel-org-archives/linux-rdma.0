From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Sun, 25 Sep 2016 19:13:15 +0300
Message-ID: <20160925161315.GD4088@leon.nu>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kb0TSCuX821Ar6UT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160925144121.GA12246-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kb0TSCuX821Ar6UT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 25, 2016 at 07:41:21AM -0700, Christoph Hellwig wrote:
> This implementation was also copy and pasted from the Linux kernel
> one, including the kernel document comments, and an incorrect license
> was added to it.  It should be removed just like the Mellanox copy.

Awesome,
Any suggestion where can we get list.h compliant with BSD license?
Is this enough [1] ?

[1]
https://github.com/lattera/freebsd/blob/master/sys/ofed/include/linux/list.h

--kb0TSCuX821Ar6UT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5/eaAAoJEORje4g2clinyREQAIzRYoiAwPgYRySYQ00dWlOZ
k9GYnQv8+0phoP9JQ8Y7gFERjuhJe6grGUuA3ksfypUXlR/sI5ATnlNZhAyzw4SF
0K7+E8CnsGbTI7fScsBQqc8jP6DOEJScQ6bfL+6zPjPdLWnTP4bcm9Ei2tF9ZAGd
0N4RFi7Tv1X0oqQPx6FuzTAkCugbsBFQ2Q/2KsCwrKsZnyIm96mGTiH1h8Y9qa46
ulJaB1t6NLFLLq9ZjDElkw7j04pzq4U0Q2CW5eAKAEiPvTycmhfJEVEnNTALsEU+
+Cf4gTwL346uk+hxtyah6dXhVrGGHWkiGia4bAEJgwGtDLzpe4BzOGf55FZvXM2W
zXh7u3XS07Mp8irsKpovNW09fbZGwBZhoSaHZAtMUFTBZGkchxjWvRFM/ia4NQ49
tANYsGTR4TyC3Shw6nytyalWWQLKOEFamYVVn+dIumqZdvFGJp+4Qht1es0sSWJc
oQCL564IhqZVoYCF5a7gG0v7VCmBjIh2s2mY2VUvu+kBdsTARkBrBadvJY4oZAFg
pW0qT8EyLrI2Axw7LSkipPXtJ8q7JVoVBEuG2vg2QtjL7RFgYebdkhjUX13fsAN3
YgPMtsf7PLuLHq8kmCQQ04vyJ/72RZ5C7hrg6Re8d4h7YUN7jBa4ul1Em5bvkfB2
71lpyJENSDMxBUyAAqTI
=z3P0
-----END PGP SIGNATURE-----

--kb0TSCuX821Ar6UT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
