From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Wed, 5 Apr 2017 21:05:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB10FAD8@ORSMSX109.amr.corp.intel.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491301907-32290-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mostly questions.

> @@ -1628,7 +1148,7 @@ ssize_t ib_uverbs_resize_cq(struct
> ib_uverbs_file *file,
>  		   (unsigned long) cmd.response + sizeof resp,
>  		   in_len - sizeof cmd, out_len - sizeof resp);
>=20
> -	cq =3D idr_read_cq(cmd.cq_handle, file->ucontext, 0);
> +	cq =3D uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);

(I noticed rereg_mr used a write lock.)
Is a read lock sufficient here?

>  	if (!cq)
>  		return -EINVAL;
>=20

> @@ -2399,7 +1896,7 @@ static int modify_qp(struct ib_uverbs_file
> *file,
>  	if (!attr)
>  		return -ENOMEM;
>=20
> -	qp =3D idr_read_qp(cmd->base.qp_handle, file->ucontext);
> +	qp =3D uobj_get_obj_read(qp, cmd->base.qp_handle, file->ucontext);

And here? (another below)

>  	if (!qp) {
>  		ret =3D -EINVAL;
>  		goto out;
> @@ -2471,7 +1968,7 @@ static int modify_qp(struct ib_uverbs_file
> *file,
>  	}
>=20
>  release_qp:
> -	put_qp_read(qp);
> +	uobj_put_obj_read(qp);
>=20
>  out:
>  	kfree(attr);
> @@ -2558,42 +2055,27 @@ ssize_t ib_uverbs_destroy_qp(struct
> ib_uverbs_file *file,
>=20
>  	memset(&resp, 0, sizeof resp);
>=20
> -	uobj =3D idr_write_uobj(cmd.qp_handle, file->ucontext);
> -	if (!uobj)
> -		return -EINVAL;
> +	uobj  =3D uobj_get_write(uobj_get_type(qp), cmd.qp_handle,
> +			       file->ucontext);
> +	if (IS_ERR(uobj))
> +		return PTR_ERR(uobj);
> +
>  	qp  =3D uobj->object;
>  	obj =3D container_of(uobj, struct ib_uqp_object, uevent.uobject);
> +	/*
> +	 * Make sure we don't free the memory in remove_commit as we
> still
> +	 * needs the uobject memory to create the response.
> +	 */
> +	uverbs_uobject_get(uobj);

As an alternative, you could pass a parameter into the destroy calls, which=
 could carry the information needed to write out the results.  (There are 3=
-4 other places with a similar structure.)

>=20
> -	if (!list_empty(&obj->mcast_list)) {
> -		put_uobj_write(uobj);
> -		return -EBUSY;
> -	}
> -
> -	ret =3D ib_destroy_qp(qp);
> -	if (!ret)
> -		uobj->live =3D 0;
> -
> -	put_uobj_write(uobj);
> -
> -	if (ret)
> +	ret =3D uobj_remove_commit(uobj);
> +	if (ret) {
> +		uverbs_uobject_put(uobj);
>  		return ret;
> -
> -	ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
> RDMACG_RESOURCE_HCA_OBJECT);
> -
> -	if (obj->uxrcd)
> -		atomic_dec(&obj->uxrcd->refcnt);
> -
> -	idr_remove_uobj(uobj);
> -
> -	mutex_lock(&file->mutex);
> -	list_del(&uobj->list);
> -	mutex_unlock(&file->mutex);
> -
> -	ib_uverbs_release_uevent(file, &obj->uevent);
> +	}
>=20
>  	resp.events_reported =3D obj->uevent.events_reported;
> -
> -	put_uobj(uobj);
> +	uverbs_uobject_put(uobj);
>=20
>  	if (copy_to_user((void __user *) (unsigned long) cmd.response,
>  			 &resp, sizeof resp))

> @@ -3142,7 +2583,7 @@ ssize_t ib_uverbs_attach_mcast(struct
> ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>=20
> -	qp =3D idr_write_qp(cmd.qp_handle, file->ucontext);
> +	qp =3D uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);

This converts an idr_write to get_obj_read...

>  	if (!qp)
>  		return -EINVAL;
>=20
> @@ -3171,7 +2612,7 @@ ssize_t ib_uverbs_attach_mcast(struct
> ib_uverbs_file *file,
>  		kfree(mcast);
>=20
>  out_put:
> -	put_qp_write(qp);
> +	uobj_put_obj_read(qp);
>=20
>  	return ret ? ret : in_len;
>  }
> @@ -3190,16 +2631,16 @@ ssize_t ib_uverbs_detach_mcast(struct
> ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>=20
> -	qp =3D idr_write_qp(cmd.qp_handle, file->ucontext);
> +	qp =3D uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);

Same here.  Are these changes correct?

>  	if (!qp)
>  		return -EINVAL;
>=20
> +	obj =3D container_of(qp->uobject, struct ib_uqp_object,
> uevent.uobject);
> +
>  	ret =3D ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
>  	if (ret)
>  		goto out_put;
>=20
> -	obj =3D container_of(qp->uobject, struct ib_uqp_object,
> uevent.uobject);
> -
>  	list_for_each_entry(mcast, &obj->mcast_list, list)
>  		if (cmd.mlid =3D=3D mcast->lid &&
>  		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast-
> >gid.raw)) {
> @@ -3209,8 +2650,7 @@ ssize_t ib_uverbs_detach_mcast(struct
> ib_uverbs_file *file,
>  		}
>=20
>  out_put:
> -	put_qp_write(qp);
> -
> +	uobj_put_obj_read(qp);
>  	return ret ? ret : in_len;
>  }

> @@ -3526,31 +2953,27 @@ int ib_uverbs_ex_destroy_wq(struct
> ib_uverbs_file *file,
>  		return -EOPNOTSUPP;
>=20
>  	resp.response_length =3D required_resp_len;
> -	uobj =3D idr_write_uobj(cmd.wq_handle,
> -			      file->ucontext);
> -	if (!uobj)
> -		return -EINVAL;
> +	uobj  =3D uobj_get_write(uobj_get_type(wq), cmd.wq_handle,
> +			       file->ucontext);
> +	if (IS_ERR(uobj))
> +		return PTR_ERR(uobj);
>=20
>  	wq =3D uobj->object;
>  	obj =3D container_of(uobj, struct ib_uwq_object, uevent.uobject);
> -	ret =3D ib_destroy_wq(wq);
> -	if (!ret)
> -		uobj->live =3D 0;
> +	/*
> +	 * Make sure we don't free the memory in remove_commit as we
> still
> +	 * needs the uobject memory to create the response.
> +	 */
> +	uverbs_uobject_get(uobj);
>=20
> -	put_uobj_write(uobj);
> -	if (ret)
> +	ret =3D uobj_remove_commit(uobj);
> +	if (ret) {
> +		uverbs_uobject_put(uobj);
>  		return ret;
> +	}
>=20
> -	idr_remove_uobj(uobj);
> -
> -	mutex_lock(&file->mutex);
> -	list_del(&uobj->list);
> -	mutex_unlock(&file->mutex);
> -
> -	ib_uverbs_release_uevent(file, &obj->uevent);
>  	resp.events_reported =3D obj->uevent.events_reported;
> -	put_uobj(uobj);
> -
> +	uverbs_uobject_put(uobj);

Nit: This call can move above the if (ret) check above, with the duplicate =
call removed.

>  	ret =3D ib_copy_to_udata(ucore, &resp, resp.response_length);
>  	if (ret)
>  		return ret;
> @@ -3588,7 +3011,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file
> *file,
>  	if (cmd.attr_mask > (IB_WQ_STATE | IB_WQ_CUR_STATE |
> IB_WQ_FLAGS))
>  		return -EINVAL;
>=20
> -	wq =3D idr_read_wq(cmd.wq_handle, file->ucontext);
> +	wq =3D uobj_get_obj_read(wq, cmd.wq_handle, file->ucontext);
>  	if (!wq)
>  		return -EINVAL;
>=20

> @@ -4254,7 +3591,7 @@ ssize_t ib_uverbs_modify_srq(struct
> ib_uverbs_file *file,
>  	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
>  		   out_len);
>=20
> -	srq =3D idr_read_srq(cmd.srq_handle, file->ucontext);
> +	srq =3D uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);

Use write lock here?

>  	if (!srq)
>  		return -EINVAL;
>=20
> @@ -4263,7 +3600,7 @@ ssize_t ib_uverbs_modify_srq(struct
> ib_uverbs_file *file,
>=20
>  	ret =3D srq->device->modify_srq(srq, &attr, cmd.attr_mask,
> &udata);
>=20
> -	put_srq_read(srq);
> +	uobj_put_obj_read(srq);
>=20
>  	return ret ? ret : in_len;
>  }

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
