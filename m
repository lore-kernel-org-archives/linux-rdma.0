From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 00/14] RDMA resource tracking
Date: Thu, 21 Dec 2017 21:52:42 +0200
Message-ID: <20171221195242.GN2942@mtr-leonro.local>
References: <20171221181748.17126-1-leon@kernel.org>
 <20171221191424.GF20015@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3cI6DWK3Xt33P8nt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221191424.GF20015-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3cI6DWK3Xt33P8nt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 12:14:24PM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 21, 2017 at 08:17:34PM +0200, Leon Romanovsky wrote:
>
> > Leon Romanovsky (14):
> >   RDMA/netlink: Simplify code of autoload modules
> >   RDMA/core: Enforce requirement to hold lists_rwsem semaphore
> >   RDMA/core: Replace open-coded variant of put_device
> >   RDMA/nldev: Refactor nldev handle to be common function
> >   RDMA/core: Provide locked variant of device name to index function
> >   RDMA/netlink: Protect device query from device removal
> >   RDMA/nldev: Protect port query from accidental device removal
>
> These all seem totally unrelated.. Shouldn't these cleanups should go
> ahead right away? Can you send them as a non-rfc series?
>

I can, but it won't change the fact that we should review those patches anyway.


> Then we are down to something less intimidating to review for resource
> tracking..
>
> Jason

--3cI6DWK3Xt33P8nt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo8EQoACgkQ5GN7iDZy
WKfNyQ/+OlwhwvXYSGxmkwd8qroTYaxpuKzGVF70z94Un3SDPul1/bgFti3woBI9
7C8g2EhFcYgk2TPyLyjsRchVEevwJks5Yzatwjw3tryuY8dYh3fpZc2QjMhb3k0w
DFNjADGHal/627SYQ+jLhKnpjlVWG+kMBLgEzZBRUgGrHhIivNInZWgP9GTEKj/G
7o1D/WL/u6TPxspTAFeba0NCWKPfrW36QUX0hAY+u3USIBOM2pjZEsyEVDvT8+G2
u52UIWly6t4b0rwqAOQrwhpq4ug8D8zLXzUBTHx3ttgrvJC9cM4umPwKmvVjr3/G
/2+t9gYMCAYMq70VJ6lLVBPpSdMEWG85iqJp99c4TQ68yrLfn1cuh+LNy09uxVsJ
wvYlscrrD++A3wmK7nvNJzHTlU5f+FaayrkX1RDM1KMyEZm6HmoBQhIqhkUumEPN
3dA8nNuije93/cSxpYO+TXyMb8TUSM0IbEe05wk12BznPMrKfimWzz84vE5kKhCL
IPazCThLSgiRZAvBHggRN/0qpQiZIiFxuNkmdmO44wT1XGIVL6zPc9ZyLWbfrLos
Ivm4qvxsoX+S6weZz2ee8rTcqZJVfzo2Y2sqAZrqTktlYEoKgWkf+Jj5RoFrhVKa
KkOjmc9JspbgLUhAC1YqIpZ8SJvHgXbYfjLP3NBdIGwq7tTh6VM=
=sNKX
-----END PGP SIGNATURE-----

--3cI6DWK3Xt33P8nt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
