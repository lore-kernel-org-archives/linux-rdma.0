From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] IB/srp: Print "ib_srp: " prefix once
Date: Wed, 11 May 2016 10:23:42 +0300
Message-ID: <20160511072342.GB25215@leon.nu>
References: <573278D9.4050908@sandisk.com>
 <57327904.1040102@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57327904.1040102-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 05:12:52PM -0700, Bart Van Assche wrote:
> pr_debug() already prints prefix PFX. Avoid that PFX is printed
> twice if the debug statement in srp_add_target() is enabled.
>=20
> Fixes: 34aa654ecb8e ("IB/srp: Avoid that I/O hangs due to a cable pull du=
ring LUN scanning")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.19+

Looks good,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMt3+AAoJEORje4g2clinUjAQAKJG0Qyjt1M6TY70PSUfnxxP
GzI2HJVvrIaTxeGQinC2nj/zbJX2uzPUBfDEAoP3B2y9rIOvSKYDLeWMcP/dpfzZ
ISyF2Zyy+14GfIkiNA46RRdjuUwvvTBa3Z/2rV3vPvjJsuj+mlsCH1Iec1NjmFXI
gIKLDiq7T2hf2OJSmp9GzPBzLt0BYDHL1viuKkYwQjdeL8g3mA28MjuL0MX4hS4A
I5Luz6r8kHaDhj+ZJPKVknDsD4FXpRnrOYtTH+t8qNqrMmnvnJRpFNW0xc9AqrAx
HFeqOB4fNLqxl8HBmFzUvU8/TQ1xIyeCwp4Mj2z6u0HABUXNa3Yx294SwgHirH88
gFX2ikCqgOQA8GiU/baAcrrZRwQb3Iz0xtDN5sSCKCUeJDEClgnmgnGNisBHfFkN
LJMtRBDut3D+103dR4sHsNk+4Tqp5ij9N+AVGmOCH5OEg/8FyCjj5ReH8Ws2BulA
VJRRJV+CblDXGIKw6B/CgUXlCUKad6c45pdg7XrWmoAIh1Uf5M93CYo9bYhG4Orn
8DcmVm8jnUkuRxDPvin0jtl41VoS+GV+68WuqB726lD9bqwzQUWWOI5tb/KC3tNs
F2AP9dGRjchvrj96/fsnhRjoF2YXw0r27VgJ523dsU61JmR1ZcBj4zDnQQv16RhI
YPvLxPEKUe1GBNpBPyuM
=w+Wo
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
