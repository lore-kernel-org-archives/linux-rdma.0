From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not
 enabled
Date: Thu, 26 Jan 2017 11:14:54 -0500
Message-ID: <5c9d8930-d832-d4dc-ddab-43501d57eeaa@redhat.com>
References: <20170115181500.4465-1-leon@kernel.org>
 <1485293330.43764.80.camel@redhat.com>
 <20170125065115.GM6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RnJWSsEG0HHFI9lnb2lgmDcxtKa6bP5GR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125065115.GM6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RnJWSsEG0HHFI9lnb2lgmDcxtKa6bP5GR
Content-Type: multipart/mixed; boundary="l5TqQhd9NedFoAt6Lsj0hDgDu3OaWPqeV";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>,
 Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
Message-ID: <5c9d8930-d832-d4dc-ddab-43501d57eeaa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not
 enabled
References: <20170115181500.4465-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1485293330.43764.80.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170125065115.GM6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170125065115.GM6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--l5TqQhd9NedFoAt6Lsj0hDgDu3OaWPqeV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 1/25/2017 1:51 AM, Leon Romanovsky wrote:
> On Tue, Jan 24, 2017 at 04:28:50PM -0500, Doug Ledford wrote:
>> On Sun, 2017-01-15 at 20:15 +0200, Leon Romanovsky wrote:
>>> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>
>>> If IPV6 has not been enabled in the underlying kernel, we must avoid
>>> calling IPV6 procedures in rdma_cm.ko.
>>>
>>> This requires using "IS_ENABLED(CONFIG_IPV6)" in "if" statements
>>> surrounding any code which calls external IPV6 procedures.
>>
>> This seems strange....
>>
>>> In the instance fixed here, procedure cma_bind_addr() called
>>> ipv6_addr_type() -- which resulted in calling external procedure
>>> __ipv6_addr_type().
>>>
>>> Fixes: 6c26a77124ff ("RDMA/cma: fix IPv6 address resolution")
>>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2+
>>> Cc: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>>  drivers/infiniband/core/cma.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/infiniband/core/cma.c
>>> b/drivers/infiniband/core/cma.c
>>> index bd8d051..e19f19c 100644
>>> --- a/drivers/infiniband/core/cma.c
>>> +++ b/drivers/infiniband/core/cma.c
>>> @@ -2822,7 +2822,8 @@ static int cma_bind_addr(struct rdma_cm_id *id,=

>>> struct sockaddr *src_addr,
>>>  	if (!src_addr || !src_addr->sa_family) {
>>>  		src_addr =3D (struct sockaddr *) &id-
>>>> route.addr.src_addr;
>>>  		src_addr->sa_family =3D dst_addr->sa_family;
>>> -		if (dst_addr->sa_family =3D=3D AF_INET6) {
>>
>> Why this construct?  Isn't the norm to simply surround the entire if
>> statement with
>> #if IS_ENABLED(CONFIG_IPV6)
>> ...
>> #endif
>=20
> It is common way to add dependency on specific config option directly t=
o
> the flow if other "if" already exists. It gives clear view on the flow,=

> eliminates the need to find corresponding #endif and put all constraint=
s
> in one place.

OK, that makes sense, I just hadn't seen it that way.  I'll add this to
the -rc queue.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--l5TqQhd9NedFoAt6Lsj0hDgDu3OaWPqeV--

--RnJWSsEG0HHFI9lnb2lgmDcxtKa6bP5GR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYiiB+AAoJELgmozMOVy/dV6sP/07BHuE2GR6mDXdqiDi1+COx
ngzM5nDv3CNKYq3fU5UaoiXoG+WZ/u2RyfF2ZjhI2c/DTcWwFfsNrD9l/RMtUFYB
gix5Ipquh7t69n1UD/q9g+M4LhSQJ6XmSdO7HBGyKvP7WkCG5xb2TERgk2jiaTLY
cgZCRaYKV/xOnwxpKUrjPXBgv9MP9Kcf+Yy92m9W1FVLL6VqwfSSTEv+XccVBeEu
iFq+qFu6xU2uqYSnVEkdsWGtgNWFrFm3lvwewXH10mNqE0+oWpLIDv+Bc4NAG8YV
Trh+r58wFyL94AIXVkWrzZ69/G2YEXU1YKB5U+n6ubI58vpdQeZWv28y83jHCHGx
DpKGyHu/8z2CUvlwIU/o0ayJHBvpvPuZVK4O7C7AZIpTCgoTMONoPUUHw1gy5u3Q
F+rNj+9nAFYYc/T7dNOUxySH0tt5Jg6Hhk+8KcjPRiBRN7/nCDAMkJ60W1IP/Ate
3CdYFUYgUc+Y95NXZlCyH3UGZekWIPuNA8OSD7Fu5OMGySJ6bgz7EYRuMcAdRn7/
4iZ2z7SwMT+rZ8IgLL+FukJZ52Kiu3xvtNsS1VuzE3bFUn+kJh81CXEQ6BkU9zZj
PcE3loaghmP5ll7xhBOpxyw/LNYZBxOgWce/YqW887t7N/VEPDXbN+2VuJ2zlSsd
mdc6zss3pKpPEs/qLiEa
=DLsA
-----END PGP SIGNATURE-----

--RnJWSsEG0HHFI9lnb2lgmDcxtKa6bP5GR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
