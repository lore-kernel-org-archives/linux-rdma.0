From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 10:34:19 -0400
Message-ID: <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-4-bart.vanassche@wdc.com>
 <20171008100317.GR25829@mtr-leonro.local>
 <1507568205.46071.46.camel@redhat.com> <1507568492.2674.11.camel@wdc.com>
 <20171010041423.GJ1252@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vCtrlpPxkwSBKUwDn0qiTc4s8pPuHJGf3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010041423.GJ1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vCtrlpPxkwSBKUwDn0qiTc4s8pPuHJGf3
Content-Type: multipart/mixed; boundary="ErH0xrm2gdeUNxDwU7NjTSJLQsOGH7TcW";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <9443ec1f-0acd-9fa3-4621-a29085d2c606-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
References: <20171006214243.11296-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
 <20171006214243.11296-4-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
 <20171008100317.GR25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <1507568205.46071.46.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <1507568492.2674.11.camel-Sjgp3cTcYWE@public.gmane.org>
 <20171010041423.GJ1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20171010041423.GJ1252-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--ErH0xrm2gdeUNxDwU7NjTSJLQsOGH7TcW
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/10/2017 12:14 AM, Leon Romanovsky wrote:
> On Mon, Oct 09, 2017 at 05:01:33PM +0000, Bart Van Assche wrote:
>> On Mon, 2017-10-09 at 12:56 -0400, Doug Ledford wrote:
>>> On Sun, 2017-10-08 at 13:03 +0300, Leon Romanovsky wrote:
>>>> It is a little bit strange to ask from user to decide if his adapter=

>>>> supports SRQ or not.
>>>>
>>>> It should be automatically.
>>>
>>> I think Bart's intent is that the driver not use SRQ as the default
>>> behavior even if the adapter supports it, so querying the adapter for=

>>> support and enabling it if it exists would not achieve his desired
>>> result.  This would then be used to override that behavior.  Is that
>>> correct Bart?
>>
>> Hello Leon and Doug,
>>
>> The changes realized by this patch are:
>> - Instead of using SRQ as default, use non-SRQ mode as default.
>> - If SRQ has been chosen as default, and if SRQ is not supported, fall=
 back
>>   to non-SRQ mode (see also the if (IS_ERR(sdev->srq)) ... code).
>>
>> Please let me know if you have any further questions about this patch.=

>=20
> Yes, in case HCA supports SRQ, when do you set that module parameter?

You set it in your /etc/modprobe.d/ib_srp.conf file or the equivalent in
your OS.

> In the commit message, you mentioned disadvantages of using SRQ is a
> default and among them - locks contention, which can be changed in the
> future. Won't it mean that users stuck with current default, because
> change of default will "break" their scripts?

No, it won't.  If you change the default, you don't remove the variable,
you just change what its setting is.  Then existing modprobe.d files
become redundant, but nothing breaks.  People that don't want the new
setting add a new file to the modprobe.d directory to change the option.

> Setting visible to user default won't allow us to change SRP behavior i=
n
> the future.

No it doesn't.

> I wouldn't recommend to make such option accessible by users.
>=20
> Thanks
>=20
>>
>> Bart.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--ErH0xrm2gdeUNxDwU7NjTSJLQsOGH7TcW--

--vCtrlpPxkwSBKUwDn0qiTc4s8pPuHJGf3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZ3NpsAAoJELgmozMOVy/d26EP/3zVAzGeM36r+UAWaQNb+E4e
nfD9EfUFgI34gOgAmWSWG19bzGyEvaxPOgkvm/TMTa6+9dcb7v+mOXlJLY061US/
dbV4lr2lI4uPTsO9VMtqStqsNFO/Chkg/omgu/9/4WcshfpHreyw2jO7kZk7ROF/
ODLJw92czhuh/XpAd7kN7WOWvCvYPq7uOeTvLpRPm2daqe0I+vFcRi0XYj5lizd/
ZROqAVpiW7eKiTZo/UkQM3D+bKogGDwkwkkSpwX4H/raXE6tFvT60wxsfrkVTeZY
OHEmpcGI7HuxVqXDaEJ3TgWQD/Ml/7NUd02CbjKW4y5QPQq7RCRnc7sINtDxcJJj
mkOYYT2JIZxdzi2mDVtKI+AaElYNVa4pZf236+3uAWHxOEbJfyljLulWs6rMiX8g
8a/Z3NoY1n040b/i9rJ8hs0SU4tmjfC8Y6zPFzKiNom9qMwX11v0W1G88OQ8faFG
Hq9d8HaaxFzxA1MEWVTzZVWs3lJYG7YDEEoyEJf72NoFcSEv9v4SS0DmHiM1Drtt
J4Z3Tg2vZLYhe1jAqmhf6b5RH38N1RZRa6nZ0p3w0OJL+GxtXsNzAFKmq2VP3zzy
g5vffyeEkwHqac455r1411IfAIgYaazk9Up2oZdj+rEuP0ocD1Ss1zTlEMFRlVmI
e3nIR7hQ/d0C8ANYyB0q
=jkrs
-----END PGP SIGNATURE-----

--vCtrlpPxkwSBKUwDn0qiTc4s8pPuHJGf3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
