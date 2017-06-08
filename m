From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Thu, 8 Jun 2017 20:51:41 +0300
Message-ID: <20170608175141.GN1127@mtr-leonro.local>
References: <20170608143852.9072-1-leon@kernel.org>
 <20170608143852.9072-2-leon@kernel.org>
 <88fb8d57-cd02-78bc-3045-c09f62c280b9@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i6vqABX3nJKXLk01"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <88fb8d57-cd02-78bc-3045-c09f62c280b9-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--i6vqABX3nJKXLk01
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 08, 2017 at 08:29:25AM -0700, Bart Van Assche wrote:
> On 06/08/17 07:38, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > RDMA netlink has complicated infrastructure to add and remove netlink
> > clients to NETLINK_RDMA family. This complicates the code and not in
> > use because not many clients are available (3 clients) and most of them
> > (2 clients) are statically compiled together with netlink.c.
> >
> > The following patch refactors RDMA netlink and opens door for the future
> > patches which will be able to get rid of a lot of dead iwcm* code.
>
> Hello Leon,
>
> There are multiple changes in this patch:
> - Renaming ibnl_add_client() and ibnl_remove_client() into
> rdma_nl_register() and rdma_nl_unregister().
> - Removal of the module pointers from ibnl_ls_cb_table[].
> - Conversion of client_list from a linked list into an array
> (rdma_nl_types[]).
>
> Could this patch have been split?

I tried, but once I got rid of the client (delete function), i was
required to change the function signature and while I was there, I changed
the name. So if it is possible, I would like to have one patch and not
many patches which changes the same lines of code.

>
> > +static bool is_nl_msg_valid(unsigned int type, unsigned int op)
> >  {
> > -	[ ... ]
> > +	unsigned int max_num_ops;
> > +
> > +	switch (type) {
> > +	case RDMA_NL_RDMA_CM:
> > +		max_num_ops = RDMA_NL_RDMA_CM_NUM_OPS;
> > +		break;
> > +	case RDMA_NL_IWCM:
> > +		max_num_ops = RDMA_NL_IWPM_NUM_OPS;
> > +		break;
> > +	case RDMA_NL_LS:
> > +		max_num_ops = RDMA_NL_LS_NUM_OPS;
> > +		break;
> > +	case RDMA_NL_RSVD:
> > +	case RDMA_NL_I40IW:
> > +	default:
> > +		return false;
> >  	}
> > +	return (op < max_num_ops) ? true : false;
> > +}
>
> Can this code be made more compact by storing the *_NUM_OPS constants in
> an array?

I thought that it is more easy to read, but have no strong opinion about
it.

>
> > +void rdma_nl_register(unsigned int index,
> > +		      const struct ibnl_client_cbs cb_table[])
> >  {
> > -	[ ... ]
> > -	return -EINVAL;
> > +	rdma_nl_types[index].cb_table = cb_table;
> > +	mutex_unlock(&rdma_nl_mutex);
> > +}
> > +EXPORT_SYMBOL(rdma_nl_register);
>
> Shouldn't this function return an error code or print a warning message
> if rdma_nl_types[index].cb_table had already been set?

Agree, warning will be good there. I don't want to return value from
this function, because callers are not really interested in
success/failure once they finished to debug their code.

>
> Otherwise this patch looks like a welcome cleanup and simplification to me.

Thanks for taking time to look on these patches.

>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i6vqABX3nJKXLk01
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk5jq0ACgkQ5GN7iDZy
WKe39g//ZdZsNExxT+lIrBBUH8Kxp2GaBMvoij76LqAlk+NrrM85SjKG+r4eE7qa
EYSfINE9jJQxykUCJwdojmlO9h7L+b2+fDefkQ7iiaqiQBl6Z+K+uCJZoQFNum+8
jb86i0HwxPkVbtwvakk75bA+rA0yaV9dPkUSHFg+Qo6k7T7kpfPH0cQgh/Acjn7E
3JMaT7NtWRoZ4qMY6FoJ4DxiXPH+SKNZuHt+0uqGw3XulG+TniC9wXGlK9CXwAUo
ZWclrqAfGCNpuWnvqba0qnJJbAkjV2Wl14Z1XnqCSEaGyAuFcSuCQDGbvxQs1VpP
TUPQ1vXerpAzcfgHrTSY10eNrAcvOPOYZL11ELLj8gaAmDQVvrvSnDHZVPblyfKz
xE/yAKc1l5hhzSj9t3kGdW07fq0cC0vnHv3pKLA1bglRIHg5Z7vt4YLLZXwjDKvm
IKQPMvBBcJ6e9lkrGEC8okwYG6qNxbjrNOz9yGgyfPfNTTEyZDSfFaiu41xW5OeI
F9vpCl6lK4jrmZO4j9wggVWbV825ig0G3CzKJPHXOuXfgrrYvwp36MpowBf7vYq7
L3MeRHYVnUrTl7dNBdttyfNCLpvkTMlK1YyVPxD9Ffy6fCUObXy4qE8GTfpR5D0E
zmytoJC0kPSpj43ykQxU+7H38X72qktpUS3QdsvjkJboBL0hkvo=
=mY7m
-----END PGP SIGNATURE-----

--i6vqABX3nJKXLk01--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
