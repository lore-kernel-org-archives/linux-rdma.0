From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Sun, 3 Mar 2019 15:50:52 +0200
Message-ID: <20190303135052.GY15253@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <11ec7e04-1bff-e3b2-1b89-db134cd537ba@opengridcomputing.com>
 <021201d4ceda$56d9e560$048db020$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kLVKJMuKEUFaIs8+"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <021201d4ceda$56d9e560$048db020$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--kLVKJMuKEUFaIs8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 27, 2019 at 02:23:45PM -0600, Steve Wise wrote:
>
>
> > -----Original Message-----
> > From: Steve Wise <swise@opengridcomputing.com>
> > Sent: Tuesday, February 26, 2019 11:14 AM
> > To: Leon Romanovsky <leon@kernel.org>
> > Cc: dsahern@gmail.com; stephen@networkplumber.org;
> > netdev@vger.kernel.org; linux-rdma@vger.kernel.org
> > Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper
> > rd_sendrecv_msg()
> >
> >
> > On 2/23/2019 3:26 AM, Leon Romanovsky wrote:
> > > On Thu, Feb 21, 2019 at 08:19:03AM -0800, Steve Wise wrote:
> > >> This function sends the constructed netlink message and then
> > >> receives the response, displaying any error text.
> > >>
> > >> Change 'rdma dev set' to use it.
> > >>
> > >> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > >> ---
> > >>  rdma/dev.c   |  2 +-
> > >>  rdma/rdma.h  |  1 +
> > >>  rdma/utils.c | 21 +++++++++++++++++++++
> > >>  3 files changed, 23 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/rdma/dev.c b/rdma/dev.c
> > >> index 60ff4b31e320..d2949c378f08 100644
> > >> --- a/rdma/dev.c
> > >> +++ b/rdma/dev.c
> > >> @@ -273,7 +273,7 @@ static int dev_set_name(struct rd *rd)
> > >>  	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd-
> > >dev_idx);
> > >>  	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME,
> > rd_argv(rd));
> > >>
> > >> -	return rd_send_msg(rd);
> > >> +	return rd_sendrecv_msg(rd, seq);
> > >>  }
> > >>
> > >>  static int dev_one_set(struct rd *rd)
> > >> diff --git a/rdma/rdma.h b/rdma/rdma.h
> > >> index 547bb5749a39..20be2f12c4f8 100644
> > >> --- a/rdma/rdma.h
> > >> +++ b/rdma/rdma.h
> > >> @@ -115,6 +115,7 @@ bool rd_check_is_key_exist(struct rd *rd, const
> > char *key);
> > >>   */
> > >>  int rd_send_msg(struct rd *rd);
> > >>  int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, uint32_t
> > seq);
> > >> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq);
> > >>  void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq,
> uint16_t
> > flags);
> > >>  int rd_dev_init_cb(const struct nlmsghdr *nlh, void *data);
> > >>  int rd_attr_cb(const struct nlattr *attr, void *data);
> > >> diff --git a/rdma/utils.c b/rdma/utils.c
> > >> index 069d44fece10..a6f2826c9605 100644
> > >> --- a/rdma/utils.c
> > >> +++ b/rdma/utils.c
> > >> @@ -664,6 +664,27 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback,
> > void *data, unsigned int seq)
> > >>  	return ret;
> > >>  }
> > >>
> > >> +static int null_cb(const struct nlmsghdr *nlh, void *data)
> > >> +{
> > >> +	return MNL_CB_OK;
> > >> +}
> > >> +
> > >> +int rd_sendrecv_msg(struct rd *rd, unsigned int seq)
> > >> +{
> > >> +	int ret;
> > >> +
> > >> +	ret = rd_send_msg(rd);
> > >> +	if (ret) {
> > >> +		perror(NULL);
> > > This is more or less already done in rd_send_msg() and that function
> > > prints something in case of execution error. So the missing piece
> > > is to update rd_recv_msg(), so all places will "magically" print errors
> > > and not only dev_set_name().
> >
> > Yea ok.
> >
>
> dev_set_name() doesn't call rd_recv_msg().  So you're suggesting I fix up
> rd_recv_msg() to display errors and make dev_set_name() call rd_recv_msg()
> with the null_cb function?  You sure that's the way to go?

I'm sure that we need to fix dev_set_name(), everything else I'm not sure.

Thanks

>
>
>
>

--kLVKJMuKEUFaIs8+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJce9u8AAoJEORje4g2clin2ysQAJMyn6Cyp+Ap1PV/cE3bPxvC
7kEUgp4riN7xjelAo9UzIhve+AX3L2/KGNaJUS1J4KoFx9heZM3nB32spGD5Ng6D
UYy8ND3W/RX1Hyea/L+Uhbc0g7R2+AlTAuksnc1B2QvErl4ahOgNHvnDl3GafYra
lT97iVr4kImahZIj1JjxfjqK9HPT2eBUvhiZt7laSu9sHosyhhlMGmt1olZFsV0B
SPcG4XJ2RvWd9tAMKRMS9ti9GMCzgH29E6JfcgPbe7QOc1Xx28bbNJqNlaYLfezQ
vxgNHfq/pVjN2vsGg/2Arf8LvElXb8gqiEEAT/rmGOcYvF6OWHXjjcaLmv1aF7iu
NOMrzisz/ERz5rDuQ4MWBagOTZbuLhkuMcCqkUEBT3s0dIMNm2RaYdaKFlpoSLvC
VVHJefJIffxQbCbIHto9Yn7iK0vCmE3RtOrLl3wjBI9hJFGn2Dq/HR8TdFwxSGHC
GXlL9RU9nNHfEaZeaBt6OA/nG9xjn6qW/Qq8+chcBZmnQbVFOwDaAgglRMw4syKe
5aXPqCIZeKydzYf3vQykCdiBtzGAo3Ott3zjASMupg16bcJpoawZfFnoqocRfpfn
YnFyE/pwaUsKOIFVKjulVsfAuMCZT/0tR4rV8SzgzNc+Ql7WkSYb2CnTrGfvRSmr
nKmxstqgBQox0Un5H7ud
=rNDy
-----END PGP SIGNATURE-----

--kLVKJMuKEUFaIs8+--
