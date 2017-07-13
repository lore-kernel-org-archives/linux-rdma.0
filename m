From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 18:34:22 +0300
Message-ID: <20170713153422.GO1528@mtr-leonro.local>
References: <20170713133935.1206-1-leon@kernel.org>
 <1499958370.2740.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vPnpcpkNijKiMczX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499958370.2740.4.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vPnpcpkNijKiMczX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2017 at 03:06:11PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 16:39 +0300, Leon Romanovsky wrote:
> > diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> > index 1fe79671..da0fe733 100644
> > --- a/providers/bnxt_re/verbs.c
> > +++ b/providers/bnxt_re/verbs.c
> > @@ -1220,6 +1220,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
> >  			 * LE platform be32toh will do the job.
> >  			 */
> >  			hdr->key_immd = htole32(be32toh(wr->imm_data));
> > +			/* FALLTHROUGH */
>
> Hello Leon,
>
> In other rdma-core source files the annotation "/* fall through */" is used.
> See also the output of git grep -nHi '/\* *fall[ -]*through'. Should we ensure
> that these annotations are consistent in the rdma-core source tree?

Yes, better to have consistency. I took this "FALLTHROUGH" from kernel
source.

I'll resend.

Thanks

>
> Bart.

--vPnpcpkNijKiMczX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnkv4ACgkQ5GN7iDZy
WKeeVRAAzCnE+KXv0s3S19H8AOWqWVkTgeDJsTHW6YrF+Fa1OdOuOKQcfidXl2qX
MsuXlL47ahL4tUVulNhhKz9S8W/qqxv0xUHISJksE/K8WGBjb8QkfvfCr7lzlgXE
FBCcPAxRw+2sR0wF6Go6QICsh2mKBliCF9bGJm2Ho7YTKAXKqCbO988yB9TSfz/7
ql4k32ALSRH+oYlOT3lt87fp+5F0V8cGeiHEBXhgcbkfVs8Z8Js9L+0hW8bQ1ynL
d+yDqO3hpDIyz1TDB8V5cMk9BcjBB4lqsuYVziyzq3CuoXFE6EYw4X1Aa8Uki/IX
3lH8VdTMTBbIlQ0E2F6inXNzrSmgyQM6T5lxepeQFfjCeEX8qK8rZCFOJpZcr600
5+CNNoiwOshn6LUhKdToJaNmVT9CX7O6KYByT+4CtZmXZHRjehp31aBrZ+JOqn77
scKVzeRHmreITVe5WcaSmma+YTPNJgx7+0iF16P8Ph1nd9usGhI1xGl96eZxUxGZ
jrTEM0EWED2U3wefilB4a8zSFdE7ua0Oez56ty1r4G4aRLUCHBf/PGCsMhHtvTC/
vsD5ANp1o+VZMbiO8KXVd+xi1q4W+Dp4A1Nrc+2rhsRee9Dzbauh88ZPVLPrRYIL
AeiEZP5lfmPxU2MbPTc//DkzzIIJxKnFlnPlnNmcNc/qkU0xC4E=
=F7Q7
-----END PGP SIGNATURE-----

--vPnpcpkNijKiMczX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
