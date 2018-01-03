From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Wed, 3 Jan 2018 07:25:29 +0200
Message-ID: <20180103052529.GI10145@mtr-leonro.local>
References: <20171014064132.GT2106@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF406E95F8.33CF80BB-ON002581B9.00073D6F-002581B9.00081F69@notes.na.collabserv.com>
 <OF663C0801.8471532E-ON002581FE.003B73D6-002581FE.003F2369@notes.na.collabserv.com>
 <20180102213706.GB19027@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180102213706.GB19027-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 02:37:06PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 22, 2017 at 11:29:38AM +0000, Bernard Metzler wrote:
>
> > One question I have - what is the recommended way of replacing
> > those module parameters, if we need to flexibly parameterize
> > things from user land? For the rxe driver, I see the usage of
> > module_param_cb, but this probably is not what we want in the
> > long run? Would a sysctl be appropriate, or a char device
> > (we may need to pass strings like interface names), or configfs?
>
> Probably something like 'rdmatool interface attach' eg cause it to
> create using the RDMA netlink protocol.
>
> Leon?

https://www.spinics.net/lists/linux-rdma/msg58498.html
"It looks like "ip" tool can be good fit ..."

ip link add ...
ip link set ...

>
> I'd like to see the same for rxe as it solves module autoloading
> problems.

+1

>
> Jason

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpMaUkACgkQ5GN7iDZy
WKclxBAAgpIO6z0qwkH7SQbbJdcZzSQYVDxXrKWXXww5Gm0+s5H5lxjhO9l3TBYi
n4chdkVI04ZRdq5YnR7hD9jyjVY6FOiDqbz/ENhM4IadgHj2oQ+Z2x+CQc4akZF+
ym0yJdWu01JTOg7rOMOnUy1pqwhn17cz3SohDQTHkE/dFeUnQ+8Rg6wt6orxd0dG
jl01DL0rxGuInYY0Fg61Xda4ypvm+SWKrVk2hj4nNOfC+fOPyr65xwdPhbS4R+5K
nv8FzoCwivshA+U/08XY2sbqxq8RTY9ZleXyfnRW3KELqn7Rc8eMEzNH6kWmDRSn
SewcZiUpak1oQZKW7QlPnWy2uLnuZlJI7gNFNTAKUvsKFsKPW0txVdG/7zu86Inf
VvuqvufsyP6UDJpL6HfnD2iB4gkD4BXW2TDJxzdiJHo3tHVW8dtHfgQm8mfhWoyq
1im4NtvMS9mwxLo2orvxSRPD9jfMnQqL9NY3g5qudq01LzITgM2c/ILdHPEuf1V8
1ZlJ+eXal7qYeVW4kxCITXKSzn8Q7cLAH66HuWKUUBpy6WrPH8SuY09CuuMCHjcQ
iDBQ0PyVGycx7UJpYscHnsSda6n6NeSTA13as15Rocno2/xcBw4qHdkjyrT12QuW
18iUF4I5APOWOnNQBPzhez003+VINISVgIMyWvEQg2D9bB9jmI0=
=iVGZ
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
