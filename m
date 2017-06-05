From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/bnxt_re: Check return value from get_link_ksettings
Date: Mon, 5 Jun 2017 15:52:27 +0300
Message-ID: <20170605125227.GM6868@mtr-leonro.local>
References: <20170605091429.16232-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9a9Vq1BJdYBEXpLG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605091429.16232-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9a9Vq1BJdYBEXpLG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 12:14:29PM +0300, Yuval Shaia wrote:
> The function get_link_ksettings might return bad status indicating a
> failure to retrieve interface atttibutes.
> Check return value to cover this case.
>
> While there, change the zero-initialization to "compiler-helper" instead
> of an expensive call to memcpy.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index 7ba9e69..10c7189 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -183,17 +183,19 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
>
>  static void __to_ib_speed_width(struct net_device *netdev, u8 *speed, u8 *width)
>  {
> -	struct ethtool_link_ksettings lksettings;
> -	u32 espeed;
> +	u32 espeed = SPEED_UNKNOWN;
>
>  	if (netdev->ethtool_ops && netdev->ethtool_ops->get_link_ksettings) {
> -		memset(&lksettings, 0, sizeof(lksettings));
> +		struct ethtool_link_ksettings lksettings = {0};
> +		int rc;
> +
>  		rtnl_lock();
> -		netdev->ethtool_ops->get_link_ksettings(netdev, &lksettings);
> +		rc = netdev->ethtool_ops->get_link_ksettings(netdev,
> +							     &lksettings);
>  		rtnl_unlock();
> -		espeed = lksettings.base.speed;
> -	} else {
> -		espeed = SPEED_UNKNOWN;
> +
> +		if (!rc)

Are you sure that it is "if (!rc)" and not "if (rc)"?
in commit message you wrote that "The function get_link_ksettings might
return bad status indicating".

Thanks


> +			espeed = lksettings.base.speed;
>  	}
>  	switch (espeed) {
>  	case SPEED_1000:
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9a9Vq1BJdYBEXpLG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1VAsACgkQ5GN7iDZy
WKdyjBAAmVojWPv6o1dYhgBCxkw2Kmd7OPmCaRRMpeiiGQGcab6gzicILQmzVioC
Kg+0tsbt5oo8LuJGnXgkO9AtHCeQ8NkrWj9yGHoFYTaXvECSUren5f8OOKvauWzk
MLp/QEeSrhYYM95rfWLLE/BjGSQIYsDzwnuuPpDPpRDoPH6lG8BKC3k0ElSFTV3z
g0d9TGZO9NwyXJoaZQxoniFDroNo8MaSSS6Gwy5lTjE687GhQs6U6Ps9plSprm2B
bP6cjgYFVr+9+fvIRE1jZrYfy17lWGJ7T0TAq8GUo6Qf0v9XRC4cz0gNvTGFry5F
z7MYu6YfwfuIO1Lwt9PJSbkErJxDdu9NUUJVEKO8Q9c6+6xWwPUQL1cxZ/X/TVei
b24/7zINpwLNSfg8OJnxGb+j4BoiXIJkJq3tkBDmBjot94BZTGrVmAow/uyk9cIq
djCJmW8au7v2sj6HUNLtsTQSIyMkxqWtHUkydoEHkPc2WHMRuURW569E9i+eFEFP
wRL/oaSI4bggU9hYniJdAKsrxIOlDOmx+13IqD0ZpJDH4II8oLkpI5g4zF8aRy8u
kZxq7XYc+xFpuLQtorC5XQfOSbOL69DlCwK/iWQcFfXGehEPouQuTZ3+CkGEXsxy
jHcNAjDcuygFAiXdjW7W4gJH1gYMyNAxNvQnENllEmci80eDyqI=
=EIuI
-----END PGP SIGNATURE-----

--9a9Vq1BJdYBEXpLG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
