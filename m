From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/security: Restrict use of the write() interface
Date: Wed, 18 May 2016 15:59:21 -0400
Message-ID: <8496b72b-c6ac-4d71-48c1-80d48991b6ca@redhat.com>
References: <02bf2ebafbc5d757c0d250d8e5fba3ebdc7393fd.1463590718.git.dledford@redhat.com>
 <20160518172012.GA6879@kroah.com>
 <c6c952ea-3562-48e1-cf56-5b8c810654f1@redhat.com>
 <CAJ3xEMi0Rg7nc7TN9Hn7=nuWmBZH1qoncKr+HuzjUP=8yMRrDA@mail.gmail.com>
 <53639dec-5d1d-58af-3022-963368c144db@redhat.com>
 <CAJ3xEMjrNUYPmxSBm6J-w+3gr6Uv60tN-Y00=o4dk1aS9yEYuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DKM98Nqxrc9LITGne3mk5PT2NXocG97PI"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMjrNUYPmxSBm6J-w+3gr6Uv60tN-Y00=o4dk1aS9yEYuA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Greg KH <greg@kroah.com>, stable@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DKM98Nqxrc9LITGne3mk5PT2NXocG97PI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 03:47 PM, Or Gerlitz wrote:
> On Wed, May 18, 2016 at 10:05 PM, Doug Ledford <dledford@redhat.com> wr=
ote:
>> On 05/18/2016 02:59 PM, Or Gerlitz wrote:
>>> On Wed, May 18, 2016 at 8:57 PM, Doug Ledford <dledford@redhat.com> w=
rote:
>>>> On 05/18/2016 01:20 PM, Greg KH wrote:
>>>
>>>>> I don't understand, is this only for 3.14.x?
>>>
>>>> Yes.
>>>
>>> Wait, any reason not to apply it on all stable kernels?
>>
>> It already is.
>=20
> Is there a special reason you didn't add the CVE number to the change-l=
og?

I didn't write the commit change log.  I used the commit change log from
the original patch that didn't fail to apply.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--DKM98Nqxrc9LITGne3mk5PT2NXocG97PI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPMmaAAoJELgmozMOVy/dVgMP/3tJX4jq0GSyG5F0cY0jYLyo
BQpkhgBOXoTb9scVylntyjq10JCbQtcqEtAPfLDDA87p0kw/Ss1AI2ajvOycY1Z1
i0XSwf/tz6hTDe4bE3Vshfg+YADLZArmwh9VBHysmUBgOxqm5xjVxLKSpD8Heu87
mcZLZn8ufWljxy+CUl11241HXjAAr98IDcJuLX5MEyIKGJGLCMW/1j5KIi+SurdE
rsv/vS8rgxvFU7RJ0kH7E1oE3l6Hoedhst0IYjb7m8Ntvtm4HFtSBVZO91d/U5dS
p0fjgzJOTgRsNoZJyFdpP5ezN2f490aOLi5bqnLmyIUQ+pYdAV6dbzhkIeGQfaA8
512HzC2I03CiDYEsqOxF3S7vBQOEIi6vymmMzpei+72KAJ1I0EX1SZHxh+Plo6qK
2lGZII0QxDPy8X20t2GNxnRrRzE0FU8La4P1YwHHZcXgWACQYbmFtHBjg/5wrt4t
cVy+2jKxr4E1YNNBFAkMvNqDSG6aMdVpd1f81WaEvRciDF6dHG6drvxGW6ckpsxO
LrjVRy0rByUm/pgSc7shqY2UK1LC965jCEtV5R0oD5rs6tw/tifl8VntR+Nie0hh
vIFEkyOgdOj5qVoqeNq+V75CvoM3lWSGt6sxKZHNN2q+yKAip+IxjUqyDTkuwEkK
QSmWnwfKQ8ykzsn2zjqW
=SyAE
-----END PGP SIGNATURE-----

--DKM98Nqxrc9LITGne3mk5PT2NXocG97PI--
