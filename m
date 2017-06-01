From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Thu, 1 Jun 2017 07:30:13 +0300
Message-ID: <20170601043013.GN5406@mtr-leonro.local>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
 <20170531161819.GK5406@mtr-leonro.local>
 <20170531194426.GA23120@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aIbcA3MSwnGacr4f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531194426.GA23120-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--aIbcA3MSwnGacr4f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 12:44:26PM -0700, Christoph Hellwig wrote:
> On Wed, May 31, 2017 at 07:18:19PM +0300, Leon Romanovsky wrote:
> > I think that you are hitting the side effect of these commits
> > 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions") and
> > 81713d3788d2 ("IB/mlx5: Add implicit MR support")
> >
> > Do you have CONFIG_INFINIBAND_ON_DEMAND_PAGING on? Can you disable it
> > for the test?
>
> Eww.  Please make sure mlx5 gracefully handles cases where it can't use
> crazy amount of memory, including disabling features like the above
> at runtime when the required resources aren't available.

Right, the real consumer of memory in mlx5_ib is mr_cache, so the
question is how can we check in advance if we have enough memory
without calling allocations with GFP_NOWARN flag.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aIbcA3MSwnGacr4f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkvmFQACgkQ5GN7iDZy
WKebSA/8CrPpHacSYEwtvpsWk4gH/bOB82IyBGEexBtna0wXX6evS4KdzUiSBZmX
i8fBbSVpj9P1gEEWMMY8zOQ25nqcvNZu91D3mJDobUU4kR/0/73FfgWJejboKhov
3sOLoWYCZRmP4rIl36IKX+/gfCJRckOT6QTID7Q0ktQmupFE9GB6ezT+Jt1QbY6/
IzmjqXV9iuufyc1cNuPJqW8nGo17A6cb+004ix0Ei6+lLrXEHH8zqJ9YWBNet3l7
HmWwF5xrQ1Bu4mrvNg2CFIadYL/URylAGQqxlcPvc/nlDTa0MbS9uwK6gQi74HQr
aN4JBkA5byfrM2fO06p9vTDN6GPLXIlDcQ81LG8iD/dEwWh4t39EFj6u3lvpgrX/
JfgMYn2E+RYy1XSWY+nmkVeFhaLM/EAOm4MTNsrdim6iCw9IVVCg4MvFsQ7I7MMc
mUoE5/maMxQFMnzLBUvXoD0pZkwTDFBCVR9CSNMpfrFyoLn+E28CUFGgUo/GCEQp
r3vfWWKpB/lzrOALq5rBcFdQusHQPicZpFku/matqq0gVFFLlN3D4ujtmqMyb1Lt
+te6MnPS1+VXU9ZnR31ocxSuMYe5RzhdZSxtlxQVYdw0nO0S213YerUQVp15Krru
rT8bpnvpLTxMR6dntLCsgV9tGMeD/Xs7NviUclNmjpSySUREUA4=
=rp1G
-----END PGP SIGNATURE-----

--aIbcA3MSwnGacr4f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
