From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Sat, 23 Feb 2019 11:31:22 +0200
Message-ID: <20190223093122.GO23561@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cy9Nn4fUvYST66Pl"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190223092615.GM23561@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--cy9Nn4fUvYST66Pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 23, 2019 at 11:26:15AM +0200, Leon Romanovsky wrote:
> On Thu, Feb 21, 2019 at 08:19:03AM -0800, Steve Wise wrote:
> > This function sends the constructed netlink message and then
> > receives the response, displaying any error text.
> >
> > Change 'rdma dev set' to use it.
> >
> > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > ---
> >  rdma/dev.c   |  2 +-
> >  rdma/rdma.h  |  1 +
> >  rdma/utils.c | 21 +++++++++++++++++++++
> >  3 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/rdma/dev.c b/rdma/dev.c
> > index 60ff4b31e320..d2949c378f08 100644
> > --- a/rdma/dev.c
> > +++ b/rdma/dev.c
> > @@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
> >  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
> >  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, rd_argv(rd));
> >
> > -	return rd_send_msg(rd);
> > +	return rd_sendrecv_msg(rd, seq);
> >  }
> >
> >  static int dev_one_set(struct rd *rd)
> > diff --git a/rdma/rdma.h b/rdma/rdma.h
> > index 547bb5749a39..20be2f12c4f8 100644
> > --- a/rdma/rdma.h
> > +++ b/rdma/rdma.h
> > @@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const char *key);
> >   */
> >  int rd_send_msg(struct rd *rd);
> >  int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t seq);
> > +int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
> >  void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags);
> >  int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
> >  int rd_attr_cb(const struct nlattr *attr, void *data);
> > diff --git a/rdma/utils.c b/rdma/utils.c
> > index 069d44fece10..a6f2826c9605 100644
> > --- a/rdma/utils.c
> > +++ b/rdma/utils.c
> > @@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, unsigned int seq)
> >  	return ret;
> >  }
> >
> > +static int null_cb(const struct nlmsghdr *nlh, void *data)
> > +{
> > +	return MNL_CB_OK;
> > +}
> > +
> > +int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
> > +{
> > +	int ret;
> > +
> > +	ret = rd_send_msg(rd);
> > +	if (ret) {
> > +		perror(NULL);
>
> This is more or less already done in rd_send_msg() and that function
> prints something in case of execution error. So the missing piece
> is to update rd_recv_msg(), so all places will "magically" print errors
> and not only dev_set_name().
>
> > +		goto out;
> > +	}
> > +	ret = rd_recv_msg(rd, null_cb, rd, seq);

Will this "null_cb" work for all send/recv flows or only in flows where
response can be error only? Will we need this recv_msg if we implement
extack support?

> > +	if (ret)
> > +		perror(NULL);
> > +out:
> > +	return ret;
> > +}
> > +
> >  static struct dev_map *_dev_map_lookup(struct rd *rd, const char *dev_name)
> >  {
> >  	struct dev_map *dev_map;
> > --
> > 1.8.3.1
> >



--cy9Nn4fUvYST66Pl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccRLqAAoJEORje4g2clinLnIP/3zQqUeOfhOGFVfrQIiZTOvO
s6He5CdBWH7rrTtxhhoMSg1wCUDRrZ0VSjq92fo8Egpro48OS5AyZfmrZxxgo/6g
UtOITx/DlqsH4l0+tACED+ATNCZMrvxnSr6sRPTYul9bgTTa/582Gba0zJKnuQYF
HVIelnyn8a7s5uOFTDhjRa9HlvA0ICQMA6nqz/PleXzPaYpFlkklGtxNB3lotxJP
q/B7rDUBakxeKs0PMQIOudfD1WlC8NTgxl5uNF7XERWLx5+2cl4x8ZLbhdxyLa6j
BfhYt+pb0pcqqxtCGDv6UVyjHUnLyLeh5iAPjVUl4IZmggYA2gBV7xKPDinfictA
FHv+q6/Op+qpdC/xqV8jJDu0YnDXDrrz/IPllTm6ZsK9P1MnwjI93LVXZJ03sHB7
gBsQThhJ06wcT+7g5sI3fwq2IxCgMAuOfpTaCF0E4KS883TPf1ZuHea6Qyk26RWp
LRY3zfCpZc4EQ6Og917tOkqOwmuiER8GGrCf57lYMTmtKAh/X/cDPje6w/8DyYwj
TxMiqpNBm9RBNas0Y2AlljtUOJacilASCuqw+t7N6Igrv0rjoXquFDbylEbQ4Dkd
qevNwazB1O0RZQX7ANaEmHPvkFBgUJMJGW2veJo2pgpESoYu4laFBDeaH9cEvqO2
kHxG4BwQ0XR96x/26/Xn
=CSwj
-----END PGP SIGNATURE-----

--cy9Nn4fUvYST66Pl--
