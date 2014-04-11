From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] nfs-rdma: Fix for FMR leaks
Date: Fri, 11 Apr 2014 16:54:15 -0400
Message-ID: <36E0E306-3227-4F42-AD1F-9A8B2AFB574E@oracle.com>
References: <nyc61n00p3VzoHe01yc7ug> <002e01cf5444$a58c2c10$f0a48430$@cox.net>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002e01cf5444$a58c2c10$f0a48430$@cox.net>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Allen Andrews <allen.andrews-j9pdmedNgrk@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Allen-

I reviewed and tested your patch. Comments inline below.


On Apr 9, 2014, at 6:40 PM, Allen Andrews <allen.andrews-j9pdmedNgrk@public.gmane.org> wrote=
:

> Two memory region leaks iwere found during testing:
>=20
> 1. rpcrdma_buffer_create: While allocating RPCRDMA_FRMR's ib_alloc_fa=
st_reg_mr is called and then ib_alloc_fast_reg_page_list is called.  If=
 ib_alloc_fast_reg_page_list returns an error it bails out of the routi=
ne dropping the last ib_alloc_fast_reg_mr frmr region creating a memory=
 leak.  Added code to dereg the last frmr if ib_alloc_fast_reg_page_lis=
t fails.
>=20
> 2. rpcrdma_buffer_destroy: While cleaning up, the routine will only f=
ree the MR's on the rb_mws list if there are rb_send_bufs present.  How=
ever, in rpcrdma_buffer_create while the rb_mws list is being built if =
one of the MR allocation requests fail after some MR's have been alloca=
ted on the rb_mws list the routine never gets to create any rb_send_buf=
s but instead jumps to the rpcrdma_buffer_destroy routine which will ne=
ver free the MR's on rb_mws
> list because the rb_send_bufs were never created.   This leaks all th=
e MR's
> on the rb_mws list that were created prior to one of the MR allocatio=
ns failing.
>=20
> Issue(2) was seen during testing. Our adapter had a finite number of =
MR's available and we created enough connections to where we saw an MR =
allocation failure on our Nth NFS connection request. After the kernel =
cleaned up the resources it had allocated for the Nth connection we not=
iced that FMR's had been leaked due to the coding error described above=
=2E
>=20
> Issue(1) was seen during a code review while debugging issue(2).
>=20
> Signed-off-by: Allen Andrews <allen.andrews-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>=20
> net/sunrpc/xprtrdma/verbs.c |   79 ++++++++++++++++++++++++----------=
---------
> 1 files changed, 44 insertions(+), 35 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c index 9372656..54f592d 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1058,6 +1058,14 @@ rpcrdma_buffer_create(struct rpcrdma_buffer *b=
uf, struct rpcrdma_ep *ep,
> 				dprintk("RPC:       %s: "
> 					"ib_alloc_fast_reg_page_list "
> 					"failed %i\n", __func__, rc);
> +
> +				rc =3D ib_dereg_mr(r->r.frmr.fr_mr);

This clears =93rc,=94 wiping the error returned by ib_alloc_fast_reg_pa=
ge_list().

Then rpcrdma_buffer_create() returns zero, even though it failed, and x=
prtrdma thinks the
transport is set up and ready for use. Panic.

I think you can safely ignore the return code from ib_dereg_mr() here.


> +				if (rc)
> +					dprintk("RPC:       %s:"
> +						" ib_dereg_mr"
> +						" failed %i\n",
> +						__func__, rc);
> +
> 				goto out;
> 			}
> 			list_add(&r->mw_list, &buf->rb_mws); @@ -1194,41 +1202,6 @@ rpcrdm=
a_buffer_destroy(struct rpcrdma_buffer *buf)

This line is broken: the =93@@=93 should start on the next line. Some k=
ind of e-mail snafu?


> 			kfree(buf->rb_recv_bufs[i]);
> 		}
> 		if (buf->rb_send_bufs && buf->rb_send_bufs[i]) {
> -			while (!list_empty(&buf->rb_mws)) {
> -				r =3D list_entry(buf->rb_mws.next,
> -					struct rpcrdma_mw, mw_list);
> -				list_del(&r->mw_list);
> -				switch (ia->ri_memreg_strategy) {
> -				case RPCRDMA_FRMR:
> -					rc =3D ib_dereg_mr(r->r.frmr.fr_mr);
> -					if (rc)
> -						dprintk("RPC:       %s:"
> -							" ib_dereg_mr"
> -							" failed %i\n",
> -							__func__, rc);
> -					ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
> -					break;
> -				case RPCRDMA_MTHCAFMR:
> -					rc =3D ib_dealloc_fmr(r->r.fmr);
> -					if (rc)
> -						dprintk("RPC:       %s:"
> -							" ib_dealloc_fmr"
> -							" failed %i\n",
> -							__func__, rc);
> -					break;
> -				case RPCRDMA_MEMWINDOWS_ASYNC:
> -				case RPCRDMA_MEMWINDOWS:
> -					rc =3D ib_dealloc_mw(r->r.mw);
> -					if (rc)
> -						dprintk("RPC:       %s:"
> -							" ib_dealloc_mw"
> -							" failed %i\n",
> -							__func__, rc);
> -					break;
> -				default:
> -					break;
> -				}
> -			}
> 			rpcrdma_deregister_internal(ia,
> 					buf->rb_send_bufs[i]->rl_handle,
> 					&buf->rb_send_bufs[i]->rl_iov);
> @@ -1236,6 +1209,42 @@ rpcrdma_buffer_destroy(struct rpcrdma_buffer *=
buf)
> 		}
> 	}
>=20
> +	while (!list_empty(&buf->rb_mws)) {
> +		r =3D list_entry(buf->rb_mws.next,
> +			struct rpcrdma_mw, mw_list);
> +		list_del(&r->mw_list);
> +		switch (ia->ri_memreg_strategy) {
> +		case RPCRDMA_FRMR:
> +			rc =3D ib_dereg_mr(r->r.frmr.fr_mr);
> +			if (rc)
> +				dprintk("RPC:       %s:"
> +					" ib_dereg_mr"
> +					" failed %i\n",
> +					__func__, rc);
> +			ib_free_fast_reg_page_list(r->r.frmr.fr_pgl);
> +			break;
> +		case RPCRDMA_MTHCAFMR:
> +			rc =3D ib_dealloc_fmr(r->r.fmr);
> +			if (rc)
> +				dprintk("RPC:       %s:"
> +					" ib_dealloc_fmr"
> +					" failed %i\n",
> +					__func__, rc);
> +			break;
> +		case RPCRDMA_MEMWINDOWS_ASYNC:
> +		case RPCRDMA_MEMWINDOWS:
> +			rc =3D ib_dealloc_mw(r->r.mw);
> +			if (rc)
> +				dprintk("RPC:       %s:"
> +					" ib_dealloc_mw"
> +					" failed %i\n",
> +					__func__, rc);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> 	kfree(buf->rb_pool);
> }
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
