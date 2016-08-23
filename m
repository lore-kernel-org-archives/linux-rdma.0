From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
Date: Tue, 23 Aug 2016 15:05:42 -0400
Message-ID: <66032524-b459-6429-93f9-101da7809f7e@redhat.com>
References: <1471910507-83104-1-git-send-email-shiraz.saleem@intel.com>
 <20160823014135.GF15065@leon.nu>
 <20160823160030.GA37288@ssaleem-MOBL4.amr.corp.intel.com>
 <a65ff978-0790-24aa-d0c9-0e5aaaf7b301@redhat.com>
 <20160823184623.GN15065@leon.nu>
 <20160823190022.GA76544@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jeL1kqACLGdiwWBfohIA7gcIQvWDdkdIJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823190022.GA76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jeL1kqACLGdiwWBfohIA7gcIQvWDdkdIJ
Content-Type: multipart/mixed; boundary="j0JNP1gQ25JrE57WulgqIAuQWNFjXdNrS"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <66032524-b459-6429-93f9-101da7809f7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] i40iw: Do not set self-referencing pointer to NULL
 after kfree
References: <1471910507-83104-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20160823014135.GF15065-2ukJVAZIZ/Y@public.gmane.org>
 <20160823160030.GA37288-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
 <a65ff978-0790-24aa-d0c9-0e5aaaf7b301-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160823184623.GN15065-2ukJVAZIZ/Y@public.gmane.org>
 <20160823190022.GA76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
In-Reply-To: <20160823190022.GA76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>

--j0JNP1gQ25JrE57WulgqIAuQWNFjXdNrS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 3:00 PM, Shiraz Saleem wrote:
> On Tue, Aug 23, 2016 at 09:46:23PM +0300, Leon Romanovsky wrote:
>> On Tue, Aug 23, 2016 at 12:51:10PM -0400, Doug Ledford wrote:
>>> On 8/23/2016 12:00 PM, Shiraz Saleem wrote:
>>>> On Tue, Aug 23, 2016 at 04:41:35AM +0300, Leon Romanovsky wrote:
>>>>> On Mon, Aug 22, 2016 at 07:01:47PM -0500, Shiraz Saleem wrote:
>>>>>> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>>
>>>>>> In i40iw_free_virt_mem(), do not set mem->va to NULL
>>>>>> after freeing it as mem->va is a self-referencing pointer
>>>>>> to mem.
>>>>>
>>>>> Sorry, I failed to understand your commit message and your change.
>>>>> What did you mean? How do you suppose to use mem->va pointer
>>>>> after kfree() call on that pointer? Won't you have use-after-free b=
ug in
>>>>> such case?
>>>>
>>>> The pointer mem->va cannot be used after kfree. But setting it to=20
>>>> NULL would be writing to freed memory. In i40iw_puda_alloc_buf(),=20
>>>> when a buffer is allocated of type struct i40iw_puda_buf, the addres=
s=20
>>>> of the buffer itself is stored within the structure (in member buf_m=
em).=20
>>>> When this pointer is freed, the structure containing the pointer is =
freed,
>>>> so writing to the structure would be writing to freed memory, which =
is=20
>>>> what this fix is for.
>>>> =20
>>>>>>
>>>>>> Fixes: 4e9042e647ff ("i40iw: add hw and utils files")
>>>>>>
>>>>>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> ---
>>>>>>
>>>>>> V2: Fix typo in subject line.
>>>>>>
>>>>>>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 1 -
>>>>>>  1 file changed, 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/i=
nfiniband/hw/i40iw/i40iw_utils.c
>>>>>> index 0e8db0a..d5f5de2 100644
>>>>>> --- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
>>>>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
>>>>>> @@ -674,7 +674,6 @@ enum i40iw_status_code i40iw_free_virt_mem(str=
uct i40iw_hw *hw,
>>>>>>  	if (!mem)
>>>>>>  		return I40IW_ERR_PARAM;
>>>>>>  	kfree(mem->va);
>>>>>> -	mem->va =3D NULL;
>>>>>>  	return 0;
>>>
>>> Your commit message is a bit hard to follow, but if I follow the
>>> conversation, kfree(mem->va) is the same as kfree(mem), is it not?  I=
f
>>> it is, couldn't you just kfree(mem)?  That would avoid the confusion
>>> here.  Also, if it matters, you can use a temporary pointer, aka:
>>>
>>> p =3D mem->va;
>>> mem->va =3D NULL;
>>> kfree(p);
>>>
>>> but, again, if mem->va is just a self-referencing pointer back to mem=
,
>>> then why not just kfree(mem)?  I'm concerned that this convoluted way=
 of
>>> doing things will come back to haunt us later when people think they =
are
>>> submitting a fix and simply reintroduce the same bug again.
>>
>> Yeah, I totally agree with you.
>>
>=20
> OK, I see the the possible confusion of the commit message.=20
>=20
> Maybe the following is clearer:
> "In i40iw_free_virt_mem(), do not set mem->va to NULL after freeing it,=
 as mem->va is a pointer=20
> to the structure containing mem"
>=20
> So kfree(mem->va) is not the same as kfree(mem).=20

That makes more sense.  I still think things are a bit convoluted here,
and maybe even a code comment is in order.  I'll probably change it up a
little bit as I pull it in.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--j0JNP1gQ25JrE57WulgqIAuQWNFjXdNrS--

--jeL1kqACLGdiwWBfohIA7gcIQvWDdkdIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvJ6GAAoJELgmozMOVy/dHncP/jML6yl7U11A0pWhnRAx7ljS
IoNIcDKqXbGBwgqTJdcUlKJ0W4xin86ihIF2IbrhcgaIYWxgzfTA0I0MWesGHl6R
3bCbhqiGTHJcGoPD+iz1thKY1BTJxrQqoKeXHA8793B5X2N6rCzJid2ojM6uHfE6
XLkFtnquMHPAT4vmTqSOIwKWRTZqQwgmDe07hAO9H/M+h4K+v5ZOyoVk4NUcZM+a
jWdQKxaXCXLEVGP3oq6eRiYE2XGhXEESDy2078mwi1wEWnKwYRDXynJR+3O0YCPS
GjGEJagg0eE22KvADxHD1EubAIUvHghlf0fMNC1LsjR8hiz0VSoUbNXFx6W0lYls
7z2n+nUzP+1vg7BQXmC5S9WLgU5C5PFXyWW4LYLtpobRaCm/gJkhCW2eZf4bF0wU
pxc6qEMDU/fS+0KH6DclQa6BRahC42h6KVWxQQ89Ij+nL1pCrii7Q1NJGc7FFur+
oYTPqkcCGLivX6iG0cXoxL5l9n8EpFesWPMBa5XOxVSNWYQ4H2ySDQ9BFStDj4LA
bHCDM/BTjjQ7tM1yQVvih829gX64Po7S0m6OAze9urcGypVsbzLccFEaJMqpxSnM
M4IAnnRn9K+wUMsDINbW/yhoTXoiUuwQvrcxrSQ0cInV6PQ5+GgTAS4MX3KZ05g0
outy90fEyi3MYW+GD519
=D2vX
-----END PGP SIGNATURE-----

--jeL1kqACLGdiwWBfohIA7gcIQvWDdkdIJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
