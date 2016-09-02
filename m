From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 2 Sep 2016 13:11:53 -0400
Message-ID: <dd0f8f43-ffc3-ff61-567f-83a24060ac62@redhat.com>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <d3eea048-5c7e-a5e9-900b-fabf0f6e38c8@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KLEWhGxjdjrKsD5KCLmxXSssAdNdvPeW3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d3eea048-5c7e-a5e9-900b-fabf0f6e38c8-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KLEWhGxjdjrKsD5KCLmxXSssAdNdvPeW3
Content-Type: multipart/mixed; boundary="dHKWclj7tECPWWun7TaqpQWrpGqo1Fd8G";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Kernel Janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <dd0f8f43-ffc3-ff61-567f-83a24060ac62-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
References: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <d3eea048-5c7e-a5e9-900b-fabf0f6e38c8-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
In-Reply-To: <d3eea048-5c7e-a5e9-900b-fabf0f6e38c8-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

--dHKWclj7tECPWWun7TaqpQWrpGqo1Fd8G
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/27/2016 1:25 AM, Christophe JAILLET wrote:
> Le 26/08/2016 =C3=A0 15:35, Doug Ledford a =C3=A9crit :
>> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
>>> The 2nd parameter of 'find_first_bit' is the number of bits to search=
=2E
>>> In this case, we are passing 'sizeof(unsigned long)' which is likely =
to
>>> be 4 or 8.
>> If the size can be 4 or 8, then using 64 universally is not correct.
>> Why not use sizeof() * 8 (or << 3)?
> I agree with you...
>=20
> BTW, the log message is wrong. 'port_mask' is a u64. (not an unsigned
> long). So the sizeof should always be 8.
> (cut and paste error from another patch, sorry)

Log message modified, then patch modified to use sizeof() * 8, result
applied.  Thanks.

>>
>>> It is likely that the number of bits of 'port_mask' was expected
>>> here. This
>>> variable is a 'u64', so use 64 instead.
>>>
>>> It has been spotted by the following coccinelle script:
>>> @@
>>> expression ret, x;
>>>
>>> @@
>>> *  ret =3D \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...))=
;
>>>
>>> Signed-off-by: Christophe JAILLET
>>> <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
>>> ---
>>> Not sure that using 64 directly is the best option.
>>> Maybe '8 * sizeof(port_mask)' as used in the same file for
>>> 'for_each_set_bit' would be better
>>> ---
> ... as noted here
>=20
> Would you like a v2 patch or, will you update it by yourself?
>=20
> Best regards,
> CJ
>=20
> ---
> L'absence de virus dans ce courrier =C3=A9lectronique a =C3=A9t=C3=A9 v=
=C3=A9rifi=C3=A9e par le
> logiciel antivirus Avast.
> https://www.avast.com/antivirus
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--dHKWclj7tECPWWun7TaqpQWrpGqo1Fd8G--

--KLEWhGxjdjrKsD5KCLmxXSssAdNdvPeW3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXybLaAAoJELgmozMOVy/dPbQP/ArNz/8JhRQc5j738o3xpHk5
Pvh6fxLNBOGrtC+1az2OPe1NLulA9NCKuamWFXcT7htvZxQrIJjGKKthBRe51UVm
ubxio0zh0FnWENbkNDbEO50gimaOq5CveUalzLtr3AhmzwBUtDWXdHVWeI8YL3Xe
Tk7vsi0fpokpbsdSKxj00m1SlC6uSUwG7UrsMNveELeJVKX9nEF/0RyoBKmNMSOG
IML8WjprekpUXmhfJHi20UYp/xpAC3rwmd82Cgudk18NThbDao5FOQrsnWwWDWoK
eHUjK5z5PauHknwslXv8uy2n8A/mKyHrzdBKaaI18g1bqN9BuBtNea8wI0Fm6HnG
PDJkiiP9qiQsGFnoyqEmQWv6c8hg3B+0h7NvclbTtIjOm5XOqaJfQZnws0xLbutt
QJSJsEr+5yhDM+NJooo0qZFqcm8RHUKV+C/xTvyJWWWQ+13bgNG+ky10jG2sByTU
RRxDQnWhjmVM2LQr2uquunSX0v57NNw4rDhWZiL4uhDy5WnbtGu23HbPxEUZ8WIi
oj8dXP91or469glRol/XeLE08jcHDcBk+sePjxXp9DUIjmVYNLnslDmR9uH0Tiw+
4c/vCDmJezpr1htdapouBjhZcOsOGcbWBSvgHMeU78FBwl86zf5d+gnVwPevNZNa
yjsoL1UVafGfr0fMY4aI
=NO9v
-----END PGP SIGNATURE-----

--KLEWhGxjdjrKsD5KCLmxXSssAdNdvPeW3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
