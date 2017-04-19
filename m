From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 11/18] IB/mlx4: Rename to_ib_ah_attr to
 to_rdma_ah_attr
Date: Wed, 19 Apr 2017 19:42:31 +0300
Message-ID: <20170419164231.GM14088@mtr-leonro.local>
References: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492212538-32459-12-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UK1lfQXsnwKrySH9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492212538-32459-12-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UK1lfQXsnwKrySH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2017 at 07:28:51PM -0400, Dasaratharaman Chandramouli wrote:
> local function  to_ib_ah_attr is renamed so it in
> sync with the rename of the ib_ah_attr structure
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/qp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--UK1lfQXsnwKrySH9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj3k3cACgkQ5GN7iDZy
WKe7fA//f0T5g8RRcaYyU4FJtHnb8KwRePyXGkPDpx3RoNqBxnbK51+8MXEf5Spb
cCV5Ai8iIoDvQqGHKlfthcVTB1N9/AiUmErFZyY0eIaOp3RnR8BGpBwy3uHknmqo
keinNZwVDtZ4jBBCmAUWtyVx43ifla0nwHtrGe3mYJyR8i2VuK4peYs0ZmTR9OOj
BzZwDE+vhJ6Zx3ATs6ljMYr+ikH9v1F5PVoAUfRiEW/lLcfBwE2kWkgzVNTUE1kD
63I489oSS66/bjPDx8DvIWOoB69aveC9da+fugZJX6hPfrRBjAtGEJSauSCcaSfT
wJnnDzC/MIILfS8IMG9kFqX9uVXOXtM52WappbODJ/sAKo/h3rMxhJnn05u5nN9u
9sOmM8fdwRLuuNarCyMaVCGrnRNItIfAt9YyEYm/+WFrwEvPaFaqwRqg1RSpufKP
Me2FX8AyrQ+WAIlEP8ZD1/x38x5KgFpQcACmi4vTHVSmYVcssKFdAGLFZrAIt8CS
wdFrztctlEbMkCasfINusiE8dxx2jfbFvTE1FmEIb8/CV7vVbQwmbdNJCUDtJS6d
/2o+Zlo8vWyWLmMd9W1ibyhJ4m7tz37eKk7jqL3p6jR17vNOzGeiT0IUpGAA7APs
MzmarGWWZEv5kmpUgBdlJYXBR29W38TmxcrwFlp/zKORVsNYyGg=
=p/n2
-----END PGP SIGNATURE-----

--UK1lfQXsnwKrySH9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
