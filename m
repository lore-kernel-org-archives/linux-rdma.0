From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] debian: Do not require valgrind on ia64
Date: Fri, 19 Jan 2018 14:11:17 +0200
Message-ID: <20180119121117.GD1393@mtr-leonro.local>
References: <20180119114523.4864-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180119114523.4864-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 19, 2018 at 12:45:23PM +0100, Benjamin Drung wrote:
> valgrind was not ported to ia64, and thus rdma-core shouldn't
> build-depend on it.
>
> Closes: #887511
> Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks, applied.

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlph4GUACgkQ5GN7iDZy
WKexDQ//eD9Evc7qvjrAhPIhyPHP1l3/osqRs+xQgLPIpOO7gMFAcMD9kuW2K4dK
rtMfx4dIXkcyZQbmZun1umX57GctZtW/YODo0bQyvw76mYFiDy4R1eemEVDx6yQy
wgY9LW+PUBBX2mQCq7NXXxBVOr9OMSZBStjAwzJ3TMe4psSYAn/GCAXK6VexO7J+
VzxH6qwHYKoKRzBkYyBRQPi7HfjYU0WE5XxqI6CT7uZH1G1Wk44Qthiu60suEOBH
dtwmfz8XSUYvZlMGjC+HO/pAUgvQ8DB2PyrhuIaVcUx+40POLvHnfCs3wwUAEiW7
Ou8jVTnc0uSfh1GaxbXk0qgcRte+iSWRyfEB0DFuCE6xjByqfBTZrvReKSEqco+p
EZ8PYVowQSkpHId8D++iaSv4K1xNPWL3GngEhF++wZ4DMbx/QyMwsni++1+vTVir
LG685dPge2x7RYL8zeMAXYR2iH76NKMrIAMqgUYUXAG89VusXnfYjp2A5F3Bqg73
4rE0XhDDdvGjAO0qBddIUkwP3rSavUQKhKclbmZEpOQINqL5LWyd6Dn0mrZo/6RQ
j5tjUXL81e2HYwmtvh1byjtjRXAjAL7AV91nN/YIppTcfZ95oaosbGZ1QCrqW9+Y
+RsjZnKAixYhEDCMSmEgpZyhbluVigKD/ZlLcoIwELdYbKx5B9g=
=1CA2
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
