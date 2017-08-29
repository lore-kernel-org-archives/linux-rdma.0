From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/vmw_pvrdma: Report network header type
 in WC
Date: Tue, 29 Aug 2017 16:58:33 -0400
Message-ID: <7174aeee-087e-c938-e15f-f3641e170dc9@redhat.com>
References: <cover.1503965717.git.aditr@vmware.com>
 <521f5e2169789e31a7e91dab691cd155f0100090.1503965717.git.aditr@vmware.com>
 <20170829054533.GH23726@mtr-leonro.local>
 <1504014883.52034.33.camel@redhat.com>
 <1164391a-01e3-f067-10c8-61d70bd22b2e@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mfeaKHIXWbPmSBMMb2DnfgpB3UJT62UQN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1164391a-01e3-f067-10c8-61d70bd22b2e-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mfeaKHIXWbPmSBMMb2DnfgpB3UJT62UQN
Content-Type: multipart/mixed; boundary="HFpGhx8NRX3Bw7bjpmkJJ77hJXvPMOA9X";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>,
 pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Message-ID: <7174aeee-087e-c938-e15f-f3641e170dc9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] RDMA/vmw_pvrdma: Report network header type
 in WC
References: <cover.1503965717.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 <521f5e2169789e31a7e91dab691cd155f0100090.1503965717.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
 <20170829054533.GH23726-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1504014883.52034.33.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1164391a-01e3-f067-10c8-61d70bd22b2e-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1164391a-01e3-f067-10c8-61d70bd22b2e-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

--HFpGhx8NRX3Bw7bjpmkJJ77hJXvPMOA9X
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/29/2017 4:50 PM, Adit Ranadive wrote:
> On Tue, Aug 29, 2017 at 06:54:48AM -0700, Doug Ledford wrote:
>> On Tue, 2017-08-29 at 08:45 +0300, Leon Romanovsky wrote:
>>> On Mon, Aug 28, 2017 at 05:19:35PM -0700, Adit Ranadive wrote:
>>>> From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> We should report the network header type in the work completion so
>>>> that
>>>> the kernel can infer the right RoCE type headers.
>>>>
>>>> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    |  6 ++++++
>>>>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c |  2 ++
>>>>  include/uapi/rdma/vmw_pvrdma-abi.h           | 13 +++++++++++--
>>>>  3 files changed, 19 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
>>>> b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
>>>> index 663a0c3..99b2c97 100644
>>>> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
>>>> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
>>>> @@ -426,6 +426,12 @@ static inline int pvrdma_wc_flags_to_ib(int
>>>> flags)
>>>>  	return flags;
>>>>  }
>>>>
>>>> +static inline enum rdma_network_type pvrdma_wc_network_hdr_to_ib(
>>>> +					enum pvrdma_network_type
>>>> type)
>>>> +{
>>>> +	return (enum rdma_network_type)type;
>>>> +}
>>>> +
>>>>  static inline int ib_send_flags_to_pvrdma(int flags)
>>>>  {
>>>>  	return flags & PVRDMA_MASK(PVRDMA_SEND_FLAGS_MAX);
>>>> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
>>>> b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
>>>> index 90aa326..34727f6 100644
>>>> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
>>>> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
>>>> @@ -389,6 +389,8 @@ static int pvrdma_poll_one(struct pvrdma_cq
>>>> *cq, struct pvrdma_qp **cur_qp,
>>>>  	wc->dlid_path_bits =3D cqe->dlid_path_bits;
>>>>  	wc->port_num =3D cqe->port_num;
>>>>  	wc->vendor_err =3D cqe->vendor_err;
>>>> +	wc->network_hdr_type =3D
>>>> +			pvrdma_wc_network_hdr_to_ib(cqe-
>>>>> network_hdr_type);
>>>>
>>>>  	/* Update shared ring state */
>>>>  	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq-
>>>>> ibcq.cqe);
>>>> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h
>>>> b/include/uapi/rdma/vmw_pvrdma-abi.h
>>>> index c8c1d2d..6a87806 100644
>>>> --- a/include/uapi/rdma/vmw_pvrdma-abi.h
>>>> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
>>>> @@ -58,6 +58,13 @@
>>>>  #define PVRDMA_UAR_CQ_ARM		BIT(30)		/*
>>>> Arm bit. */
>>>>  #define PVRDMA_UAR_CQ_POLL		BIT(31)		/
>>>> * Poll bit. */
>>>>
>>>> +enum pvrdma_network_type {
>>>> +	PVRDMA_NETWORK_IB,
>>>> +	PVRDMA_NETWORK_ROCE_V1 =3D PVRDMA_NETWORK_IB,
>>>> +	PVRDMA_NETWORK_IPV4,
>>>> +	PVRDMA_NETWORK_IPV6
>>>> +};
>>>
>>> Doug,
>>>
>>> I see that you are already merged this patch, but it is problematic
>>> patch.
>>
>> It's only gone to github, so it's not set in stone.
>>
>>> They defined in uapi file, the new enum which is equal to already
>>> existed
>>>  128 enum rdma_network_type {
>>>  129         RDMA_NETWORK_IB,
>>>  130         RDMA_NETWORK_ROCE_V1 =3D RDMA_NETWORK_IB,
>>>  131         RDMA_NETWORK_IPV4,
>>>  132         RDMA_NETWORK_IPV6
>>>  133 };
>>>
>>> And the more important they are doing direct casting from
>>> rdma_network_type to
>>> pvrdma_network_type as is in the same patch.
>>>
>>> The proper way to do it is to return rdma_network_type directly
>>> without obfuscation
>>> and without creating new supported forever UAPI enum.
>>
>> Generally, I would agree with you.  I guess that's what I get for
>> trying to get everything done and working late last night :-/.
>>
>> Adit, is there a reason for the duplicate enum and silly casting in
>> this patch?  If there isn't a specific reason for it, then it would be=

>> best to re-write it without this silliness.
>=20
> Doug, sorry to go back and forth on this. We had an internal discussion=
 on this.
> Jorgen pointed out that having the enum is to isolate our device from f=
uture
> changes to rdma_network_type.

The rdma_network_type is not going to change.  It might get extended,
but not changed.

> Our enum reflects the device value independent of
> the RDMA stack and does need to be converted (even though the values ar=
e the same
> and we don't return the rdma_network_type enum from our device anyways)=
=2E
>=20
> Instead of dropping this enum we would like to just drop the casting an=
d move to
> a switch case to make the conversion clearer.

As long as you guys are returning the same thing, you can just use the
enum as it is.  If the enum gets updated and you don't want your driver
to reflect that update, then that would be the appropriate time to
create a switch or a different enum with a conversion or whatever.  You
would have to update your driver in that case even if you do a switch
right now because you can't put in the option for the extension in your
conversion function before the extension exists, so there is no savings
or safety in adding a conversion that doesn't actually convert at this ti=
me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--HFpGhx8NRX3Bw7bjpmkJJ77hJXvPMOA9X--

--mfeaKHIXWbPmSBMMb2DnfgpB3UJT62UQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpdV+AAoJELgmozMOVy/dFgkQAJClIrujMSB3lEYYaez4Mskx
iJcZLeInPSeLD2f6g8eEr3R3tXxkETVVSujxdSzrkstR1dNkGOip1dn8+m6x+O6p
CQNKPy//7XyCeU86sEU5kHIQJ7ZeSwza4SfS0wjbOUqm5UH8wJ80RNfyeS2kTsbH
UeLh3nNsRUtTKGrJ8jRfhfqiCVnVX1XX63HsDDbQLtHqLMjNbWinX6P8wDtmA/oB
vLs1yAfoN7WFjmJ04Gp7SsD4TL8C3jmsy1OWLpQpEY/bRXNGswCr5MGkk7I6VGar
IFo4mErHRzerdC7u5VdCQGow8gw/xw6iGglu5F2WnPx+b6UBQluRUULIexn0SSAJ
Gl6NBjTt88nCwirAhBn2c8g9c5emCm5anKZdrx1ucDm+NvitHcpIRXRJal7hIDFk
qD3ZgPJqrWg1kkQaw1Ka363/gW+UdpRciFoWDaYNDaJg970w1kiQ5FZzA/BHlxP3
JW576LC9AfrUauYEski4Gk0HrIQJFgIlP4G99y5/kUh22rJ0ZOoRmjsiCLFM/hSz
v7M6ApYp//ypLMtIazukgGUUjs0VUW3JITj0SjfyILAyBg4jaM2wRWm7SbbJz1lz
zFFVFPrQ/4+UwqaLVi2bBVTIkcoKxHCG05dd+fmepPAybFJxeCpKhDwwa9VKHOEs
ago76lzN3jVYmC7IQb8k
=YfUG
-----END PGP SIGNATURE-----

--mfeaKHIXWbPmSBMMb2DnfgpB3UJT62UQN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
