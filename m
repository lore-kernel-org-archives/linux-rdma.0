From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] RDMA/uverbs: Initialize cq_context appropriately
Date: Mon, 21 Aug 2017 20:44:45 -0400
Message-ID: <422b35ff-ecb9-44bb-be20-302d8d343ed3@redhat.com>
References: <1501565315-3183-1-git-send-email-bharat@chelsio.com>
 <CAAKD3BCdeG=FkUNQjqGxEYw5Sx-TtmeRSAA8K7M43G62Qw_gbw@mail.gmail.com>
 <1503079603.2598.33.camel@redhat.com>
 <008701d31863$c83d3600$58b7a200$@opengridcomputing.com>
 <01cb01d31ab1$51458340$f3d089c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gkR3uGgwxGDivWM5WEWhoqcf6EH6LxJNJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01cb01d31ab1$51458340$f3d089c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gkR3uGgwxGDivWM5WEWhoqcf6EH6LxJNJ
Content-Type: multipart/mixed; boundary="uJV250Tv4c6jqujwsG7Sb7387VbPnIUw3";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>,
 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <422b35ff-ecb9-44bb-be20-302d8d343ed3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] RDMA/uverbs: Initialize cq_context appropriately
References: <1501565315-3183-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
 <CAAKD3BCdeG=FkUNQjqGxEYw5Sx-TtmeRSAA8K7M43G62Qw_gbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1503079603.2598.33.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <008701d31863$c83d3600$58b7a200$@opengridcomputing.com>
 <01cb01d31ab1$51458340$f3d089c0$@opengridcomputing.com>
In-Reply-To: <01cb01d31ab1$51458340$f3d089c0$@opengridcomputing.com>

--uJV250Tv4c6jqujwsG7Sb7387VbPnIUw3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/2017 3:11 PM, Steve Wise wrote:
> ping...
>=20
>>
>>>
>>> I agree, I like your solution better.  Patch fixed up and applied.
>>>
>>
>> Hey Doug, I see this in your -next branch, but it needs to hit 4.13-rc=
 and stable, as it
>> is a fatal regression that breaks user mode rdma applications.

OK, I'll get it into -rc then.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--uJV250Tv4c6jqujwsG7Sb7387VbPnIUw3--

--gkR3uGgwxGDivWM5WEWhoqcf6EH6LxJNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZm359AAoJELgmozMOVy/dQhoP/RpOJlujKj8eT1pNYAL7Urfn
zrYKFC2vHPcpPe+3ZNbNGrtmlhhr1J9EDzw7smzETTvtmywmZLQvWIAMr6GCiauo
ZalwVQZ1s8mZ1J8qRULMicMtAqLtCtpRPo7pjXe2HY8xXXgoLVHMfzE2YQJXEvB+
xveFEo6XAKEnQixO6DLdJn0xLsrS5iRIP86FmqJK2ilsngSpivyGDjcSSayxU0jE
CK1pgVAmrTh014S3SQtVq4oXZunRUScVpeZvZNRwCeLsUegWDSZP42Gs5GHLTZaT
m/exDwvjnPJ/giak3SGFbB2lypcp8PUuYaUngOexrpQU36KS2rn4zO4J67hDCfpj
8c1TCHszvPu+PQyLirokwRDLB+zM/FZtGN58GBew+VHbaq6wt7pH/1ofk9Iose3w
/WsmcWFsma7OmqzMQ/T0cUNmK11mKllMfWlq9uavyWVNq6UoGZzXsBjbr3Sk7id7
f6D8fozHrfxwTDLdN2Qe+1EyTv/VARpMNJS5ESxbGeGOhXOW76yNg4PEsUArcZvR
ScNG87YHVCefEOljkv0ryqVC3DPlWSiOpULXi+p215fth7dkN6IzbJSCNiQB+F4i
vFTamRA7scD+Yu3BMtITKzMT5UInt//suI2EZg86/6eariSCBth+X+TXbl/cnZ2D
s4BCbK9wBGzYuIr3JsNc
=6Yuf
-----END PGP SIGNATURE-----

--gkR3uGgwxGDivWM5WEWhoqcf6EH6LxJNJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
