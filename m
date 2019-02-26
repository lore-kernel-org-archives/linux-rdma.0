From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Tue, 26 Feb 2019 21:16:37 +0200
Message-ID: <20190226191637.GW11231@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <20190223093122.GO23561@mtr-leonro.mtl.com>
 <7f48fc85-45ab-fe7d-9614-4c5eb50f8401@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7f48fc85-45ab-fe7d-9614-4c5eb50f8401@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 26, 2019 at 11:19:12AM -0600, Steve Wise wrote:
>
> On 2/23/2019 3:31 AM, Leon Romanovsky wrote:
> > On Sat, Feb 23, 2019 at 11:26:15AM +0200, Leon Romanovsky wrote:
> >> On Thu, Feb 21, 2019 at 08:19:03AM -0800, Steve Wise wrote:
> >>> This function sends the constructed netlink message and then
> >>> receives the response, displaying any error text.
> >>>
> >>> Change 'rdma dev set' to use it.
> >>>
> >>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> >>> ---
> >>>  rdma/dev.c   |  2 +-
> >>>  rdma/rdma.h  |  1 +
> >>>  rdma/utils.c | 21 +++++++++++++++++++++
> >>>  3 files changed, 23 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/rdma/dev.c b/rdma/dev.c
> >>> index 60ff4b31e320..d2949c378f08 100644
> >>> --- a/rdma/dev.c
> >>> +++ b/rdma/dev.c
> >>> @@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
> >>>  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
> >>>  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
> >>>
> >>> -	return rd_send_msg(rd);
> >>> +	return rd_sendrecv_msg(rd, seq);
> >>>  }
> >>>
> >>>  static int dev_one_set(struct rd *rd)
> >>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >>> index 547bb5749a39..20be2f12c4f8 100644
> >>> --- a/rdma/rdma.h
> >>> +++ b/rdma/rdma.h
> >>> @@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const c=
har *key);
> >>>   */
> >>>  int rd_send_msg(struct rd *rd);
> >>>  int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32=
_t seq);
> >>> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
> >>>  void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint=
16_t flags);
> >>>  int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
> >>>  int rd_attr_cb(const struct nlattr *attr, void *data);
> >>> diff --git a/rdma/utils.c b/rdma/utils.c
> >>> index 069d44fece10..a6f2826c9605 100644
> >>> --- a/rdma/utils.c
> >>> +++ b/rdma/utils.c
> >>> @@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback=
, void *data, unsigned int seq)
> >>>  	return ret;
> >>>  }
> >>>
> >>> +static int null_cb(const struct nlmsghdr *nlh, void *data)
> >>> +{
> >>> +	return MNL_CB_OK;
> >>> +}
> >>> +
> >>> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	ret =3D rd_send_msg(rd);
> >>> +	if (ret) {
> >>> +		perror(NULL);
> >> This is more or less already done in rd_send_msg() and that function
> >> prints something in case of execution error. So the missing piece
> >> is to update rd_recv_msg(), so all places will "magically" print errors
> >> and not only dev_set_name().
> >>
> >>> +		goto out;
> >>> +	}
> >>> +	ret =3D rd_recv_msg(rd, null_cb, rd, seq);
> > Will this "null_cb" work for all send/recv flows or only in flows where
> > response can be error only?
>
>
> Only those flows where no nl attributes are expected to be returned.
>
>
> > Will we need this recv_msg if we implement
> > extack support?
>
>
> I'm not sure how extack works.=A0 Do you know?

I can't say that :)

>
> Thanks!
>
> Steve.
>
>

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcdZCVAAoJEORje4g2clin4I8P/27BfRaixBFPDW5RVgZcf1oO
aF5ZEqfL69d/Fl42/rkImuewTqzzouh2fu2inrt+hcs2sWpf6rLZDSWsOsHUCHIL
+J8Hplh8S3FbeLjoY8J3ZHXQLhJaVtE82vT0NI0qJltGSEL1ALX/IRxSUE02YAWD
xvxpqBRzYoFBC0PYiiw1KCEIY9fo8cdH8pgrQBlH+o67R/s7UdwPo0FdG6lsFvC5
eT2N6D5bWqzRq6kdG0kZkZRwUsiO7oepFxD187WzKLj9RrVzaY8ABIj7jfS+5nJt
HT1Pa/Tnrco5I34ocwMpVAUhdiV9kjXSfzxQD8WOQfp2NNAL//BlecVOUp2p9aey
xzMUorMXBXbulUTxRh6H8IrDn1NjHJqOI6xTkzWo/jjemdWZB8+zq/CSXsiszdnd
7426M5ICTOaypEjG2g0ad2c99ORprjQUURG5ne9UxFfgBwUkVxyD9Vypgr0oxvzJ
kSzQSJmT5PKTxvTj/RQu0f8UqFz804n1Ick9lbBVENxeFnRDeEu1HNYlCuL7NiAs
j2mK2YnI8jHffmQI4uhy7aTBzAy/VoFI5jtIqSibQJCmO6OpHmkNEHr02WYAQ/o5
XUJ9cAKusI0bTtW40LRKThzjdfNODpY/U3ZTwOFCmgQrnZAJJ7eMk4TYahAjCjvf
p0erwgZ1qhdsyMeW7xET
=7jQM
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--
