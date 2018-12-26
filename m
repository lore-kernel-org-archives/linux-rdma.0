From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: fix a missing check of nla_put
Date: Wed, 26 Dec 2018 21:50:47 +0200
Message-ID: <20181226195047.GJ10329@mtr-leonro.mtl.com>
References: <20181226020549.71446-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181226020549.71446-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 25, 2018 at 08:05:48PM -0600, Kangjie Lu wrote:
> nla_put() may fail. The fix adds a check for its return value, and
> returns -EMSGSIZE if it fails.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/infiniband/core/addr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

The same comment as on previous patch, lack of netlink cancel.

Thanks

>
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 0dce94e3c495..32d033ebaa5b 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -178,7 +178,8 @@ static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
>  	/* Construct the family header first */
>  	header = skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
>  	header->ifindex = dev_addr->bound_dev_if;
> -	nla_put(skb, attrtype, size, daddr);
> +	if (nla_put(skb, attrtype, size, daddr))
> +		return -EMSGSIZE;
>
>  	/* Repair the nlmsg header length */
>  	nlmsg_end(skb, nlh);
> --
> 2.17.2 (Apple Git-113)
>

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcI9uXAAoJEORje4g2clinvZQQAK2kFeJEmwUqnAYizaDHkfoZ
F1u+4N78dylgtkzdrYS/X+/7XzpxjLAI11VMIVkCDn2PYxqQeZe71PWXsdic17Dz
bbW0E7zAOdhEveuxvLR45Y9q/LTiMX+HbkgozHmsPOjwcs3N4KIJLmMVdxUPpBjz
I8ymm/pMVzuPrwvgfv3WaKrnplpej+DNXj/I2SSsXfKMpyIFXmJXHHxBjCcMd8ER
3ROKt+u9jyRNhPDpTmdQku2xRa3lPuGv+xBPxVw3jX4PFHXWSZYxvXTLImFP4AcY
VPrKLP49MjXzDmG0opQ6hwvxym7DEDJailfzcnUk2q3dh9U6bT14R0/tnHW0GQ4a
S4rsKOEFs3W6kHP9jTwP2g/x7RVS8NLMYxUHzWBh4QKPsVVF2tKn9XnnE652Ub/Y
rU1Or/GmBuO0Y5FuJtEpgvSMIgJnnGTRfUc/wtrDqYYBoaRsYWD0GpnqokMO93+N
RlX01H8Ypg+rpJ2yAFh/wh6hhab34FUnJy6M+XfXdUFLeA4zrolJNiW2xM/N3NCs
olM5ExtFX3ctvSvo13OITAY/v403pC8p1jBOCsZhalSqNOsyxT1QKUZagixt3coa
TEa3Bels3rnsaaVMuEKv+RnBz/UA2vR2dHK/Fhs2tHbxye3faAmTdYnqmrZxrnDE
zL3Xyi6038Xkhk9kLaQt
=wnZW
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
