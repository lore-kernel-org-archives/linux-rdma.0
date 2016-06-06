From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/srp: Always initialize use_fast_reg and use_fmr
Date: Mon, 6 Jun 2016 10:17:06 +0300
Message-ID: <20160606071706.GQ7477@leon.nu>
References: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5@sandisk.com>
 <4b1522b5-31a2-9c7e-6b20-4e859c009345@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPipYVl+OcoAvSh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4b1522b5-31a2-9c7e-6b20-4e859c009345-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6tPipYVl+OcoAvSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2016 at 11:39:35AM -0700, Bart Van Assche wrote:
> Avoid that mapping fails due to use_fast_reg !=3D 0 or use_fmr !=3D 0
> if both member variables should be zero (if never_register =3D=3D 1 or
> if neither FMR nor FR is supported). Remove an initialization that
> became superfluous due to changing a kmalloc() into a kzalloc()
> call.
>=20
> Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
> Cc: Sagi Grimberg <sai@grimberg.m>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--6tPipYVl+OcoAvSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXVSNyAAoJEORje4g2clinvzcQALekg0Lb5dkP/3OVT2uxeeS6
WXfqOkOEFN0Lr9qFMhk94sUbm2UxG2vYh7ZWC7MeBudUotyPGpekCktpa4Jl8uF/
7dXEBb7NLfCDpLBXB3XUnucHmIN4EaXk5KBUJZm4hYcYKBFT3E+M3i2s5auV/r3m
oupjwct6kR5uHtJjDzkF3dwsVHeUlb3nscmszy8+QGPS+wd18Y4BahGQaqg9YgTt
B7RyuB8b9lQOuYblhMaQwzvxv57BB7OjkRHCYjlXMP2qN2PA7wU1X6Mq9Jf7Pa8n
aIgMPe/5AmlXSsomvDM1wCze91dnaak66Dw5kkkC1E1FoqMMk+NDDFrTSDuTgSG8
amTMsk13hnoSae07XkkCrSauSJVJQLqmvbVggULst5WQ7Dwy2oZSShS1ZM3X5OP8
Mf4WZ/z3Zob+7KZy2xeUnj3uMse+Om8rCEpWC2Udh/H96BzIQKXrDznpmAer+s8X
/XVphVFRjN0wRgUPH9LeA2wLJfR1qV60Eh1LxKg1J8NMC6DUPlop4riP0qbkTSTp
1EOK1Br0JEkFGw4v3hVXFyGP8xQdzIvTd/qlZxMWInWLbpYmgPbTB+Bn6jRXd/3O
gg5gxNB6tZH6hVcOionYXLoOsyNYaFpB0kewm0jfkpDVb4XMgzWa+f2uOvunVwLV
eyskINPMcEZhFIUcgbqc
=z0Lw
-----END PGP SIGNATURE-----

--6tPipYVl+OcoAvSh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
