From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 for-next 3/7] IB/core: Add idr based standard types
Date: Thu, 6 Apr 2017 17:14:35 +0300
Message-ID: <CAAKD3BDSZwzAKvucPxC+i6gnXVGUpi0LYgCX0GMhw_4uR0PZaw@mail.gmail.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-4-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB10F97B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB10F97B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 5, 2017 at 8:05 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_cq =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object),
>> 0),
>> +     .destroy_object =3D uverbs_free_cq,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_qp =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object),
>> 0),
>> +     .destroy_object =3D uverbs_free_qp,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_mw =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(0),
>> +     .destroy_object =3D uverbs_free_mw,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_mr =3D {
>> +     /* 1 is used in order to free the MR after all the MWs */
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(1),
>> +     .destroy_object =3D uverbs_free_mr,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_srq =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object),
>> 0),
>> +     .destroy_object =3D uverbs_free_srq,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_ah =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(0),
>> +     .destroy_object =3D uverbs_free_ah,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_flow =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(0),
>> +     .destroy_object =3D uverbs_free_flow,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_wq =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object),
>> 0),
>> +     .destroy_object =3D uverbs_free_wq,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(0),
>> +     .destroy_object =3D uverbs_free_rwq_ind_tbl,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd =3D {
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object),
>> 0),
>> +     .destroy_object =3D uverbs_free_xrcd,
>> +};
>> +
>> +const struct uverbs_obj_idr_type uverbs_type_attrs_pd =3D {
>> +     /* 2 is used in order to free the PD after MRs */
>> +     .type =3D UVERBS_TYPE_ALLOC_IDR(2),
>> +     .destroy_object =3D uverbs_free_pd,
>> +};
>
> I wonder if it wouldn't make more sense to have destroy order be independ=
ent from object creation assumptions.  For example, QPs must be destroyed p=
rior to their associated CQs.  This code works, since the CQ is passed in d=
uring QP creation and ends up on the list correctly, but I wonder if all ha=
rdware would actually need that restriction.  Basically, the destroy order =
value as used is not actually capturing the true destroy order; there are o=
ther assumptions baked into the code.
>

Actually, this code gives you the freedom to do both. You could have
every type in its own "order group" or you could share these groups.
It's guaranteed that all objects in "order group" x will be destroyed
after
objects in "order group" x+1.
The rational here is to destroy objects in a LIFO order in every order
group. That should fit most objects pretty well. It's obvious that if
a QP reports to a CQ, you can't destroy this CQ before destroying the
QP.
This is the case now, when creating object x which depends on object
y, we increase the ref count of object y. Object y will only be
destroyed when its reference count is zero.
So, effectively, we capture the same logic here.
The only exception is objects which their dependency is either
set/breaks in the user-space/hardware (without kernel awareness). In
these cases we need to fall back to destroy objects by their type
class order (a
good example could be MWs and MRs).

> Otherwise:
>
> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks :)

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
