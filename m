From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Fix compilation warnings
Date: Sun, 8 Oct 2017 08:36:41 +0300
Message-ID: <20171008053641.GM25829@mtr-leonro.local>
References: <20171003110529.25635-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bZ2MuwyI/0uB8yuJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003110529.25635-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bZ2MuwyI/0uB8yuJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2017 at 02:05:29PM +0300, Leon Romanovsky wrote:
> Combination of glibc 2.26-4 and gcc 7.2.0-3 produces of following
> warnings at the compilation phase of rdma-core.
>
> [24/189] Building C object librdmacm/CMakeFiles/rspreload.dir/preload.c.o
> ../librdmacm/preload.c:818:9: warning: no previous prototype for =E2=80=
=98readv=E2=80=99 [-Wmissing-prototypes]
>  ssize_t readv(int socket, const struct iovec *iov, int iovcnt)
>          ^~~~~
> ../librdmacm/preload.c:857:9: warning: no previous prototype for =E2=80=
=98writev=E2=80=99 [-Wmissing-prototypes]
>  ssize_t writev(int socket, const struct iovec *iov, int iovcnt)
>
> The simple addition of "sys/uio.h" proposed by Sean Hefty [1] with Jason
> Gunthrope support [2] fixes it.
>
> [1] https://marc.info/?l=3Dlinux-rdma&m=3D150696066510225&w=3D2
> [2] https://marc.info/?l=3Dlinux-rdma&m=3D150696688111945&w=3D2
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  librdmacm/preload.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks, applied.

--bZ2MuwyI/0uB8yuJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnZuWgACgkQ5GN7iDZy
WKcttA/7BqiAzk0U0cJpUwEu0M/VReWgQtHINPye5Ru9OnOVptDA2FYdqkwE5pfw
OMNPfMcCP9bPj4MSdZtAlUKIJ+PczXGESvMdJlB1k8yRZV3d49xUzvaFmjbTHxQS
gbIhQ0sT6SAKGGyVUlRkOMVjGxH7c1P7BhZtARmt/XGUU7+mkQ3GWfA0IovDAww3
ZtpdwyETEFBxYCsKcIKT5psUpfNUqznOS0gGABkzE4LoElbpTc2iYI2jS4/IW+43
CFu+mNRmfOcK2+/w6b1kB/l81K6oQTvk6i+UFb95dm41IXfdAg4UrGlC0IQWvvSi
yXf+d4ATSXwHRw4Cp1imiEU2a2PeKde+0094mL8StgBzkEdIECwglx7clS11thWS
/Ov6LTwEw4zU6DpCMzDG2eHHHS7hEIhTzV2nQq1vP/O3JWWVEcjon8LoVX9qQ8Yn
eHaVFsiYQMJOUI6paDTWdlCl0qKNZVQwVaTjhUHNxPJaAGkIbYkuge48iLnrTOtA
FJn9koj9+8KpwgcJBNRaaeGLNzXsXmDSDuO/HWB2fFv66b3lrp7LiU6h2+HH4Jmv
AS9i9GlsagJkXVzMgYMkxA/xaF6ey9xGRsBEA4+qkAnD+A4JKu3J8NIjEtVsEc5E
Nu6xZxSctiPtgSYY4OUy/at2wVDxdmBhibAPzDkC+4w/4mJSKos=
=VjcE
-----END PGP SIGNATURE-----

--bZ2MuwyI/0uB8yuJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
