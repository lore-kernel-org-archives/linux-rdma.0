From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] iser-target: Fix error return code in
 isert_alloc_login_buf()
Date: Fri, 5 Aug 2016 17:36:09 +0300
Message-ID: <20160805143609.GM27667@leon.nu>
References: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rZHzn+A9B7nBTGyj"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--rZHzn+A9B7nBTGyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2016 at 01:49:28PM +0000, Wei Yongjun wrote:
> Fix to return error code -ENOMEM from the alloc error handling
> case instead of 0, as done elsewhere in this function.
>=20
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index ba6be06..65af523 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -449,6 +449,7 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
>  	isert_conn->login_rsp_buf =3D kzalloc(ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
>  	if (!isert_conn->login_rsp_buf) {
>  		isert_err("Unable to allocate isert_conn->login_rspbuf\n");

Please remove the line above too.
There is no chance to miss kzalloc allocation failure.

> +		ret =3D -ENOMEM;
>  		goto out_unmap_login_req_buf;
>  	}

Thanks.

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rZHzn+A9B7nBTGyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXpKRZAAoJEORje4g2clinfwsQAIh0ZFn+o1jyb1Sznn+hD19i
caVD0Y7XzMJbeq7J3iZfRoU2AwHnE0phF79FPXsHH4fO7FCQFASWHmx0Sfm49TUI
wZL6DO25H6C4404GdO/u8ZRNyLTm8N11aazUpr/+KgTyUYXnKgBwSkmzS64bqZXm
Jw6U5abo+Rv34k3s80tAorACj4Xikv7p9wQLzA/3/5zx6dY2ARaV4Y9wdt/BDnAJ
x/EsiqZtpHXF9P8SO1XEhz4tvmvlwoyo/vpseP/PjM8DgFCq9uOHU5lTp/fMp5A7
kowZFAvcPYaHA5RXPXzHPoNqKVdGt5GC33ueYxzowNcaQR2uvrQA77GTqq1bINQn
ome2ETfNBkM9MUPuqijJZTXeMUxt+oyE4ycd7uovNvTY29TSfaLTmtdRpRfZihem
Ncg++clXIKyBBl4ioXHb8/RLClvRtAyV8yOYEz2NcmEiKPZpStk1mLOFbNX+C/Uz
3KxK5A0kZiA9hlSCkAwZjlqeqTEwj2usTdJ3OYB4hLxlxXunacLA69o4oIy2rXI+
niVU45G+hVJY0QiYENjCdO8MXzkQHI1znRjVk0FG48NfjzB7pHJI9ag1FK68BTJ2
mTXo3Ppp8vOj7vB1XIaoBtkIUy7fWOcV/u6sliCIuAZzzfI6x9YnS/9p4RfOvK3F
qhWkMYfkaWkBxK3sbR2x
=tzSI
-----END PGP SIGNATURE-----

--rZHzn+A9B7nBTGyj--
