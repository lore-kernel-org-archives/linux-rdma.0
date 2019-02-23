From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Sat, 23 Feb 2019 11:26:15 +0200
Message-ID: <20190223092615.GM23561@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="g3RkK9jYN81zD2N+"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--g3RkK9jYN81zD2N+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 08:19:03AM -0800, Steve Wise wrote:
> This function sends the constructed netlink message and then
> receives the response, displaying any error text.
>
> Change 'rdma dev set' to use it.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/dev.c   |  2 +-
>  rdma/rdma.h  |  1 +
>  rdma/utils.c | 21 +++++++++++++++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/rdma/dev.c b/rdma/dev.c
> index 60ff4b31e320..d2949c378f08 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
>  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
>  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
>
> -	return rd_send_msg(rd);
> +	return rd_sendrecv_msg(rd, seq);
>  }
>
>  static int dev_one_set(struct rd *rd)
> diff --git a/rdma/rdma.h b/rdma/rdma.h
> index 547bb5749a39..20be2f12c4f8 100644
> --- a/rdma/rdma.h
> +++ b/rdma/rdma.h
> @@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const char *key);
>   */
>  int rd_send_msg(struct rd *rd);
>  int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t seq);
> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
>  void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
>  int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
>  int rd_attr_cb(const struct nlattr *attr, void *data);
> diff --git a/rdma/utils.c b/rdma/utils.c
> index 069d44fece10..a6f2826c9605 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, unsigned int seq)
>  	return ret;
>  }
>
> +static int null_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	return MNL_CB_OK;
> +}
> +
> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
> +{
> +	int ret;
> +
> +	ret = rd_send_msg(rd);
> +	if (ret) {
> +		perror(NULL);

This is more or less already done in rd_send_msg() and that function
prints something in case of execution error. So the missing piece
is to update rd_recv_msg(), so all places will "magically" print errors
and not only dev_set_name().

> +		goto out;
> +	}
> +	ret = rd_recv_msg(rd, null_cb, rd, seq);
> +	if (ret)
> +		perror(NULL);
> +out:
> +	return ret;
> +}
> +
>  static struct dev_map *_dev_map_lookup(struct rd *rd, const char *dev_name)
>  {
>  	struct dev_map *dev_map;
> --
> 1.8.3.1
>

--g3RkK9jYN81zD2N+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccRG3AAoJEORje4g2clin57wQAJSxiIAhKz+WLV+VTnX2YfEM
fKTaGtb2dPN+91M8bV6g4x3FOCYNUTNETSz2dQaU4oK6NsTxeO3LnNft7J0lFWvL
VHW+rpp//z9y2gINf9RNokA68vXOUAP0VUomHZ95/IYeeukm5Qf7HNGFt6aZx6wG
t/J/ZucbT6bF4o6GfAdVgeGX7vS6OadHbChYXDO0WmSj6c90STIdjQXKWnhiq0e7
rZ8stPYz7HOqXmiTQZuyR/C8Vj+BtHmzZk9VGOU4lBYC461GQr0+efPexZnD/6CC
R3P6NTFdqTetcWJFfP2nWcbmnQobPktuODa2/wfm//91ysyU2l2lPH28hnI8N+/P
wY5OJ3wQMs/wMEpgBdP5Z4n0OvSzU3cfVt+1CcQRjmoo1sQD6wbKYbFe/fL6fGGI
s0Jmk0SCTuLrJRUik+R02kNx3OPJIB8QYnXylvQOM2FIorXVsmkgueZ70q6AUEW+
oQCKEkIosifZUEDCKRJAEBFNYNqYKUmLHRWepB8IDVWhMVpW4rDtiJqd+Xy72T4F
AH7oCSUwbYEEjLlHfCrVTMZmJJNo8YBOIc3w63x6zs68w5QPrIQcA1+cwmJoNBRO
T3EDMQs1yQCrSbeMd/XGRbqSm28udjwOd/Oe7qwC9dn8DWSm9BjVKDjOOM8G2F0S
nY5lKwXyLoqTeq76A7Z8
=MmzG
-----END PGP SIGNATURE-----

--g3RkK9jYN81zD2N+--
