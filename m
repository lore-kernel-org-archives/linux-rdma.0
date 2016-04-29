From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA READ
Date: Thu, 28 Apr 2016 22:35:26 -0400
Message-ID: <5722C86E.2050207@redhat.com>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1461352469-16504-6-git-send-email-tatyana.e.nikolova@intel.com>
 <20160424073510.GC7974@leon.nu>
 <13AA599688F47243B14FCFCCC2C803BB10978BE8@fmsmsx104.amr.corp.intel.com>
 <20160427062535.GL7974@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rS1OKkvW2a3DRalFGCsnu96UbFcs4Ldlv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160427062535.GL7974-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rS1OKkvW2a3DRalFGCsnu96UbFcs4Ldlv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/27/2016 02:25 AM, Leon Romanovsky wrote:
> On Tue, Apr 26, 2016 at 03:27:46PM +0000, Nikolova, Tatyana E wrote:
>> Hi Leon,
>>
>> We support multiple sges for RDMA WRITE. In the patch, the fall-throug=
h case above RDMA READ is RDMA READ WITH INVALIDATE.
>=20
> I believe that we are looking on the different trees.
> In official tree, the case above RDMA_READ is RDMA_WRITE.

Theses patches presumably are on top of the 16 previous patches to the
i40iw driver.

>>
>> Thanks,
>> Tatyana
>>
>> -----Original Message-----
>> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]=20
>> Sent: Sunday, April 24, 2016 2:35 AM
>> To: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma@lists.=
sourceforge.net; Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Subject: Re: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA RE=
AD
>>
>> On Fri, Apr 22, 2016 at 02:14:27PM -0500, Tatyana Nikolova wrote:
>>> From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> A check is added to validate the requested sge number.
>>> iWARP doesn't support multiple sg elements for RDMA READ work=20
>>> requests.
>>>
>>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c=20
>>> b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>>> index 2d832c7..45f70f5 100644
>>> --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
>>> @@ -74,7 +74,7 @@ static int i40iw_query_device(struct ib_device *ibd=
ev,
>>>  	props->max_cqe =3D iwdev->max_cqe;
>>>  	props->max_mr =3D iwdev->max_mr;
>>>  	props->max_pd =3D iwdev->max_pd;
>>> -	props->max_sge_rd =3D 1;
>>> +	props->max_sge_rd =3D I40IW_MAX_SGE_RD;
>>>  	props->max_qp_rd_atom =3D I40IW_MAX_IRD_SIZE;
>>>  	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
>>>  	props->atomic_cap =3D IB_ATOMIC_NONE;
>>> @@ -2117,6 +2117,10 @@ static int i40iw_post_send(struct ib_qp *ibqp,=

>>>  			inv_stag =3D true;
>>>  			/* fall-through*/
>>                         ^^^^^^^^^^^^^^^^ Do you support multiple SGE f=
or RDMA WRITE?
>>
>>
>>>  		case IB_WR_RDMA_READ:
>>> +			if (ib_wr->num_sge > I40IW_MAX_SGE_RD) {
>>> +				err =3D -EINVAL;
>>> +				break;
>>> +			}
>>>  			info.op_type =3D I40IW_OP_TYPE_RDMA_READ;
>>>  			info.op.rdma_read.rem_addr.tag_off =3D rdma_wr(ib_wr)->remote_add=
r;
>>>  			info.op.rdma_read.rem_addr.stag =3D rdma_wr(ib_wr)->rkey;
>>> --
>>> 2.7.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
=20
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo =

>>> info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rS1OKkvW2a3DRalFGCsnu96UbFcs4Ldlv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIshuAAoJELgmozMOVy/dKGIQAL3Q8OvS7ZeQ3buATi5Q5MKM
du6G7ouTm1fao3nTcRHSrOb5CIrdgrWkM3uAVAv/fYyRPpsjAoeMTkTf5xJOqR+k
epV9l8HiZVnHSxnsRGg4ObgWCojcCde3f0zvVJQkyh1/Oc4Z8Zm8vVaB6ZYMis2p
jOKLvQ3wkcKTXQFz5MqhWgC3G1mIx6kTyUjUJY9RZ1PTUncw0UJ++pgE4WJ8TJhk
+9jEwgpRezGhpFPtG0aeSPYuz6EIxcYKPNgWG4RtKOksfpQWQFUPw/90BGRu9jFi
QyK7pRVEimEYsGepEz4csCuJ+ev0f+PoGBYO+NbwENJuPv+mqknj/FO9Y9gBwTe5
FcLnjVSf04WrC5iS19HJl/SS1kZk2mOMXHeZ5gqmLO1/F7+2kRgtUK5wpIWv3H7e
dKlCM7b1hKHuii704jN5A66u5BCIq74dBr7ierCEu+82Rx66uRueq/BsvFQqQfB8
UGa3nrLQr9oQdteuykAKUjFa0CkzMFsVmroQgY5ou75ZuvFNn5JVxm3hr4Fjrtw/
4OchEkSv6gxZirG3maSM5Eiz8DGqc2GR+xbf3vhPXgcQ7TuZWbBJ43EHVw6rRBZj
B+HurXTUvB15+4/+9WWtvvnsUgeM4ycFOyPHv7r0O6ur/p0/YLlUvCagSR8HIYjm
V5jp5vmzjxdWaHvYhb3Z
=k8DD
-----END PGP SIGNATURE-----

--rS1OKkvW2a3DRalFGCsnu96UbFcs4Ldlv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
