From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 15/15] core: Remove the ib_reg_phys_mr() and
 ib_rereg_phys_mr() verbs
Date: Tue, 21 Jul 2015 16:18:46 -0400
Message-ID: <55AEA926.5070200@Netapp.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190446.10997.83633.stgit@manet.1015granger.net>
 <55AEA6A4.8020204@Netapp.com>
 <D4DD6D9E-1660-4424-9A2A-54AE85368A7A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D4DD6D9E-1660-4424-9A2A-54AE85368A7A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/21/2015 04:16 PM, Chuck Lever wrote:
> Hi Anna-
>=20
>=20
> On Jul 21, 2015, at 4:08 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgRhl2p70BpVqQ@public.gmane.org=
m> wrote:
>=20
>> Hey Chuck,
>>
>> Just a heads up that this patch should go through the infiniband tre=
e, and not NFS :).
>=20
> The IB maintainer has ACK=E2=80=99d it, so it can go through NFS. It =
depends
> on changes in an earlier patch in this series.

=46air enough!  I didn't realize Doug was the IB maintainer.

Anna
>=20
>=20
>> Thanks,
>> Anna
>>
>> On 07/20/2015 03:04 PM, Chuck Lever wrote:
>>> The verbs are obsolete. The ib_rereg_phys_mr() verb is not used by
>>> kernel ULPs, and the last ib_reg_phys_mr() call site in the kernel
>>> tree has now been removed.
>>>
>>> Two staging tree call sites remain in the Lustre client. The Lustre
>>> team has been notified of the deprecation of reg_phys_mr.
>>>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> drivers/infiniband/core/verbs.c |   67 ----------------------------=
-----------
>>> include/rdma/ib_verbs.h         |   46 ---------------------------
>>> 2 files changed, 113 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/c=
ore/verbs.c
>>> index bac3fb4..30eb245 100644
>>> --- a/drivers/infiniband/core/verbs.c
>>> +++ b/drivers/infiniband/core/verbs.c
>>> @@ -1144,73 +1144,6 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd=
, int mr_access_flags)
>>> }
>>> EXPORT_SYMBOL(ib_get_dma_mr);
>>>
>>> -struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
>>> -			     struct ib_phys_buf *phys_buf_array,
>>> -			     int num_phys_buf,
>>> -			     int mr_access_flags,
>>> -			     u64 *iova_start)
>>> -{
>>> -	struct ib_mr *mr;
>>> -	int err;
>>> -
>>> -	err =3D ib_check_mr_access(mr_access_flags);
>>> -	if (err)
>>> -		return ERR_PTR(err);
>>> -
>>> -	if (!pd->device->reg_phys_mr)
>>> -		return ERR_PTR(-ENOSYS);
>>> -
>>> -	mr =3D pd->device->reg_phys_mr(pd, phys_buf_array, num_phys_buf,
>>> -				     mr_access_flags, iova_start);
>>> -
>>> -	if (!IS_ERR(mr)) {
>>> -		mr->device  =3D pd->device;
>>> -		mr->pd      =3D pd;
>>> -		mr->uobject =3D NULL;
>>> -		atomic_inc(&pd->usecnt);
>>> -		atomic_set(&mr->usecnt, 0);
>>> -	}
>>> -
>>> -	return mr;
>>> -}
>>> -EXPORT_SYMBOL(ib_reg_phys_mr);
>>> -
>>> -int ib_rereg_phys_mr(struct ib_mr *mr,
>>> -		     int mr_rereg_mask,
>>> -		     struct ib_pd *pd,
>>> -		     struct ib_phys_buf *phys_buf_array,
>>> -		     int num_phys_buf,
>>> -		     int mr_access_flags,
>>> -		     u64 *iova_start)
>>> -{
>>> -	struct ib_pd *old_pd;
>>> -	int ret;
>>> -
>>> -	ret =3D ib_check_mr_access(mr_access_flags);
>>> -	if (ret)
>>> -		return ret;
>>> -
>>> -	if (!mr->device->rereg_phys_mr)
>>> -		return -ENOSYS;
>>> -
>>> -	if (atomic_read(&mr->usecnt))
>>> -		return -EBUSY;
>>> -
>>> -	old_pd =3D mr->pd;
>>> -
>>> -	ret =3D mr->device->rereg_phys_mr(mr, mr_rereg_mask, pd,
>>> -					phys_buf_array, num_phys_buf,
>>> -					mr_access_flags, iova_start);
>>> -
>>> -	if (!ret && (mr_rereg_mask & IB_MR_REREG_PD)) {
>>> -		atomic_dec(&old_pd->usecnt);
>>> -		atomic_inc(&pd->usecnt);
>>> -	}
>>> -
>>> -	return ret;
>>> -}
>>> -EXPORT_SYMBOL(ib_rereg_phys_mr);
>>> -
>>> int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
>>> {
>>> 	return mr->device->query_mr ?
>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>> index b0f898e..43c1cf0 100644
>>> --- a/include/rdma/ib_verbs.h
>>> +++ b/include/rdma/ib_verbs.h
>>> @@ -2760,52 +2760,6 @@ static inline void ib_dma_free_coherent(stru=
ct ib_device *dev,
>>> }
>>>
>>> /**
>>> - * ib_reg_phys_mr - Prepares a virtually addressed memory region f=
or use
>>> - *   by an HCA.
>>> - * @pd: The protection domain associated assigned to the registere=
d region.
>>> - * @phys_buf_array: Specifies a list of physical buffers to use in=
 the
>>> - *   memory region.
>>> - * @num_phys_buf: Specifies the size of the phys_buf_array.
>>> - * @mr_access_flags: Specifies the memory access rights.
>>> - * @iova_start: The offset of the region's starting I/O virtual ad=
dress.
>>> - */
>>> -struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
>>> -			     struct ib_phys_buf *phys_buf_array,
>>> -			     int num_phys_buf,
>>> -			     int mr_access_flags,
>>> -			     u64 *iova_start);
>>> -
>>> -/**
>>> - * ib_rereg_phys_mr - Modifies the attributes of an existing memor=
y region.
>>> - *   Conceptually, this call performs the functions deregister mem=
ory region
>>> - *   followed by register physical memory region.  Where possible,
>>> - *   resources are reused instead of deallocated and reallocated.
>>> - * @mr: The memory region to modify.
>>> - * @mr_rereg_mask: A bit-mask used to indicate which of the follow=
ing
>>> - *   properties of the memory region are being modified.
>>> - * @pd: If %IB_MR_REREG_PD is set in mr_rereg_mask, this field spe=
cifies
>>> - *   the new protection domain to associated with the memory regio=
n,
>>> - *   otherwise, this parameter is ignored.
>>> - * @phys_buf_array: If %IB_MR_REREG_TRANS is set in mr_rereg_mask,=
 this
>>> - *   field specifies a list of physical buffers to use in the new
>>> - *   translation, otherwise, this parameter is ignored.
>>> - * @num_phys_buf: If %IB_MR_REREG_TRANS is set in mr_rereg_mask, t=
his
>>> - *   field specifies the size of the phys_buf_array, otherwise, th=
is
>>> - *   parameter is ignored.
>>> - * @mr_access_flags: If %IB_MR_REREG_ACCESS is set in mr_rereg_mas=
k, this
>>> - *   field specifies the new memory access rights, otherwise, this
>>> - *   parameter is ignored.
>>> - * @iova_start: The offset of the region's starting I/O virtual ad=
dress.
>>> - */
>>> -int ib_rereg_phys_mr(struct ib_mr *mr,
>>> -		     int mr_rereg_mask,
>>> -		     struct ib_pd *pd,
>>> -		     struct ib_phys_buf *phys_buf_array,
>>> -		     int num_phys_buf,
>>> -		     int mr_access_flags,
>>> -		     u64 *iova_start);
>>> -
>>> -/**
>>>  * ib_query_mr - Retrieves information about a specific memory regi=
on.
>>>  * @mr: The memory region to retrieve information about.
>>>  * @mr_attr: The attributes of the specified memory region.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nfs=
" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
