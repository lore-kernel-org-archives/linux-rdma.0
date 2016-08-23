From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Tue, 23 Aug 2016 12:51:10 -0400
Message-ID: <a65ff978-0790-24aa-d0c9-0e5aaaf7b301@redhat.com>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
 <20160823014135.GF15065@leon.nu>
 <20160823160030.GA37288@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cxRSwta6HRGXBUWubEBWbl1ttKNOnQIN2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823160030.GA37288-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cxRSwta6HRGXBUWubEBWbl1ttKNOnQIN2
Content-Type: multipart/mixed; boundary="1BTSghFcVKSGwklBSeTub9o6KVi5tvEMd"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <a65ff978-0790-24aa-d0c9-0e5aaaf7b301-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
References: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20160823014135.GF15065-2ukJVAZIZ/Y@public.gmane.org>
 <20160823160030.GA37288-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
In-Reply-To: <20160823160030.GA37288-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>

--1BTSghFcVKSGwklBSeTub9o6KVi5tvEMd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 12:00 PM, Shiraz Saleem wrote:
> On Tue, Aug 23, 2016 at 04:41:35AM +0300, Leon Romanovsky wrote:
>> On Mon, Aug 22, 2016 at 07:01:47PM -0500, Shiraz Saleem wrote:
>>> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> In i40iw_free_virt_mem(), do not set mem->va to NULL
>>> after freeing it as mem->va is a self-referencing pointer
>>> to mem.
>>
>> Sorry, I failed to understand your commit message and your change.
>> What did you mean? How do you suppose to use mem->va pointer
>> after kfree() call on that pointer? Won't you have use-after-free bug =
in
>> such case?
>=20
> The pointer mem->va cannot be used after kfree. But setting it to=20
> NULL would be writing to freed memory. In i40iw_puda_alloc_buf(),=20
> when a buffer is allocated of type struct i40iw_puda_buf, the address=20
> of the buffer itself is stored within the structure (in member buf_mem)=
=2E=20
> When this pointer is freed, the structure containing the pointer is fre=
ed,
> so writing to the structure would be writing to freed memory, which is =

> what this fix is for.
> =20
>>>
>>> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
>>>
>>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>
>>> V2: Fix typo in subject line.
>>>
>>>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infi=
niband/hw/i40iw/i40iw_utils.c
>>> index 0e8db0a..d5f5de2 100644
>>> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
>>> @@ -674,7 +674,6 @@ enum i40iw_status_code i40iw_free_virt_mem(struct=
 i40iw_hw *hw,
>>>  	if (!mem)
>>>  		return I40IW_ERR_PARAM;
>>>  	kfree(mem->va);
>>> -	mem->va =3D NULL;
>>>  	return 0;

Your commit message is a bit hard to follow, but if I follow the
conversation, kfree(mem->va) is the same as kfree(mem), is it not?  If
it is, couldn't you just kfree(mem)?  That would avoid the confusion
here.  Also, if it matters, you can use a temporary pointer, aka:

p =3D mem->va;
mem->va =3D NULL;
kfree(p);

but, again, if mem->va is just a self-referencing pointer back to mem,
then why not just kfree(mem)?  I'm concerned that this convoluted way of
doing things will come back to haunt us later when people think they are
submitting a fix and simply reintroduce the same bug again.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--1BTSghFcVKSGwklBSeTub9o6KVi5tvEMd--

--cxRSwta6HRGXBUWubEBWbl1ttKNOnQIN2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH7+AAoJELgmozMOVy/dIikQAKV2TPX2s1KZP74TMMAyMZIS
X3GqkSWi7HjtSrLfbO5n2lfGQl1V/p26b2AUpAMH8LoGpzBe61/7vvyAiCBtHkWH
N86eFHHgRcHNapjua2sxRO5lKZQ4acy+ODWDR+skB/N2WIOhGXVSpzZVslJa+Ph/
3gTFKjNnr5ib8V7Z44a4P/2QnPGVXYvUzBy++TJmm+WxL+u7HK9IATg+ZgUH5EF1
owwq/sP39k1enCvuK0OFc7IsWQFbOKtwzS4lcizXvQVWRx+TjTj3+gjZCQWHcl9d
YTKaQ3Xx74JIDZslRs61PSWhmaiFUSmWOSD0KUrBMy5XOoOL3eQ4BNnJMFFxq7l4
rGV0hhuexmQOhEmrhP9lINvFT+/9pTRElQMpcO/vvCy0HHW5WZbYJ8U9y3kHeHnn
jYZqCiH3dXUNkoZ/ZLLF18Hz0l4IKoW+/RL3nT/bJQd7DsfqRxvnUXCjxH4iNR3z
xTmxP++5o/PYQ9+N/ALyHCjeH9+uW/hWv/r0IHPD8jyWdEdPsbrYTf150DWMVSXq
oLWB8e3nmlQvWCgxRZst605x2IQfatPY4yFYFKOk0ffvkkgTxklOeHOA/u+I2+Nx
FPgGOwXSOyL5p/QbAdAj5jEFes4fxFuS3ahpxp1QJ2wZdmVto6MsEVZZ54qbvGTV
Z+hql8js6WlrPuJgK/MI
=XTGM
-----END PGP SIGNATURE-----

--cxRSwta6HRGXBUWubEBWbl1ttKNOnQIN2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
