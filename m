From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: hw: ocrdma: fix bad initialization
Date: Sun, 4 Dec 2016 08:20:37 +0200
Message-ID: <20161204062037.GH4497@leon.nu>
References: <1480770621-6249-1-git-send-email-bianpan201602@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="X1xGqyAVbSpAWs5A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480770621-6249-1-git-send-email-bianpan201602-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pan Bian <bianpan201602-9Onoh4P/yGk@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--X1xGqyAVbSpAWs5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 03, 2016 at 09:10:21PM +0800, Pan Bian wrote:
> From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
>
> In function ocrdma_mbx_create_ah_tbl(), returns the value of status on
> errors. However, because status is initialized with 0, 0 will be
> returned even if on error paths. This patch initialize status with
> "-ENOMEM".
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188831
>
> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--X1xGqyAVbSpAWs5A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYQ7W1AAoJEORje4g2clinGH4P/0gGFWqiEBgYNrVK9uWPzwPh
dp6N8PMG89mMSVO079c1xj+s0tu4q/J7DVhcdpDKuD6Scwpi5CPva9lOohRQPZzv
YqJOyprA4Vby1Jd311pU0KWtREcw85EfMTQV34JkFM7UJboCfFFKJ4OHwI/FL6ds
UiRLiwv6iFqzZaQGQQDkIe3fFoo8KfxJ2sKAj/EO+JUfZCIv9+pdxUbiVF78fX6Q
n1qQJ+qLRWhHIjJ1IaujlIxWTicQC7hxWXmXBuuDQSWoSFx82rfMY1W0lD1kKzJ8
ab1mpKMHtUOuGSnKTWrrY+yuuD5M3LGqJHnq+eOXAfy3A88g5po19+21O7hA1Q7P
0F/bCVbyYUjS5pw0gu36g0LMClxyoDe1bpyZuN2tQiDqcDcHJxKIMPc74JU3Oe4F
9jRfgSHIXcBr2xVWm1xvV63mIkPXVfNO7WrDgJjn25gnYkM4GJtcRmRMhPss+hkA
O4xJfPxhHer4vTtZm5Y589WwokN8zijBR+rxpjuffL/eGsH20fF3kTnO2kTNxmb3
h1U+PyEMRnUhwza3cIEPWVQxyDlUG/MOOOwdT8ibpco5q2LbGzXqa7GNgHRnOp49
/BN2Y27vV3l2VvA6tS3NnW3/NJ0JUoeWijMNDUKui1pEC2WOj5kDWpIgZeVueT7Q
oMLzjYETfNEJ2e+rYMlu
=E+kD
-----END PGP SIGNATURE-----

--X1xGqyAVbSpAWs5A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
