From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
Date: Sun, 4 Dec 2016 09:17:34 +0200
Message-ID: <20161204071734.GI4497@leon.nu>
References: <1480833938-6284-1-git-send-email-bianpan201603@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480833938-6284-1-git-send-email-bianpan201603-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pan Bian <bianpan201603-9Onoh4P/yGk@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 04, 2016 at 02:45:38PM +0800, Pan Bian wrote:
> From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
>
> If uhw->inlen is non-zero, the value of variable err is 0 if the copy
> succeeds. Then, if kzalloc() or kmalloc() returns a NULL pointer, it
> will return 0 to the callers. As a result, the callers cannot detect the
> errors. This patch fixes the bug, assign "-ENOMEM" to err before the
> NULL pointer checks, and remove the initialization of err at the
> beginning.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189031
> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYQ8MOAAoJEORje4g2clin5mIP/RDrMMH84Lu744Uusiok1k4i
XeOqvfvhsg8Q4IEqRZOlfV6+Ol2CwGwtxI5Ke6f+7g6qPbyGPnw1pxgGTFFrDNLh
oAFAzNy+2Db7dLesEs9O/jZyplh5yor2jPU3r5YQCICa5KH9oE6wY1lx4dOi3ZyK
D3esyteAYxULN8LqibE4hN0bKm4YX8Y6iLPuZ6wq+uycT6Pv/Dp2zI0zuKOENu79
rU2VhENQmgGx4uDTga93wXM1/XKQhU1lDrSQylUgrCohuysh/E9KnAbEC2Xpseaj
Mg6588vohhulJC24/yOiUSDpEMDn0ws42EEaMGTQVd3ReuXIaWFTmmsUuOAojKaE
hRnfN3Iw0vOpSfLr6NMYtRJSuo3Obfw2JD5CZqbNgbBwa4v6Rrp4OnPHC/7fgMof
Np6oFqytdJWxxWxKAUJGX+uEb4BLxKVzUOkDVmnpLoYfTpJ65g0wzbJOfHsm9ONA
/vjV9Q74bkuUm1DuOQx0m05yXCQl9LnhVcCzGlLdyANc3ysv0e+gRl6mdPpuIiUF
zn06Tlo4bKSXaBsLACmDDVGMy/ecE3Sc3DeU6gdncfPml9s4z1fkllC5LgLR+lwp
blb2XToUuboyErTCBqIq6ef4HmKgsJLhdmKxcNHIBOAYOdXSJLaNFfNSUE9jTurf
kAGPvNw9IjsRH+LjukJU
=f1Wo
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
