From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
 from netdev
Date: Tue, 13 Jun 2017 13:37:41 +0300
Message-ID: <20170613103741.GP2576@mtr-leonro.local>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-3-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sy9WyBOsCRoUO165"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170611054450.7221-3-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sy9WyBOsCRoUO165
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 11, 2017 at 08:44:50AM +0300, Yuval Shaia wrote:
> Logic of retrieving netdev speed from net_device and translating it to
> IB speed is implemented in rxe, in usnic and in bnxt drivers.
>
> Define new function which merges all.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Invite usnic to the party.
> v1 -> v2:
> 	* Utilize __ethtool_get_link_ksettings
> 	* Rename to ib_get_eth_speed
> 	* Add some validation checks
> 	* Implement get_netdev in usnic
> v2 -> v3:
> 	* Split to two separate patches
> ---
>  drivers/infiniband/core/verbs.c              | 55 ++++++++++++++++++++++++++++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c     | 49 ++-----------------------
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 31 +++-------------
>  drivers/infiniband/sw/rxe/rxe_verbs.c        | 53 +++------------------------
>  include/rdma/ib_verbs.h                      |  1 +
>  5 files changed, 71 insertions(+), 118 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--sy9WyBOsCRoUO165
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/wHUACgkQ5GN7iDZy
WKc3PA//RmJN6PKWjNRWUqjoBA+DSG1dXE4bFAXsKVLBfJF6upoyv0O8w2q8zm/l
SsfxyWgReLdeXQCDWR/cMQkas1VDRt57kPR69Vct+TXCM/UeW2oNSY8N4WluCEQz
RAhPE17/jwfSbpaDsjIb8P4Ixw1Kt2OlBLWekRi7+PKb1R1AwTkCUxFcIjkTeTGr
oLidRnww0ASfEEohgNXhbrXCzsadb3seyrUMadArEZNpkBV7uiixWl8bs26+DPfr
x+k+H+b5yxKB+ECKNlhjhf2/dX35N0y3HJQC/ZYOhYWcB8J8fmYlUdQ1/e5J3VMT
QGQoJyQxykWCngQ0SFgxhXRDnLofiyk6mhAMFEwlwe2MMF8+DSN1iZeocOGmbbO6
1Q06aRJ0uIILlMRUp6CcGSs1X3njCQh47czzicGrVhA/pStDav2o0/YPyPH4/9/w
x7cuI4/YcB8Z20cB07yzmQ3KwnfGTEcqDwBcCQLm/P3TBCDn8Tc0eEnKrqTImhd8
nJi64D/trC+oBOOza4RupXEuMWZU5zJ7O+6HqceR48rdUm/r50BSNlNw7DVgZg7g
lfIhnVJ3+0mXn/R4Pbsp2FETNlbNhhxpeotLSOHuQ3Z23xnTHZ9MpAH4MKAPiY31
Au469umnPg18AI57fnOCKJOmmn6JkDVf/5PuZVlU3yixONH8vHI=
=md30
-----END PGP SIGNATURE-----

--sy9WyBOsCRoUO165--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
