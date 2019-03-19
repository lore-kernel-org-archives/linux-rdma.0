From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] net: mlx5: Add a missing check on idr_find
Date: Tue, 19 Mar 2019 16:35:07 +0200
Message-ID: <20190319143507.GO4823@mtr-leonro.mtl.com>
References: <20190318221924.7034-1-pakki001@umn.edu>
 <e48d6cc9-9bb2-47fc-ec04-eceecbe6d91e@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e48d6cc9-9bb2-47fc-ec04-eceecbe6d91e@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boris Pismenny <borisp@mellanox.com>
Cc: Aditya Pakki <pakki001@umn.edu>, "kjlu@umn.edu" <kjlu@umn.edu>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 19, 2019 at 01:41:49PM +0000, Boris Pismenny wrote:
>
>
> On 3/19/2019 12:18 AM, Aditya Pakki wrote:
> > idr_find() can return a NULL value to 'flow' which is used without a check.
> > The patch adds a check to avoid potential NULL pointer dereference.
>
> Did you encounter this in practice?
> This flow you are suggesting shouldn't be possible, because the handle
> is always there until the socket is destroyed in sk_destruct.
>
> But, I wouldn't mind some defensive coding here.
> Maybe also a WARN_ONCE :)
>
> Could you also release buf in case of an error returned from
> mlx5_fpga_sbu_conn_sendmsg below?
> Otherwise, I could submit a patch for this.

Boris,

Can you please invest ten seconds to read previous emails prior to answering?
https://lkml.org/lkml/2019/3/19/36

Thanks

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJckP4bAAoJEORje4g2clin8lIP/367xE+vAKvgzuFbzOAJYH25
I2VHgXebnt9n6dJ3VzJAmQSPTj0YlMKw7SGofXPfTybNv9G55bo1H8DsyBvpsyf3
xBRy3G55CA+na1Qwc8CUtX3VPmNnn+Wn8330UOjv6uuRm0qF0DaxwmXqoCwR43DN
+2JXg9Vi8wqfUbu++WD8xSpVYnzgmAlS8R1UbQNIuy4FZWGRKWOOhh4PKwkmw8NQ
69BCU6xjLROz5KcPLo14oH3a/M5l7WiwYBIcl42a7jguOnc5AlVAZ9wekm7yLymP
Vcg2UyF4STMnCkBVGi7J1wwculitBGo/d4LLQScmGDFA0JBh4SVvQb7SIMJMe9W/
bY18njmMtSmEYRmqRZYykkUGCGmoSY8hfpHT9STm3e0vVCsGjyBX4O7B61sg4lgo
Y+niypJRR9jSolYDmlBxVqvV0J2DcuX4Pn8qorg4Q/3ftiDGSzzAoNsc1icU6YSA
twd4FhT1jnS3L9r2bE0UJhxFCnkqxYjAfZa3DH6s57F7J7Zp4DVAvLhoSvAVeoFe
ft8kkUDwXWKJCjVT4jng82KlgX4tpehA/ucwCEeo+1vo1cVCTQ4yEXhSxATIIgZ1
nuhWVbk8w8gxD6aHckYBlXsgMkq8VlCKVSeHqgFGrZIKOADpLFFR6S3FsPv3J0c3
gQ7ghJR9KJP5brC+Of6P
=EJK0
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
