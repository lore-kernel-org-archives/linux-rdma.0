From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V2] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Thu, 1 Jun 2017 08:11:12 +0000
Message-ID: <BN3PR07MB25781AF1049545F0555D3E83F8F60@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1496303141-14925-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496303141-14925-1-git-send-email-baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The driver may sleep under a spin lock, and the function call path is:
> post_one_send (acquire the lock by spin_lock_irqsave)
>   init_send_wqe
>     copy_from_user --> may sleep
>=20
> To fix it, the lock is released before copy_from_user, and the lock is
> acquired again after this function. The parameter "flags" is used to
> restore and save the irq status.
> Thank Leon for good advice.
>=20

...

>  	init_send_wr(qp, &wqe->wr, ibwr);
> @@ -742,7 +742,12 @@ static int init_send_wqe(struct rxe_qp *qp, struct i=
b_send_wr *ibwr,
>  		for (i =3D 0; i < num_sge; i++, sge++) {
>  			if (qp->is_user && copy_from_user(p, (__user void *)
>  					    (uintptr_t)sge->addr, sge->length))
> -				return -EFAULT;
> +				spin_unlock_irqrestore(&qp->sq.sq_lock, *flags);
> +				err =3D copy_from_user(p, (__user void *)
> +					    (uintptr_t)sge->addr, sge->length);
> +				spin_lock_irqsave(&qp->sq.sq_lock, *flags);
> +				if (qp->is_user && err)
> +					return -EFAULT;
>=20
>  			else if (!qp->is_user)
>  				memcpy(p, (void *)(uintptr_t)sge->addr,

This isn't my area of expertise. Still something seems weird.
You are still calling 'copy_from_user' unprotected in the 'if'.
Also, did you mean to use curly brackets on the indented part after the fir=
st if?!

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
