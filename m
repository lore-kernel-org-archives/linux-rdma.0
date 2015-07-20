From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] core: Remove the ib_reg_phys_mr() and ib_rereg_phys_mr() verbs
Date: Mon, 20 Jul 2015 14:34:08 -0400
Message-ID: <DCAEA434-5734-44FC-B6E7-1C143E1DECA0@redhat.com>
References: <20150714200920.27121.57730.stgit@manet.1015granger.net> <B8226C0A-1706-4A2B-8B83-906C367D366A@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B3F3AE6F-B79E-4124-B4FC-C38F3AAF1431"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B8226C0A-1706-4A2B-8B83-906C367D366A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_B3F3AE6F-B79E-4124-B4FC-C38F3AAF1431
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


> On Jul 20, 2015, at 2:31 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>=20
> Hi Doug-
>=20
> Are you comfortable ack=92ing this one? If so, I can carry it in my
> nfs-rdma-for-4.3 series following the patch that removes the last
> ib_reg_phys_mr() call site.

Yes.

Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>=20
> On Jul 14, 2015, at 4:11 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>=20
>> The verbs are obsolete. The ib_rereg_phys_mr() verb is not used by
>> kernel ULPs, and the last ib_reg_phys_mr() call site in the kernel
>> tree has now been removed.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> I'm still tracking down Doug's e-mail. In the meantime, let's start
>> with this naive approach, which removes the core APIs but does not
>> touch the providers.
>>=20
>>=20
>> drivers/infiniband/core/verbs.c |   67 =
---------------------------------------
>> include/rdma/ib_verbs.h         |   46 ---------------------------
>> 2 files changed, 113 deletions(-)
>>=20
>> diff --git a/drivers/infiniband/core/verbs.c =
b/drivers/infiniband/core/verbs.c
>> index bac3fb4..30eb245 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -1144,73 +1144,6 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, =
int mr_access_flags)
>> }
>> EXPORT_SYMBOL(ib_get_dma_mr);
>>=20
>> -struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
>> -			     struct ib_phys_buf *phys_buf_array,
>> -			     int num_phys_buf,
>> -			     int mr_access_flags,
>> -			     u64 *iova_start)
>> -{
>> -	struct ib_mr *mr;
>> -	int err;
>> -
>> -	err =3D ib_check_mr_access(mr_access_flags);
>> -	if (err)
>> -		return ERR_PTR(err);
>> -
>> -	if (!pd->device->reg_phys_mr)
>> -		return ERR_PTR(-ENOSYS);
>> -
>> -	mr =3D pd->device->reg_phys_mr(pd, phys_buf_array, num_phys_buf,
>> -				     mr_access_flags, iova_start);
>> -
>> -	if (!IS_ERR(mr)) {
>> -		mr->device  =3D pd->device;
>> -		mr->pd      =3D pd;
>> -		mr->uobject =3D NULL;
>> -		atomic_inc(&pd->usecnt);
>> -		atomic_set(&mr->usecnt, 0);
>> -	}
>> -
>> -	return mr;
>> -}
>> -EXPORT_SYMBOL(ib_reg_phys_mr);
>> -
>> -int ib_rereg_phys_mr(struct ib_mr *mr,
>> -		     int mr_rereg_mask,
>> -		     struct ib_pd *pd,
>> -		     struct ib_phys_buf *phys_buf_array,
>> -		     int num_phys_buf,
>> -		     int mr_access_flags,
>> -		     u64 *iova_start)
>> -{
>> -	struct ib_pd *old_pd;
>> -	int ret;
>> -
>> -	ret =3D ib_check_mr_access(mr_access_flags);
>> -	if (ret)
>> -		return ret;
>> -
>> -	if (!mr->device->rereg_phys_mr)
>> -		return -ENOSYS;
>> -
>> -	if (atomic_read(&mr->usecnt))
>> -		return -EBUSY;
>> -
>> -	old_pd =3D mr->pd;
>> -
>> -	ret =3D mr->device->rereg_phys_mr(mr, mr_rereg_mask, pd,
>> -					phys_buf_array, num_phys_buf,
>> -					mr_access_flags, iova_start);
>> -
>> -	if (!ret && (mr_rereg_mask & IB_MR_REREG_PD)) {
>> -		atomic_dec(&old_pd->usecnt);
>> -		atomic_inc(&pd->usecnt);
>> -	}
>> -
>> -	return ret;
>> -}
>> -EXPORT_SYMBOL(ib_rereg_phys_mr);
>> -
>> int ib_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
>> {
>> 	return mr->device->query_mr ?
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 986fddb..6d0f5d0 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -2746,52 +2746,6 @@ static inline void ib_dma_free_coherent(struct =
ib_device *dev,
>> }
>>=20
>> /**
>> - * ib_reg_phys_mr - Prepares a virtually addressed memory region for =
use
>> - *   by an HCA.
>> - * @pd: The protection domain associated assigned to the registered =
region.
>> - * @phys_buf_array: Specifies a list of physical buffers to use in =
the
>> - *   memory region.
>> - * @num_phys_buf: Specifies the size of the phys_buf_array.
>> - * @mr_access_flags: Specifies the memory access rights.
>> - * @iova_start: The offset of the region's starting I/O virtual =
address.
>> - */
>> -struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
>> -			     struct ib_phys_buf *phys_buf_array,
>> -			     int num_phys_buf,
>> -			     int mr_access_flags,
>> -			     u64 *iova_start);
>> -
>> -/**
>> - * ib_rereg_phys_mr - Modifies the attributes of an existing memory =
region.
>> - *   Conceptually, this call performs the functions deregister =
memory region
>> - *   followed by register physical memory region.  Where possible,
>> - *   resources are reused instead of deallocated and reallocated.
>> - * @mr: The memory region to modify.
>> - * @mr_rereg_mask: A bit-mask used to indicate which of the =
following
>> - *   properties of the memory region are being modified.
>> - * @pd: If %IB_MR_REREG_PD is set in mr_rereg_mask, this field =
specifies
>> - *   the new protection domain to associated with the memory region,
>> - *   otherwise, this parameter is ignored.
>> - * @phys_buf_array: If %IB_MR_REREG_TRANS is set in mr_rereg_mask, =
this
>> - *   field specifies a list of physical buffers to use in the new
>> - *   translation, otherwise, this parameter is ignored.
>> - * @num_phys_buf: If %IB_MR_REREG_TRANS is set in mr_rereg_mask, =
this
>> - *   field specifies the size of the phys_buf_array, otherwise, this
>> - *   parameter is ignored.
>> - * @mr_access_flags: If %IB_MR_REREG_ACCESS is set in mr_rereg_mask, =
this
>> - *   field specifies the new memory access rights, otherwise, this
>> - *   parameter is ignored.
>> - * @iova_start: The offset of the region's starting I/O virtual =
address.
>> - */
>> -int ib_rereg_phys_mr(struct ib_mr *mr,
>> -		     int mr_rereg_mask,
>> -		     struct ib_pd *pd,
>> -		     struct ib_phys_buf *phys_buf_array,
>> -		     int num_phys_buf,
>> -		     int mr_access_flags,
>> -		     u64 *iova_start);
>> -
>> -/**
>> * ib_query_mr - Retrieves information about a specific memory region.
>> * @mr: The memory region to retrieve information about.
>> * @mr_attr: The attributes of the specified memory region.
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
>=20
>=20
>=20

=97
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_B3F3AE6F-B79E-4124-B4FC-C38F3AAF1431
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVrT8gAAoJELgmozMOVy/dKCQP/2AOJTUhaGs+46yBHBHRjswB
kjS/m85nCBgnykG7Z4fhlKRv6lgVeHQFYNShNX5Mxq9UaycrYqLimP7/GpLrNPgg
8+RuVVbwHQqhe6zAqEdXqH34tKsgT0s87In6yo2nRocW4YU4DC918xavMJU1Hmxx
1iophU3j56WnAPMHfEAIT0oKjQ0odgVrotwKPYTB+UZd/laKQ0itnsVSKOTV0y7u
DZHfIQralTPKSl1YjNP3YIYdPy1WoLvIWqNkaOzTCP/u6McgHEZMD9j8JXnxx0a+
IOUbsJePMN96BsZiA/n6Fa/uR2LT2KdcsfpVgEM2y44AAhDDgzdDB7a2a/AsJuMJ
WwUfX5CLusJCFruG7NCE690HpwOnEOxwmMMWzSb6kwDMMWUzKtDedn9WxSJzi5Hl
rzzYAsHuhnrHmNqF3PdHaD0SeUjYCBv80d4OITw8FcV+vd7lDliFsGH5GITBOpBC
yBt8yAHyhPztanMXtToeiw4U/XR1nVBzwcobcka8H0lAbcY1QaeLUjYIM7Ckojl8
P6qKLDrW9+ol12CxnrxaizE2ITYS9KT7gKbKULsFmNeIB2fYwGtHxktdCjC9uIkv
68mYAMv/9lxqmvAaSyuuMOOf5Ea+G8gO9lkh6gqItbOcdJL+59FCzJsKOvsqTUhp
suGtkn5GOCS3IKj7cU+w
=G65K
-----END PGP SIGNATURE-----

--Apple-Mail=_B3F3AE6F-B79E-4124-B4FC-C38F3AAF1431--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
