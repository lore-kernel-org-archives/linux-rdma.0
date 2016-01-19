From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Remove redundant wc array
Date: Tue, 19 Jan 2016 16:46:33 -0500
Message-ID: <569EAEB9.2050603@redhat.com>
References: <1452597590-17850-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SIMovlx14PuPhpiIX4xvRpERfs8TWqIF5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452597590-17850-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SIMovlx14PuPhpiIX4xvRpERfs8TWqIF5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/12/2016 06:19 AM, Sagi Grimberg wrote:
> No usage after the conversion to the new CQ API.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> This can go as is or be folded to Christoph's srpt patch,
> whatever works best.
>=20
>  drivers/infiniband/ulp/srpt/ib_srpt.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband=
/ulp/srpt/ib_srpt.h
> index ff8b907..247c807 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -254,7 +254,6 @@ enum rdma_ch_state {
>   * @free_list:     Head of list with free send I/O contexts.
>   * @state:         channel state. See also enum rdma_ch_state.
>   * @ioctx_ring:    Send ring.
> - * @wc:            IB work completion array for srpt_process_completio=
n().
>   * @list:          Node for insertion in the srpt_device.rch_list list=
=2E
>   * @cmd_wait_list: List of SCSI commands that arrived before the RTU e=
vent. This
>   *                 list contains struct srpt_ioctx elements and is pro=
tected
> @@ -281,7 +280,6 @@ struct srpt_rdma_ch {
>  	struct list_head	free_list;
>  	enum rdma_ch_state	state;
>  	struct srpt_send_ioctx	**ioctx_ring;
> -	struct ib_wc		wc[16];
>  	struct list_head	list;
>  	struct list_head	cmd_wait_list;
>  	struct se_session	*sess;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SIMovlx14PuPhpiIX4xvRpERfs8TWqIF5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnq65AAoJELgmozMOVy/dEHYQAKG2eFOV0d2J4weOLpYARiUv
PEthzMXjm53swaaQ0egM6VURXxA/i4BcCj7SQQX9WCo1H7DmCyTdYIVJKW5rTEVo
oP5+2BMnULPauKOHsTZlX7pj3FBw5/l/YDrw/o3wySA/5aHK81MmpE/CUatkTHsU
DJtko6CFaX29V0WFyDfYuqbB0tj44IkH1wdJ5DRpKJ8iwf+HPqfOOpddothw+lq+
ZaWLanxxGvZbRgl0AvK49m6sRZhif9LD35ZGEfExm/MOMz+fYO41CnofTVjRwQj1
IFKSyUHSnoOBtRtaHw+XRILXtJekCsrTnL8Zl/GMXFhpnFLxn8qjvvrNiAS2aLZW
s46QDcdFXir+DU611y8uN0PA5yjJsq870gWAx12t5kY+Pfo6r62M6RVJ2So4eLVw
WhvjX/sbB+UIUrVKzZ58ZnbLirnDnmTL7jzg1TNSUPYEwQkZbDypk3V51yTedZ/d
qUWT4wlIW0Me0ULvBm8rgGaRtn1zPI88yibuQ/mQP/rkNWIKqoSvr2uWnwPTf5Pf
iUfjtFpxAwgRDWMoTgF3Tee+ZtUek3BzOdA9DRWxn/fxOUTEojJ9KJLfTEY+/S0Y
oyaqXs0LjaS2e45/Wl7zVCQf8ULevZ5K4I9g7F8ulAiFWik+aTvXfC2naj8IdYK1
vMUDyYvtNdjeRli1GZKX
=6yxc
-----END PGP SIGNATURE-----

--SIMovlx14PuPhpiIX4xvRpERfs8TWqIF5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
