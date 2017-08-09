From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 08/33] RDMA/netlink: Simplify the put_msg and
 put_attr
Date: Wed, 9 Aug 2017 21:39:40 +0300
Message-ID: <20170809183940.GN1423@mtr-leonro.local>
References: <20170809160405.25142-1-leon@kernel.org>
 <20170809160405.25142-9-leon@kernel.org>
 <03e0ce22-ad9d-eb7d-be75-b87bc9aa1005@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jITzwD3HDGXid3BE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03e0ce22-ad9d-eb7d-be75-b87bc9aa1005-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jITzwD3HDGXid3BE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2017 at 01:00:21PM -0400, Doug Ledford wrote:
> On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Reuse standard macros to cancel the netlink message
> > in case of error.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/core/netlink.c | 31 +++++++++----------------------
> >  1 file changed, 9 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> > index c5ee62a24960..fc8b45d4140a 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -126,36 +126,23 @@ EXPORT_SYMBOL(rdma_nl_unregister);
> >  void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
> >  		   int len, int client, int op, int flags)
> >  {
> > -	unsigned char *prev_tail;
> > -
> > -	prev_tail = skb_tail_pointer(skb);
> > -	*nlh = nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op),
> > -			 len, flags);
> > -	if (!*nlh)
> > -		goto out_nlmsg_trim;
> > -	(*nlh)->nlmsg_len = skb_tail_pointer(skb) - prev_tail;
> > +	*nlh = nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op), len, flags);
> > +	if (!*nlh) {
> > +		nlmsg_cancel(skb, *nlh);
>                                   ^^^^ This looks funny.  It's
> technically correct, but it looks like an error because you are using a
> value that we just checked for an error, saw an error, and then use it
> anwyay.  I would prefer that be NULL instead just like you write return
> NULL just below.

You are right from the machine-perspective, it is correct code, because
nlmxg_cancel is actually calling to nlmg_trim, which checks the provided
argument (*nlh) for NULL and skips it. But from the code reviewer, it is
better to just remove this nlmsg_cancel line because it does nothing.

>
> > +		return NULL;
> > +	}
> >  	return nlmsg_data(*nlh);
> > -
> > -out_nlmsg_trim:
> > -	nlmsg_trim(skb, prev_tail);
>
> In the new code, on error, you cancel the message outright, while the
> old code here does a nlmsg_trim().  Isn't this a functional change in
> addition to just switching to using the standard helpers?  Same question
> for below...

nlmsg_cancel calls unconditionally to nlmsg_trim and the code was
restructured in such way that nlmsg_trim is always executed in these
flows, so no actual functional change.

 540 static inline void nlmsg_trim(struct sk_buff *skb, const void *mark)
 541 {
 542         if (mark) {
 543                 WARN_ON((unsigned char *) mark < skb->data);
 544                 skb_trim(skb, (unsigned char *) mark - skb->data);
 545         }
 546 }

 <...>

 556 static inline void nlmsg_cancel(struct sk_buff *skb, struct nlmsghdr *nlh)
 557 {
 558         nlmsg_trim(skb, nlh);
 559 }


>
> > -	return NULL;
> >  }
> >  EXPORT_SYMBOL(ibnl_put_msg);
> >
> >  int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  		  int len, void *data, int type)
> >  {
> > -	unsigned char *prev_tail;
> > -
> > -	prev_tail = skb_tail_pointer(skb);
> > -	if (nla_put(skb, type, len, data))
> > -		goto nla_put_failure;
> > -	nlh->nlmsg_len += skb_tail_pointer(skb) - prev_tail;
> > +	if (nla_put(skb, type, len, data)) {
> > +		nlmsg_cancel(skb, nlh);
> > +		return -EMSGSIZE;
> > +	}
> >  	return 0;
> > -
> > -nla_put_failure:
> > -	nlmsg_trim(skb, prev_tail - nlh->nlmsg_len);
> > -	return -EMSGSIZE;
> >  }
> >  EXPORT_SYMBOL(ibnl_put_attr);
> >
> >
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--jITzwD3HDGXid3BE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmLVuwACgkQ5GN7iDZy
WKcd5g//aKTMj81cfhUbLUbBtlEgnOWPi35Wv0BqybRKwyMWLykaJeqVi0h9smyR
qNs2L3yazyvNWCDJADNmrVGw/4fnp1xPdfs2Xj9C6ToIYNy95JQxpoLKdaICdJ3d
EKNy4b08jVGlaeo+1S3jjSrcsAr4g6mWMfipY0UqDxsgklGJChpoKhh/KBPssnE+
e+4NBLzSJ2VNwL5TkMrTqVt+LL4VRQIb6jjT3OvoDNgwi/m+TChTHJ8qtvO+sK2g
19s0yCK7nfZPNF6iwVT5MR8SqSscmpS6G5DMLyfEIUFJQcihCNUC9iG9sfpBl/g1
FZ6rl0Opu8hjezzg+hZVgTeGO/P5gB3oqOKFIDij6gMh/NLtM+G/6iJAIG7IpbtA
kxFCP9l0E7dPYDdnqqDzVExCHMmWJMk2CviCoT1FoMHgEw0AQP3oqnbo3IZRUl19
pDgVWKFsqXaYzsu2k3zwtP7lxSUByzu2/eFLh4V2vCyUmaFcsUuPH3Zmm9MVMQ9O
CSDFZ45Cfnt5nk4hzOfM5y3zKK9sd3i+AYdWAlFnEZ8yxF6kk9WKDYgBqL/31WhN
ir1R+Sdir3FLKq9Eb6sK34ElKCm2HdZ/EQJBcdQ4XJqH1FUqe6KUGLQl0+SrJHJj
Hjcptbc/rVg0JgR6MrI3YTDRda+1mbucTHNOkmZtRwqQEtGMnpA=
=C41G
-----END PGP SIGNATURE-----

--jITzwD3HDGXid3BE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
