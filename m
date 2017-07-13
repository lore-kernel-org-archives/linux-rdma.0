From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings in
 GCC 7.1
Date: Thu, 13 Jul 2017 15:06:11 +0000
Message-ID: <1499958370.2740.4.camel@wdc.com>
References: <20170713133935.1206-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713133935.1206-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <CAFA331B319FDC498FDE2F2AB7A57A58-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 16:39 +0300, Leon Romanovsky wrote:
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index 1fe79671..da0fe733 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -1220,6 +1220,7 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct =
ibv_send_wr *wr,
>  			 * LE platform be32toh will do the job.
>  			 */
>  			hdr->key_immd =3D htole32(be32toh(wr->imm_data));
> +			/* FALLTHROUGH */

Hello Leon,

In other rdma-core source files the annotation "/* fall through */" is used=
.
See also the output of git grep -nHi '/\* *fall[ -]*through'. Should we ens=
ure
that these annotations are consistent in the rdma-core source tree?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
