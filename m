From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 23/33] RDMA/netlink: Add nldev port dumpit
 implementation
Date: Thu, 10 Aug 2017 12:16:07 +0300
Message-ID: <20170810091607.GR1423@mtr-leonro.local>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-24-leon@kernel.org>
 <de32381b-0c70-620c-463c-9e89f8ea0388@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <de32381b-0c70-620c-463c-9e89f8ea0388-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 01:47:48PM -0400, Doug Ledford wrote:
> On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch implements the query interface to get all
> > ports data for the specific device.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/core/nldev.c | 61 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> > index 666940f2b49a..4413eda8c435 100644
> > --- a/drivers/infiniband/core/nldev.c
> > +++ b/drivers/infiniband/core/nldev.c
> > @@ -53,6 +53,18 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
> >  	return 0;
> >  }
> >
> > +static int fill_port_info(struct sk_buff *msg,
> > +			  struct ib_device *device, u32 port)
> > +{
> > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_DEV_INDEX, device->index))
> > +		return -EMSGSIZE;
> > +	if (nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_NAME, device->name))
> > +		return -EMSGSIZE;
> > +	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
> > +		return -EMSGSIZE;
> > +	return 0;
> > +}
> > +
> >  static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  			  struct netlink_ext_ack *extack)
> >  {
> > @@ -129,11 +141,60 @@ static int nldev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
> >  	return ib_enum_all_devs(_nldev_get_dumpit, skb, cb);
> >  }
> >
> > +static int nldev_port_get_dumpit(struct sk_buff *skb,
> > +				 struct netlink_callback *cb)
> > +{
> > +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
> > +	struct ib_device *device;
> > +	int start = cb->args[0];
> > +	struct nlmsghdr *nlh;
> > +	u32 idx = 0;
> > +	u32 ifindex;
> > +	int err;
> > +	u32 p;
> > +
> > +	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
> > +			  nldev_policy, NULL);
> > +	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
> > +		return -EINVAL;
> > +
> > +	ifindex = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> > +	device = __ib_device_get_by_index(ifindex);
> > +	if (!device)
> > +		return -EINVAL;
> > +
> > +	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
> > +		if (idx < start) {
> > +			idx++;
> > +			continue;
> > +		}
>
> So, to someone who has been studying netlink internals (aka, you), the
> relationship between cb->args[0] to start to idx to p may make sense.
> To those of us that aren't totally versed in what appears to be a
> recursive callback, but which isn't clear on how cb->args[0] ever gets
> initialized the first time, or how the idx in ib_enum_all_devs()
> translates to the idx here, a few comments in the code might be helpful.

I added the following comment block.

270                 /*
271                  * The dumpit function returns all information from specific
272                  * index. This specific index is taken from the netlink
273                  * messages request sent by user and it is available
274                  * in cb->args[0].
275                  *
276                  * Usually, the user doesn't fill this field and it causes
277                  * to return everything.
278                  *
279                  */

>
> > +
> > +		nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
> > +				cb->nlh->nlmsg_seq,
> > +				RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
> > +						 RDMA_NLDEV_CMD_PORT_GET),
> > +				0, NLM_F_MULTI);
> > +
> > +		if (fill_port_info(skb, device, p)) {
> > +			nlmsg_cancel(skb, nlh);
> > +			goto out;
> > +		}
> > +		idx++;
> > +		nlmsg_end(skb, nlh);
> > +	}
> > +
> > +out:	cb->args[0] = idx;
> > +	return skb->len;
> > +}
> > +
> >  static const struct rdma_nl_cbs nldev_cb_table[] = {
> >  	[RDMA_NLDEV_CMD_GET] = {
> >  		.doit = nldev_get_doit,
> >  		.dump = nldev_get_dumpit,
> >  	},
> > +	[RDMA_NLDEV_CMD_PORT_GET] = {
> > +		.dump = nldev_port_get_dumpit,
> > +	},
> >  };
> >
> >  void __init nldev_init(void)
> >
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmMJFYACgkQ5GN7iDZy
WKcIGA/+KWlUFC0p3/OI+1r+lR26xp5MVbxDlknuyhY8BKqAtXGTZHu52yGn1JNv
miZqyosDwjkhh/cD9aDc8AQVByOHyK2lFrxS1WVbXcjiikGrRkNub04jijN/ZnHF
NcjLiPcNwcg3By+krRfiUW+zLMfcD8Cp8x2trltj67UnzjoYdLPP5H9bRg3vj0BA
OFA3eOB9eBpCKypPL674THfnjp6/TgXb/YVsswS0miBQsZsO5KH9bJNRXt+oFKV8
o5apiG7MTsbuLwHeDO0YGi5BgFuE0AagA2eTpBSlD1R4gZw80jekpC8+JUs4P+US
rf8svU+gXWKszmMx9B668nqYYh2sQfNeaGjlYJb8hsIUDHF8elA63lUG5nJcUHMH
o5ywTlrytAv6XVkd46hmijK9FOrKgXTlbUw0dxpCMsHlyX0HIYy61wgMBPISGAhB
+rS5eS/OhzlSGAudPI7CUkkW+dt+Tq54rBouDFyCuZVJ1tCmX5HfPGFmP639JGTr
OzY4b+gbSf7V8kHPtJdxyMUjyikmBXR704jl0Ib5QQwtlhoGIpyhJ04BLJi2MU/q
qpj2WSDqHYz8TSEcD7ePAFwrM7db2P6d8Jd1UoQ7AW85DfUNp/id7Y/kjVwbpSWG
DoQcvk0z8zXuy0m8CYUpJMEdKl2g8uy6kVFmTZUmEDewe+beTNg=
=06lP
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
