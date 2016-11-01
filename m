From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Tue, 1 Nov 2016 14:42:27 +0000
Message-ID: <SN1PR07MB2207A02F1883380BE4B1CB06F8A10@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
 <20161031053318.GU3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161031053318.GU3617-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> While looking on this patch and associated code to it, I noticed the=20
> following code stack:
>=20
> qedr_create_qp
> 	-->
> 	dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
> 		-->
> 		qed_rdma_destroy_qp
> 			-->
> 			qed_roce_destroy_qp
> This function will check the QP state and return -INVAL and comment=20
> that this QP needs to be prepared before destroying it.
>=20
> However immediately after returning, you are calling to kfree(qp)=20
> without any checks.
>=20
> It looks like an error and it is worth to take a look on it.
>

That's a deep  level of reading... thanks.

When the QP is created its state is set in ecore_rdma_create_qp():
	qp->cur_state =3D ECORE_ROCE_QP_STATE_RESET;

When it is ecore_roce_destroy_qp() is invoked, the function *must* be in ei=
ther RESET or two other states:
	if ((qp->cur_state !=3D QED_ROCE_QP_STATE_RESET) &&
	    (qp->cur_state !=3D QED_ROCE_QP_STATE_ERR) &&
	    (qp->cur_state !=3D QED_ROCE_QP_STATE_INIT)) {
		DP_NOTICE(p_hwfn,
			  "QP must be in error, reset or init state before destroying it\n");
		return -EINVAL;
	}
So actually, we won't return -INVAL here.

The bug I see is that I see in our upstream code is that for RESET the norm=
al "destroy" operations continue. But they shouldn't.
We need here something like this:
	if (qp->cur_state =3D=3D ECORE_ROCE_QP_STATE_RESET)
		return 0;

Flow will return to qed_rdma_destroy_qp() that will release the qp resource=
 in the qed_roce scope (our real purpose).
And then return to qedr_create_qp() where the qp resource will be released =
in the qedr scope.

And as a side issue - an improvement that can be added is to return the err=
or code of the QP create and not of the QP destroy.

I'll the first later on and probably the second too.



> And did I miss the fix to memory leak posted during code review?
>=20
As far as I know, I have supplied patches for all memory leaks. Can you dir=
ect me to a specific e-mail?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
