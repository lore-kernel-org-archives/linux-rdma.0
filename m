From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] iw_cxgb4: check return value of alloc_skb
Date: Sun, 23 Apr 2017 19:51:41 +0300
Message-ID: <20170423165141.GG14088@mtr-leonro.local>
References: <1492938551-17824-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GD+uNaHYxbVPHaQt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492938551-17824-1-git-send-email-bianpan2016-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GD+uNaHYxbVPHaQt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 23, 2017 at 05:09:11PM +0800, Pan Bian wrote:
> Function alloc_skb() will return a NULL pointer when there is no enough
> memory. However, the return value of alloc_skb() is directly used
> without validation in function send_fw_pass_open_req(). This patches
> checks the return value of alloc_skb() against NULL.
>
> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 03a1b0e..196969c 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -3800,6 +3800,8 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
>  	int ret;
>
>  	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
> +	if (!req_skb)
> +		return;

The check is right, but the outcome is unpredictable. The function
send_fw_pass_open_req() doesn't return any error and caller doesn't check
it.

>  	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
>  	memset(req, 0, sizeof(*req));
>  	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL_F);
> --
> 1.9.1
>
>

--GD+uNaHYxbVPHaQt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj8250ACgkQ5GN7iDZy
WKdXyBAAgKInHgfqJo9VgRpjqxnX7ETAVw1IsCCFDEkrZpR20xAAMdYC3Tm60T8H
FL4Jemfgy3Z9r483Ugzhn9BJ4jdutuybHSHQSGNuyY4n4b5tyRa89dbBun13QWdL
GYXu08X1c/9ayMvZ5pLCQRDE84G4f1Ga6CWEYmQ6uQf15xVRaJ9ihiKixLxtcOTS
NTcC9jDzw68uQ92Py1pFTdptner7X8H29lo2hm+FiqsaGxIO5QQvQPHpFwqwrjX5
zc3ezih/ntRlgoWGh8vB2OdYpazZf56fMoQ2WQqNKipr543d7VgWhgO1Aa+GdO7f
VF8Y9q9NEEzU3Dg4qvFKrsElKL5HDCgT10OGmBzbj6gEG66vOnXbuRaNlnAzvNv2
FkbtcjSbf7bM1GWGcO9p7ab7SuZpKvZfnp9cSFUMQTmEO7gPo1eJZzBjF3vyrKfg
WRBlBi+YLDt4TdEIT6hUI5JIO7Mx/lMwU5H/oBVE0zYZ+UpS1o885MS5WX2BOAfM
oXJ+XF3GYPSyu90KDx/piBAmKB9xmL0UF7tMeH5xWztcvG970HkmbxL2XdwTA5Uj
RcmPW1hv8vaclgczzHnXaudEG484axXvG8eb91SZgCMNNnCeGv2rHv1ajkKZ3jO5
0WALb5M7Es7b4AK12a9O/6Ut9bbgWED4ElyzTVrIK+GMKCL8XeA=
=vWGU
-----END PGP SIGNATURE-----

--GD+uNaHYxbVPHaQt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
