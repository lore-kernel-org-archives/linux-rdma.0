From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
Date: Wed, 24 Aug 2016 11:23:14 -0400
Message-ID: <b1b2dc3c-85ba-4d9d-56d1-5fe0eae3717a@redhat.com>
References: <1471907797-81772-1-git-send-email-shiraz.saleem@intel.com>
 <a4f9a872-74a1-7cf9-93a0-808f4b820fa7@redhat.com>
 <20160823191021.GB76544@ssaleem-MOBL4.amr.corp.intel.com>
 <7085eced-038f-323b-64c0-b2bcc7ffdb77@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4wH9c9ePdli1g1lInKEMGR15KcCtw6XtR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7085eced-038f-323b-64c0-b2bcc7ffdb77-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4wH9c9ePdli1g1lInKEMGR15KcCtw6XtR
Content-Type: multipart/mixed; boundary="BFjt6kf7kPnbe8RFbJsEgvrO8VQlwTCab"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <b1b2dc3c-85ba-4d9d-56d1-5fe0eae3717a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
References: <1471907797-81772-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <a4f9a872-74a1-7cf9-93a0-808f4b820fa7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160823191021.GB76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
 <7085eced-038f-323b-64c0-b2bcc7ffdb77-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <7085eced-038f-323b-64c0-b2bcc7ffdb77-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--BFjt6kf7kPnbe8RFbJsEgvrO8VQlwTCab
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 4:16 PM, Doug Ledford wrote:
> On 8/23/2016 3:10 PM, Shiraz Saleem wrote:
>> On Tue, Aug 23, 2016 at 12:47:35PM -0400, Doug Ledford wrote:
>>> On 8/22/2016 7:16 PM, Shiraz Saleem wrote:
>>>> Add NULL check for pdata and pdata->addr before the memcpy in
>>>> i40iw_form_cm_frame(). This fixes a NULL pointer de-reference
>>>> which occurs when the MPA private data pointer is NULL. Also
>>>> only copy pdata->size bytes in the memcpy to prevent reading
>>>> past the length of the private data buffer provided by upper layer.
>>>>
>>>> Fixes: f27b4746f378 ("i40iw: add connection management code")
>>>>
>>>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infini=
band/hw/i40iw/i40iw_cm.c
>>>> index 5026dc7..6434398 100644
>>>> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>>>> @@ -535,8 +535,8 @@ static struct i40iw_puda_buf *i40iw_form_cm_fram=
e(struct i40iw_cm_node *cm_node,
>>>>  		buf +=3D hdr_len;
>>>>  	}
>>>> =20
>>>> -	if (pd_len)
>>>> -		memcpy(buf, pdata->addr, pd_len);
>>>> +	if (pdata && pdata->addr)
>>>> +		memcpy(buf, pdata->addr, pdata->size);
>>>
>>> Is there a guarantee that pdata->size is always less than pd_len?  Do=

>>> you need a check here?
>>>
>>
>> pd_len is 'always' greater than or equal to pdata->size. In i40iw_form=
_cm_frame(),=20
>> pd_len starts out as pdata->size and then may be incremented by 4.
>>
>=20
> Thanks, I'll pull this in then.
>=20

Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--BFjt6kf7kPnbe8RFbJsEgvrO8VQlwTCab--

--4wH9c9ePdli1g1lInKEMGR15KcCtw6XtR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvbviAAoJELgmozMOVy/d6bAP/0dQ5FipI7iO1vTRy/jKgfxe
tezfJdpMbeI5n6xL5B8o2xg660i7D0mg/8i8mvm4JuGM+2CP+6NTBljd7sjAaCyl
wqetqq7EPTdBMw0ZnuUoR3Lnwxjh5C5Q1eSYulfSt7oNh2JO7ZyXJPEvSbPr4C7I
3lD6E6lbgIW07SHqYIZ3oyY+EnF+r+FmBNWpxJ9WAMJHe+K5zueJGdZiTvdDuUK4
XseEinj+k0Ih5jWVMq3Cv4coMphlGhJxNAqcLHq9UiGcP+ZIuDXRThQLx3J8rqcl
vuofzrJWi+ehqQuyb3hdM//K8ZAUVw7VfgG7bhZoM9uJc+d9g/NfgRrPfdMf2eHG
hcF/6YDRMdYkXJlLGnzak29dVDnNtGS9o7pIt6H4OVzqoqJedCPpy8bhbB48BeKi
h20qiKLxrYnW/B7lnR6lhRYE+0xNQjRJhKnjKTdn6g6fYXDNdvz6J1QWgfc0ZoAj
Uw3M9EKRXlsblB1EHaz/uxBe937KWx0gc6YTpiAvEAucNIka1wfK1bC8/eaG+ZqZ
4uOpu/tcVeOGnHd4Feq5K0xoPp8qxpxK2GGhd3aB8Zz/B48OQ7B7Ta4WYh+d31BY
iqtrmXOS/lay0vaWpcMdo1+XQue2O/ZMWsWnY6KS9z5ORl3MWQFaGfSY9FGcqAL2
jycvBVzX6Xdvlbu10slT
=8jCX
-----END PGP SIGNATURE-----

--4wH9c9ePdli1g1lInKEMGR15KcCtw6XtR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
