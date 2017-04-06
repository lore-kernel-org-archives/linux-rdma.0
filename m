From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Thu, 6 Apr 2017 17:13:52 +0300
Message-ID: <CAAKD3BCy_JD1cu=3ZHSbrXBHmeTj-M7pJ6nM=rRXFVMi6Szvwg@mail.gmail.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-5-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB10FAD8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB10FAD8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 6, 2017 at 12:05 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Mostly questions.
>
>> @@ -1628,7 +1148,7 @@ ssize_t ib_uverbs_resize_cq(struct
>> ib_uverbs_file *file,
>>                  (unsigned long) cmd.response + sizeof resp,
>>                  in_len - sizeof cmd, out_len - sizeof resp);
>>
>> -     cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
>> +     cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
>
> (I noticed rereg_mr used a write lock.)
> Is a read lock sufficient here?
>

I guess we don't want to allow two concurrent resize_cq, so write lock should be
better here. However, I don't want to change logic in these patches. I
think such
a patch is better of being separate with a proper commit message.
We don't step on these bugs, as there's no lock at the verbs layer. So
usually, device
drivers provide the locking their themselves.

>>       if (!cq)
>>               return -EINVAL;
>>
>
>> @@ -2399,7 +1896,7 @@ static int modify_qp(struct ib_uverbs_file
>> *file,
>>       if (!attr)
>>               return -ENOMEM;
>>
>> -     qp = idr_read_qp(cmd->base.qp_handle, file->ucontext);
>> +     qp = uobj_get_obj_read(qp, cmd->base.qp_handle, file->ucontext);
>
> And here? (another below)
>

It's similar to the previous case, but a little bit more complicated.
It's valid to carry
two concurrent modify_qp if they change different attributes from the
same state to the
same state. However, this seems to me like a very esoteric case, so
write lock should be
better here.

>>       if (!qp) {
>>               ret = -EINVAL;
>>               goto out;
>> @@ -2471,7 +1968,7 @@ static int modify_qp(struct ib_uverbs_file
>> *file,
>>       }
>>
>>  release_qp:
>> -     put_qp_read(qp);
>> +     uobj_put_obj_read(qp);
>>
>>  out:
>>       kfree(attr);
>> @@ -2558,42 +2055,27 @@ ssize_t ib_uverbs_destroy_qp(struct
>> ib_uverbs_file *file,
>>
>>       memset(&resp, 0, sizeof resp);
>>
>> -     uobj = idr_write_uobj(cmd.qp_handle, file->ucontext);
>> -     if (!uobj)
>> -             return -EINVAL;
>> +     uobj  = uobj_get_write(uobj_get_type(qp), cmd.qp_handle,
>> +                            file->ucontext);
>> +     if (IS_ERR(uobj))
>> +             return PTR_ERR(uobj);
>> +
>>       qp  = uobj->object;
>>       obj = container_of(uobj, struct ib_uqp_object, uevent.uobject);
>> +     /*
>> +      * Make sure we don't free the memory in remove_commit as we
>> still
>> +      * needs the uobject memory to create the response.
>> +      */
>> +     uverbs_uobject_get(uobj);
>
> As an alternative, you could pass a parameter into the destroy calls, which could carry the information needed to write out the results.  (There are 3-4 other places with a similar structure.)
>

Yeah, that's another option. We could get s __user pointer to the free
functions and in case the destruction was requested by the user, it'll
write the required information.
I think that logically, writing responses should be part of the
handler's code. If we look a little bit further, these free functions
will be called from the ioctl code as well.
The ioctl responses could be formed a little bit differently and I
don't want to pass information about the response structure to the
free functions.

>>
>> -     if (!list_empty(&obj->mcast_list)) {
>> -             put_uobj_write(uobj);
>> -             return -EBUSY;
>> -     }
>> -
>> -     ret = ib_destroy_qp(qp);
>> -     if (!ret)
>> -             uobj->live = 0;
>> -
>> -     put_uobj_write(uobj);
>> -
>> -     if (ret)
>> +     ret = uobj_remove_commit(uobj);
>> +     if (ret) {
>> +             uverbs_uobject_put(uobj);
>>               return ret;
>> -
>> -     ib_rdmacg_uncharge(&uobj->cg_obj, ib_dev,
>> RDMACG_RESOURCE_HCA_OBJECT);
>> -
>> -     if (obj->uxrcd)
>> -             atomic_dec(&obj->uxrcd->refcnt);
>> -
>> -     idr_remove_uobj(uobj);
>> -
>> -     mutex_lock(&file->mutex);
>> -     list_del(&uobj->list);
>> -     mutex_unlock(&file->mutex);
>> -
>> -     ib_uverbs_release_uevent(file, &obj->uevent);
>> +     }
>>
>>       resp.events_reported = obj->uevent.events_reported;
>> -
>> -     put_uobj(uobj);
>> +     uverbs_uobject_put(uobj);
>>
>>       if (copy_to_user((void __user *) (unsigned long) cmd.response,
>>                        &resp, sizeof resp))
>
>> @@ -3142,7 +2583,7 @@ ssize_t ib_uverbs_attach_mcast(struct
>> ib_uverbs_file *file,
>>       if (copy_from_user(&cmd, buf, sizeof cmd))
>>               return -EFAULT;
>>
>> -     qp = idr_write_qp(cmd.qp_handle, file->ucontext);
>> +     qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
>
> This converts an idr_write to get_obj_read...
>

This is solved in the next commit as we add another lock here. I don't want to
return -EBUSY to the user-space if two concurrent mcast_attach (or detach) are
called.

>>       if (!qp)
>>               return -EINVAL;
>>
>> @@ -3171,7 +2612,7 @@ ssize_t ib_uverbs_attach_mcast(struct
>> ib_uverbs_file *file,
>>               kfree(mcast);
>>
>>  out_put:
>> -     put_qp_write(qp);
>> +     uobj_put_obj_read(qp);
>>
>>       return ret ? ret : in_len;
>>  }
>> @@ -3190,16 +2631,16 @@ ssize_t ib_uverbs_detach_mcast(struct
>> ib_uverbs_file *file,
>>       if (copy_from_user(&cmd, buf, sizeof cmd))
>>               return -EFAULT;
>>
>> -     qp = idr_write_qp(cmd.qp_handle, file->ucontext);
>> +     qp = uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
>
> Same here.  Are these changes correct?
>

Yeah, lock is added at the next patch.

>>       if (!qp)
>>               return -EINVAL;
>>
>> +     obj = container_of(qp->uobject, struct ib_uqp_object,
>> uevent.uobject);
>> +
>>       ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
>>       if (ret)
>>               goto out_put;
>>
>> -     obj = container_of(qp->uobject, struct ib_uqp_object,
>> uevent.uobject);
>> -
>>       list_for_each_entry(mcast, &obj->mcast_list, list)
>>               if (cmd.mlid == mcast->lid &&
>>                   !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast-
>> >gid.raw)) {
>> @@ -3209,8 +2650,7 @@ ssize_t ib_uverbs_detach_mcast(struct
>> ib_uverbs_file *file,
>>               }
>>
>>  out_put:
>> -     put_qp_write(qp);
>> -
>> +     uobj_put_obj_read(qp);
>>       return ret ? ret : in_len;
>>  }
>
>> @@ -3526,31 +2953,27 @@ int ib_uverbs_ex_destroy_wq(struct
>> ib_uverbs_file *file,
>>               return -EOPNOTSUPP;
>>
>>       resp.response_length = required_resp_len;
>> -     uobj = idr_write_uobj(cmd.wq_handle,
>> -                           file->ucontext);
>> -     if (!uobj)
>> -             return -EINVAL;
>> +     uobj  = uobj_get_write(uobj_get_type(wq), cmd.wq_handle,
>> +                            file->ucontext);
>> +     if (IS_ERR(uobj))
>> +             return PTR_ERR(uobj);
>>
>>       wq = uobj->object;
>>       obj = container_of(uobj, struct ib_uwq_object, uevent.uobject);
>> -     ret = ib_destroy_wq(wq);
>> -     if (!ret)
>> -             uobj->live = 0;
>> +     /*
>> +      * Make sure we don't free the memory in remove_commit as we
>> still
>> +      * needs the uobject memory to create the response.
>> +      */
>> +     uverbs_uobject_get(uobj);
>>
>> -     put_uobj_write(uobj);
>> -     if (ret)
>> +     ret = uobj_remove_commit(uobj);
>> +     if (ret) {
>> +             uverbs_uobject_put(uobj);
>>               return ret;
>> +     }
>>
>> -     idr_remove_uobj(uobj);
>> -
>> -     mutex_lock(&file->mutex);
>> -     list_del(&uobj->list);
>> -     mutex_unlock(&file->mutex);
>> -
>> -     ib_uverbs_release_uevent(file, &obj->uevent);
>>       resp.events_reported = obj->uevent.events_reported;
>> -     put_uobj(uobj);
>> -
>> +     uverbs_uobject_put(uobj);
>
> Nit: This call can move above the if (ret) check above, with the duplicate call removed.
>

Sure, I'll do that.

>>       ret = ib_copy_to_udata(ucore, &resp, resp.response_length);
>>       if (ret)
>>               return ret;
>> @@ -3588,7 +3011,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file
>> *file,
>>       if (cmd.attr_mask > (IB_WQ_STATE | IB_WQ_CUR_STATE |
>> IB_WQ_FLAGS))
>>               return -EINVAL;
>>
>> -     wq = idr_read_wq(cmd.wq_handle, file->ucontext);
>> +     wq = uobj_get_obj_read(wq, cmd.wq_handle, file->ucontext);
>>       if (!wq)
>>               return -EINVAL;
>>
>
>> @@ -4254,7 +3591,7 @@ ssize_t ib_uverbs_modify_srq(struct
>> ib_uverbs_file *file,
>>       INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
>>                  out_len);
>>
>> -     srq = idr_read_srq(cmd.srq_handle, file->ucontext);
>> +     srq = uobj_get_obj_read(srq, cmd.srq_handle, file->ucontext);
>
> Use write lock here?
>

As of the other verbs you mentioned (modify_qp, resize_cq), this makes sense
but I don't want to change the logic in this refactor patch. Like
modify_qp, there's
an esoteric case where changing IB_SRQ_MAX_WR and IB_SRQ_LIMIT in two
concurrent call is currently allowed and makes sense semantically.

>>       if (!srq)
>>               return -EINVAL;
>>
>> @@ -4263,7 +3600,7 @@ ssize_t ib_uverbs_modify_srq(struct
>> ib_uverbs_file *file,
>>
>>       ret = srq->device->modify_srq(srq, &attr, cmd.attr_mask,
>> &udata);
>>
>> -     put_srq_read(srq);
>> +     uobj_put_obj_read(srq);
>>
>>       return ret ? ret : in_len;
>>  }
>
> - Sean

Thanks reviewing this code.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
