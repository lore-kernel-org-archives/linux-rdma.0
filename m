From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
Date: Tue, 23 Aug 2016 16:16:13 -0400
Message-ID: <7085eced-038f-323b-64c0-b2bcc7ffdb77@redhat.com>
References: <1471907797-81772-1-git-send-email-shiraz.saleem@intel.com>
 <a4f9a872-74a1-7cf9-93a0-808f4b820fa7@redhat.com>
 <20160823191021.GB76544@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hQ9MT3QBaHIbWsGOImdtoS9DSK05EaVkr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823191021.GB76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hQ9MT3QBaHIbWsGOImdtoS9DSK05EaVkr
Content-Type: multipart/mixed; boundary="39duA9SlbVN01DMISSTUxm4AkIk5uc35c"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <7085eced-038f-323b-64c0-b2bcc7ffdb77-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
References: <1471907797-81772-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <a4f9a872-74a1-7cf9-93a0-808f4b820fa7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160823191021.GB76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
In-Reply-To: <20160823191021.GB76544-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>

--39duA9SlbVN01DMISSTUxm4AkIk5uc35c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 3:10 PM, Shiraz Saleem wrote:
> On Tue, Aug 23, 2016 at 12:47:35PM -0400, Doug Ledford wrote:
>> On 8/22/2016 7:16 PM, Shiraz Saleem wrote:
>>> Add NULL check for pdata and pdata->addr before the memcpy in
>>> i40iw_form_cm_frame(). This fixes a NULL pointer de-reference
>>> which occurs when the MPA private data pointer is NULL. Also
>>> only copy pdata->size bytes in the memcpy to prevent reading
>>> past the length of the private data buffer provided by upper layer.
>>>
>>> Fixes: f27b4746f378 ("i40iw: add connection management code")
>>>
>>> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infinib=
and/hw/i40iw/i40iw_cm.c
>>> index 5026dc7..6434398 100644
>>> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>>> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>>> @@ -535,8 +535,8 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame=
(struct i40iw_cm_node *cm_node,
>>>  		buf +=3D hdr_len;
>>>  	}
>>> =20
>>> -	if (pd_len)
>>> -		memcpy(buf, pdata->addr, pd_len);
>>> +	if (pdata && pdata->addr)
>>> +		memcpy(buf, pdata->addr, pdata->size);
>>
>> Is there a guarantee that pdata->size is always less than pd_len?  Do
>> you need a check here?
>>
>=20
> pd_len is 'always' greater than or equal to pdata->size. In i40iw_form_=
cm_frame(),=20
> pd_len starts out as pdata->size and then may be incremented by 4.
>=20

Thanks, I'll pull this in then.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--39duA9SlbVN01DMISSTUxm4AkIk5uc35c--

--hQ9MT3QBaHIbWsGOImdtoS9DSK05EaVkr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvK8NAAoJELgmozMOVy/dNrYQAKNnYCGuTp0Z5VSe4proH+bE
0M/CkGB3Be95HAoA7OH0mB9D+vLnG3FwuSYCeiqShwBgPZ+HA7eJGUVpRQH3mFNg
ShQgJVO65Hjo3+cgZjmOcB5nkZzdU0Bpj0jrlR9bmnTEonh/eBEcnlm48servmi0
mfhP4LqK3s72wXafwG+QtbjODebfx2QSFUmBRsYYwwM3XyOk4U03a/hsuiUwIsdB
CXe6/tuEuhetpPlvAz0Sab5rkb/v0vu909Az4Vl0FdMLVDGmXwHvaqvf2y7z2mzf
izt2onEqxDwSf/D/eMXx88YmGhvy3jekjNYoLZMudnt9dEuNG+1FByvik0p6jAGe
6fBjMBwgqTcK5lTlcsck7XspDmsnVCjFYgWi0UgznPOL8Y8SUXKzWg+IC0U+8B3o
kJIU3oAZXi253eU+Biy517apiAoGkoziAICoe/9KKpbrEp54+GDY0rNL9/MbkLPJ
htDEy8Z+zUrtngKP9fortQXzwoQrMcp+aoPd2Pdr2z6EZfFxrSEWsJ4/tZeg01+T
NT7eUyIB8eFOIDu1srxhYP7Z97w5hVTlU+xSmKqwiTWbnP+amVpJGJOOaP+a2M2G
RqhU5I/1JL9UQUAFD62i1wfD5imM8TDcd65lv0JRfHCR3XZKaXUEVAZ3BiSXXuP0
YJBdfyegF5SPeWMfQ/N3
=PE3N
-----END PGP SIGNATURE-----

--hQ9MT3QBaHIbWsGOImdtoS9DSK05EaVkr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
