From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ocrdma failure in 4.4.0-rc5
Date: Wed, 23 Dec 2015 14:22:40 -0500
Message-ID: <567AF480.7040307@redhat.com>
References: <5675BA00.5060101@redhat.com>
 <CANjDDBiJAyfS7wFr9yYs7fAnn1-h9t1JH9s1LDf-Q8RYk=Ayyw@mail.gmail.com>
 <567AE0E8.70107@redhat.com>
 <CANjDDBibF9eR-uumY3rzckeDfDE6CfBQsAAdkZVWAitdviW2FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nDkAb9KXDn96hPiG3AsK4X4wE0cbkr8tS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBibF9eR-uumY3rzckeDfDE6CfBQsAAdkZVWAitdviW2FQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nDkAb9KXDn96hPiG3AsK4X4wE0cbkr8tS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 01:53 PM, Devesh Sharma wrote:
> Hi Dough,
>=20
> I was all set to send you an update in my morning tomorrow. Let me
> give you a brief update here
>=20
> The deadlock is caused being caused due to following two facts:
> A. be2net is sending open/close event to ocrdma holding
> device_list_mutex. Nic Open/close hooks are called under rtnl lock
> from user-space.
> B. As per ocrdma intialization logic ib_register_device() is called
> under device_list_mutex. On the other hand inside
> ib_register_device(), GID table initialization logic tries to acquire
> rtln-lock to fill some of the table attributes.
>=20
> My patch series to fix this issue is already under testing. After 1
> round of internal reivew I should be able to post the series in a day
> or two.

Ok.  This is a serious enough issue I really want it for 4.4-rc, so the
sooner the better ;-)

Thanks for the update.

> -Regards
> Devesh
>=20
>=20
> On Wed, Dec 23, 2015 at 11:29 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> On 12/20/2015 11:29 PM, Devesh Sharma wrote:
>>> Hi Dough,
>>>
>>> Thanks for your note.
>>>
>>> We will root cause the issue asap and get back to you with the fix.
>>
>> Ping.  Any update?
>>
>>> -Regards
>>> Devesh
>>>
>>> On Sun, Dec 20, 2015 at 1:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>>>> Hi Devesh,
>>>>
>>>> Testing 4.4.0-rc5, the ocrdma driver is failing for me (100% reliabl=
y).
>>>>  If you have vlans off of the main device, this is what I get from t=
he
>>>> Fedora rawhide 4.4.0-rc5 kernel:
>>>>
>>>>
>>>> --
>>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>               GPG KeyID: 0E572FDD
>>>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nDkAb9KXDn96hPiG3AsK4X4wE0cbkr8tS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWevSAAAoJELgmozMOVy/dGogP/jjvYKZ+lTIZ+e1iUyi8pQqp
lueLXF3ckhZo6yB3FnAdy3ETCpu8ywfGwK6ZK0vMOmLcC40k3yHmi0bQltZuhgDq
Cr5cGAoCIrfpAr7DAuB1OW/cX3DpqF4C2oWMtRudEhw1w7ZyIUANhmJXquoIK+nO
ghiyiCxGBoORFFOBPJYdfodkSgIBu1yU2vaV2XxH5eYpsKVkJG5nXHe/64oyBZPY
rvesu2ZqNtpkYYgeH7pbZV8DWZOQQhGviZeXa6lNw0e4vbEjNHgNK2LsWNs6N1nx
vnBq6oxDCL4RHgN/atkXY/R7IZqjUuICQM7bEChq6YZ+vmh3mAIyPzXJAonjyARG
oiXNaC4uTKxaGNVTnI21Ny7o4QgUgD89HaS+Z8bs48LxEm64Cn5jzx+SWZvtpmkO
mqbiFmpeEMZqlIKnlnoHnsrQEfsL6SSG4bpsbP+oL41e0Zv0/vm3oMC+DSMn6UB7
+JlqgY+R0AMzheG+KyXqFXX9xaPNTS6iX3i5KamcMUOO+blLQvaSf1nRc9F7Foh9
0x4tKvO5ri15JUm/cvhXeHq1WD8dWoS4q519iED6F4A1yIi1ffLS++SmMb8W1Qeq
aRjN9WmT+z1cQAcPnae53bChg05WbRUxghA6r8XfmmnXp8v+8yQTE9rxGT2uq2Tp
Ki+3kxoBtWtz2aC+/097
=3t8a
-----END PGP SIGNATURE-----

--nDkAb9KXDn96hPiG3AsK4X4wE0cbkr8tS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
