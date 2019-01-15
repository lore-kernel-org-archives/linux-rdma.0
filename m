From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] [V2] infiniband: fix a missing check of nla_put
Date: Tue, 15 Jan 2019 20:14:29 +0200
Message-ID: <20190115181429.GP15600@mtr-leonro.mtl.com>
References: <20190105161808.3496-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="poJSiGMzRSvrLGLs"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190105161808.3496-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--poJSiGMzRSvrLGLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 05, 2019 at 10:18:07AM -0600, Aditya Pakki wrote:
> nla_put() may fail. The fix adds a check for its return value, and
> returns -EMSGSIZE if it fails, post canceling netlink msg.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/infiniband/core/addr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 0dce94e3c495..e847b34bacd1 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -178,7 +178,10 @@ static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
>  	/* Construct the family header first */
>  	header = skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
>  	header->ifindex = dev_addr->bound_dev_if;
> -	nla_put(skb, attrtype, size, daddr);
> +	if (nla_put(skb, attrtype, size, daddr)) {
> +		nlmsg_cancel(skb, nlh);

It should be nlmsg_free() and not nlmsg_cancel()

> +		return -EMSGSIZE;
> +	}
>
>  	/* Repair the nlmsg header length */
>  	nlmsg_end(skb, nlh);
> --
> 2.17.1
>

--poJSiGMzRSvrLGLs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcPiMFAAoJEORje4g2clinqWYP/Ra8NEt0GVIJEra8OE+ynSCx
P2fXTH947KwgDcFbc+eu2aEiLm3v3yFjWjkE5Ut1uBqaeqiUCphSRVdpQ1OPQWC3
cUdqOB21Qr77T47bgoRDvgZGz/+ch5z4nWMQ1I+yZwLj4wmSLP63ZvNaSD2STFxE
SONQ/5N9Dr4sJo7+9WS4SJlud9cgE17ovEfTfeniYUbwDWrkgNnNjXvqtv4a+5Nl
WSrJkxbJxwPQBw8E+Y1oOcWxw42EaSSGVm9DNqcSp60X/gOvuedPx4WvIVp+u8yY
jHbQNUsa6sK8vnmhNW4N0KCO5ROQsXBEvpGtUX9xATyONi8c887xbKYNE+Bm3D6v
jlcaa3XIgDB2l8EEqnaYb+35TEU66YjfUthYR93PQDK+F+T/qfIbQ4+sAHWbdIy3
GUuh7dEGsVJPkqazVcVWF+zZks3P8lhKOa/SUdDPqzLKFpiysutNB/foAyoFTt9/
PBNGgyNnWRah52EjLMRSGoYujs2xoJvaRF9BC1rPlmqL+dP9mhKbavRsyBim9d2h
3AU8DI6ZHRiw4ozm3ykXBPCvkmEvwo9kntuMdcm+jtrdncQsgplZ8b78GSG69/WD
n980swMGW9BpT5pUSy7nU9VfFNU+1jGRdiyQe5kcaUy08A7KpBUpIkzOISNr6nnM
ArXmvtveScB5pHR8/H/w
=L/zf
-----END PGP SIGNATURE-----

--poJSiGMzRSvrLGLs--
