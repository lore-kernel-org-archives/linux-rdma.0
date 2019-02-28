From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Thu, 28 Feb 2019 21:56:12 +0200
Message-ID: <20190228195612.GT15253@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <6377a83e-1d96-13b8-95df-09ca40aa00e2@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8CNmCRe8Sh4keFKJ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6377a83e-1d96-13b8-95df-09ca40aa00e2@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--8CNmCRe8Sh4keFKJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 28, 2019 at 01:41:20PM -0600, Steve Wise wrote:
>
> On 2/23/2019 3:26 AM, Leon Romanovsky wrote:
> > On Thu, Feb 21, 2019 at 08:19:03AM -0800, Steve Wise wrote:
> >> This function sends the constructed netlink message and then
> >> receives the response, displaying any error text.
> >>
> >> Change 'rdma dev set' to use it.
> >>
> >> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> >> ---
> >>  rdma/dev.c   |  2 +-
> >>  rdma/rdma.h  |  1 +
> >>  rdma/utils.c | 21 +++++++++++++++++++++
> >>  3 files changed, 23 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/rdma/dev.c b/rdma/dev.c
> >> index 60ff4b31e320..d2949c378f08 100644
> >> --- a/rdma/dev.c
> >> +++ b/rdma/dev.c
> >> @@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
> >>  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
> >>  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
> >>
> >> -	return rd_send_msg(rd);
> >> +	return rd_sendrecv_msg(rd, seq);
> >>  }
> >>
> >>  static int dev_one_set(struct rd *rd)
> >> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >> index 547bb5749a39..20be2f12c4f8 100644
> >> --- a/rdma/rdma.h
> >> +++ b/rdma/rdma.h
> >> @@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const ch=
ar *key);
> >>   */
> >>  int rd_send_msg(struct rd *rd);
> >>  int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_=
t seq);
> >> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
> >>  void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint1=
6_t flags);
> >>  int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
> >>  int rd_attr_cb(const struct nlattr *attr, void *data);
> >> diff --git a/rdma/utils.c b/rdma/utils.c
> >> index 069d44fece10..a6f2826c9605 100644
> >> --- a/rdma/utils.c
> >> +++ b/rdma/utils.c
> >> @@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback,=
 void *data, unsigned int seq)
> >>  	return ret;
> >>  }
> >>
> >> +static int null_cb(const struct nlmsghdr *nlh, void *data)
> >> +{
> >> +	return MNL_CB_OK;
> >> +}
> >> +
> >> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret =3D rd_send_msg(rd);
> >> +	if (ret) {
> >> +		perror(NULL);
> > This is more or less already done in rd_send_msg() and that function
> > prints something in case of execution error. So the missing piece
> > is to update rd_recv_msg(), so all places will "magically" print errors
> > and not only dev_set_name().
>
> Hey Leon,
>
> Displaying errors in rd_recv_msg() as you suggested:
>
> @@ -693,10 +693,28 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback,
> void *data, unsigned int seq)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D mnl_cb_run(buf, ret=
, seq, portid, callback, data);
> =A0=A0=A0=A0=A0=A0=A0 } while (ret > 0);
>
> +=A0=A0=A0=A0=A0=A0 if (ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 perror(NULL);
> +
> =A0=A0=A0=A0=A0=A0=A0 mnl_socket_close(rd->nl);
> =A0=A0=A0=A0=A0=A0=A0 return ret;
> =A0}
>
> Causes problems when doing filtered dumps:
>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp
> link mlx5_0/1 lqpn 1 type GSI state RTS sq-psn 0 comm [ib_core]
> link mlx5_0/1 lqpn 176 type UD state RTS sq-psn 0 comm [ib_core]
> link mlx5_1/1 lqpn 1 type GSI state RTS sq-psn 0 comm [ib_core]
> link mlx5_1/1 lqpn 2224 type UD state RTS sq-psn 0 comm [ib_core]
> link rxe_foo0/1 lqpn 1 type GSI state RTS sq-psn 0 comm [ib_core]
> [root@stevo1 iproute2]# ./rdma/rdma res show qp=A0 lqpn 2224
> Invalid argument
> No such file or directory

Why do we it? We are supposed to check "invalid argument" before sending
message and are not supposed to see perror(). I'm not near code right
now, so most probably wrong in my assumption.

> Invalid argument
> link mlx5_1/1 lqpn 2224 type UD state RTS sq-psn 0 comm [ib_core]
> Invalid argument
> No such file or directory
> [root@stevo1 iproute2]#
>
>
> Steve.
>

--8CNmCRe8Sh4keFKJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJceDzcAAoJEORje4g2clinX34QALhyEzCc1LzPvVHGUiNw1KfX
tw/My0oubLqC1yvBUjrFRUHr2mZc7wJcDFnQHxWdvi5Gn+UzKO6MVLd6VecPcI73
8JAXEp8f0nX0lJsufYMik42eD7zzqntBbG5ZlfibwCvJZ65PzB8B09SXi6DZ74fb
R8CZM9mqAbk7nwb/I/vxztHf5dFaHxrrOKRN3FQhgFXwrY6eNxuQSc2Pi2hmZ4GI
NMkm76iDqJ9GpnnJMCTPY9HzdBKxJxZ6Wac2nNl3Zhq15iTusYgHchb+tiVOsCl4
p8KZCsq+023LOTJeBkTgHHXAYvkhHmyFD3v1Fr70AQBl8kz1xcFDLoWsDME9jAqp
GtDqkog9DcoonRdasOepBKlwLQciG8NyE+8ii/oH1FNg8BuaohRG3YUW52yIXyfh
xT35oqmwkNXUZ/K5q6I1nxy4z1u/fkqi/AKaUbutzdCLdk0Iioy8X5XYEsLbhwSK
WUdTn6teJclKEcXaY2CwqegtI8Bos9oRQyGrw6CsFp4zQ/ILCYa0QCw1zciYlV3E
2lO+ludYdokumXen82urd5o5brXhNABv2MkQRJ5TedJAjlJkA9MAC6FKwjYSe7F0
/+lAMGyckKAE1AmZf8GP9ZS92su3LAf+LuC6RNd1+MN0IbcmJLE/UYaSb8idtj/D
gcYa9B52F7SkEp0VWj/C
=mOjr
-----END PGP SIGNATURE-----

--8CNmCRe8Sh4keFKJ--
