From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Wed, 2 Nov 2016 17:55:32 +0200
Message-ID: <20161102155532.GI3617@leon.nu>
References: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
 <20161031053318.GU3617@leon.nu>
 <SN1PR07MB2207A02F1883380BE4B1CB06F8A10@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BtQ+uzrQQ7HCCYtg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207A02F1883380BE4B1CB06F8A10-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BtQ+uzrQQ7HCCYtg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 02:42:27PM +0000, Amrani, Ram wrote:
> > While looking on this patch and associated code to it, I noticed the
> > following code stack:
> >
> > qedr_create_qp
> > 	-->
> > 	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
> > 		-->
> > 		qed_rdma_destroy_qp
> > 			-->
> > 			qed_roce_destroy_qp
> > This function will check the QP state and return -EINVAL and comment
> > that this QP needs to be prepared before destroying it.
> >
> > However immediately after returning, you are calling to kfree(qp)
> > without any checks.
> >
> > It looks like an error and it is worth to take a look on it.
> >
>
> That's a deep  level of reading... thanks.

You are welcome.

>
> When the QP is created its state is set in ecore_rdma_create_qp():
> 	qp->cur_state = ECORE_ROCE_QP_STATE_RESET;
>
> When it is ecore_roce_destroy_qp() is invoked, the function *must* be in either RESET or two other states:
> 	if ((qp->cur_state != QED_ROCE_QP_STATE_RESET) &&
> 	    (qp->cur_state != QED_ROCE_QP_STATE_ERR) &&
> 	    (qp->cur_state != QED_ROCE_QP_STATE_INIT)) {
> 		DP_NOTICE(p_hwfn,
> 			  "QP must be in error, reset or init state before destroying it\n");
> 		return -EINVAL;
> 	}
> So actually, we won't return -EINVAL here.
>
> The bug I see is that I see in our upstream code is that for RESET the normal "destroy" operations continue. But they shouldn't.
> We need here something like this:
> 	if (qp->cur_state == ECORE_ROCE_QP_STATE_RESET)
> 		return 0;
>
> Flow will return to qed_rdma_destroy_qp() that will release the qp resource in the qed_roce scope (our real purpose).
> And then return to qedr_create_qp() where the qp resource will be released in the qedr scope.
>
> And as a side issue - an improvement that can be added is to return the error code of the QP create and not of the QP destroy.

I'm happy to hear that it helped.

>
> I'll the first later on and probably the second too.
>
>
>
> > And did I miss the fix to memory leak posted during code review?
> >
> As far as I know, I have supplied patches for all memory leaks. Can you direct me to a specific e-mail?

I failed to find the relevant thread now, so forget it, probably it is
my fault.

>
> Thanks,
> Ram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BtQ+uzrQQ7HCCYtg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGgx0AAoJEORje4g2clin92MP/3IxQ74yo7xGXwkv+P8dxyxK
CqdLItpXEv8k1LU7+su+XWzzz8CB63jymjHW/z44P204s2ZspXbGfvn/E780rsTV
/J2FoZNC/LUOPpP49O7hBYnI5VcH/QrqomGXdLexxKPqUFea6I81u5sjfFfZulQl
tdUFSpsZBW4EmtR3J6PB6/rUrTpuWFn5lXYSIC41hHA/0Ts1Xdnb5i9gi3p+Q25w
WoVblp/TCCuoxe9e0/p76arQgrwETwJXMcQA8ZpDidPFlK9HGeVXLUk7tsbDZAtQ
lFau0Z/Xj1bo2HlU4rIfMN8VfNJST3/AqcDIDw+4jY9hqSuZGM6ioifG0KzFbWaV
lLf8i4s25W4TVc5NPrcRypNkCjqcIJwgASn7L7mZ7KzYd01Phrnw9KfFTDH+4nTh
4nXAAPYG8OQ7QdvLR+J9GO+EGZZk4ecn9xFdcRBCKS0NsWKM+CYf//iux9whPkss
sMhWE6JScrs4rI1bit8xeW4hXXm4taUZKx0RbqKU+R/tgWXifldDXy9A0cU1cHk/
xU8I7R+EDHn+IqOk30xk21InhaBvlycxI29s0lVlBnRc9KpL1Bek3u8YGCkAsSO6
GgNAOpz7Hs3uIQsxBIj/XlotA2FI4IkhkXQsuf2nIrPtHArxITrNNQj2TkInjUjV
CW6T8f5XDz0rjEzINEIx
=Hy1D
-----END PGP SIGNATURE-----

--BtQ+uzrQQ7HCCYtg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
