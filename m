From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] RDMA/bnxt_re: Implement the
 alloc/get_hw_stats callback
Date: Tue, 1 Aug 2017 21:26:35 +0300
Message-ID: <20170801182635.GP13672@mtr-leonro.local>
References: <1501603579-13844-1-git-send-email-selvin.xavier@broadcom.com>
 <1501603579-13844-3-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AO7xfgsPaN7qs9GL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501603579-13844-3-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AO7xfgsPaN7qs9GL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 09:06:19AM -0700, Selvin Xavier wrote:
> From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> Expose HW counters using the get_hw_stats callback
>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/Makefile      |   2 +-
>  drivers/infiniband/hw/bnxt_re/hw_counters.c | 105 ++++++++++++++++++++++++++++
>  drivers/infiniband/hw/bnxt_re/hw_counters.h |  62 ++++++++++++++++
>  drivers/infiniband/hw/bnxt_re/main.c        |   4 ++
>  4 files changed, 172 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.c
>  create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.h
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--AO7xfgsPaN7qs9GL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAx9oACgkQ5GN7iDZy
WKf3KxAAgRWHUWR5sLMLnCIuqJTI/ppNNzerdwQRtfyioL12EDK6NB2EElEWWZyd
VfidFojzAFknxQ7y2qZTam3u7zIP4o1YUAzPU11Kq50oZwuKjHEEdGk9SnITFkU/
khn1HXQa5vV/xjzRMhZiPUsYLn8GAklMC+PIrdpC+l7FWCjSNhS7sI4dTFwEla5I
xRevJqJ8VLQWczOBrlBeUupo3tZf8ludt41K8T99L8xzixoOcCrnBOGTRi3jJaDp
kEZDOBdN8rLEiJppW4uiJz7AI9zVCYG4tKawonDQdf+Fxa5pJt0K7cFt+jyNY7Y/
eaLXmyK9tJLia26MdPhOrNEsYRpe/ghMCREGFju58PxI4nXqX3n2nSWt2gt74OSq
iTILcPLkR/pktkHRxarpm8jKYyuz0tLgfqkSUM9+j4fmmuib7SKRw2+cwi+bCsd2
Q4GTmGO3EIA5knTFcDrKF6+1NhxMVkz4gZp4FhfnWJVliOdD1+RZ1Z48yYkrmuWO
c3H7jeoM7jZkkDPhIDLMZEZ78NSUeyGwxJwUJg5jVLVvIqWs4XiOGB0OEuU+eBiu
uwr2K0ajHfPWsBYBYw/AVfyQBYmqFPfvkcNFiSqfDLFRkl74bU5Ji0TpX5mEtjCs
tEZbuUj7SBJ2Fcz1oMP5IjByZ1SzJsrbdCK7b80TQSGttebW8Uo=
=ufUB
-----END PGP SIGNATURE-----

--AO7xfgsPaN7qs9GL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
