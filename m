From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow steering
Date: Mon, 16 May 2016 13:44:03 -0400
Message-ID: <c85a22ae-359a-ca51-d29f-14df464c97fd@redhat.com>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
 <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
 <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
 <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org>
 <2994c976-8ed1-75f9-7534-2d0e5f5303b8@redhat.com>
 <alpine.DEB.2.20.1605161123170.26453@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bs2grsVC1JkwAvKeHIQs90qamjWBqBxpp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605161123170.26453-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bs2grsVC1JkwAvKeHIQs90qamjWBqBxpp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 12:28 PM, Christoph Lameter wrote:
> On Mon, 16 May 2016, Doug Ledford wrote:
>=20
>>> CAP_NET_RAW is sufficient for tcpdump and this is not more than that.=

>>
>>
>> That's not true.  In order to set promisc on an interface, tcpdump cal=
ls
>> ioctl with SIOCSIFFLAGS as the ioctl and IFF_PROMISC set in the flags,=

>> and in net/core/dev_ioctl.c we see this check for SIOCSIFFLAGS:
>=20
> Tcpdump works fine without promiscuous mode. DONT_TRAP does not
> mean that the interface is switched into promiscuous mode. It just mean=
s
> that all traffic accepted by the hardware is also going to the QP
> specified.

You're right, I was thinking about snooping as being more than just what
it is here.

> One can switch the interface into promiscuous mode in addition if one
> wants that. Then you need CAP_NET_ADMIN.
>=20
>=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Bs2grsVC1JkwAvKeHIQs90qamjWBqBxpp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOgbjAAoJELgmozMOVy/doqsP/jTxjolnuE6vPY63ZN5zCnse
tpHHtFQ8nlQgLzuVNfvSgehU7RgaClkHXYivj+JPQAcE9b6Xo60J1ysHmKTDf7jK
we03A7NTXA/ofTWfD6f4r+hEYxSAaO+7PxTreCPJn1dfytrbgJT59sSeu+SI/vfW
/Xm14rQo61a7GT8wFPqHSwR+XvJNl7EuXiRCaAI20DAnQncl4cwI7UiFgk9wt3Xe
dYkA7Bv9QiIZ0jM/6EGX3Y7Yxy/3acCt2IayI0M4Ba54D6106wyqcaAHEZZowptk
yiLdvATHfdvzHrmS2DV+9R14LLplcloSdtV2oYpI2+Vn8jdG/u/g7ozTZitk3MGQ
MSbiztqSvtCZ3M5i0R3eiZRl7X3hqKGSxAxb514/JuVNUfp/k2cqbrBb7nbjkign
TnrcVpiUokLfmn/5Kv0nrC6kln0sdklBKjnFL+eSRpyLJ6lQwfMeV7BrGf9wjUeE
Ku30mNkqh65Tdw7Cby+bpxF5qtPYJx0hKlubTEgUQ4u/91Azfwzg6dQZtFCDt1Jx
fXTRNvaI3o3FyKEBGBPzJkdlLymXnmO3G7hmzgxys09ZlbVmY4lBJ6aQSe+32TEA
OYVS/6r2Gq/4zV5ISNu8CWZhImuIho5ADLLnk0EUBk2OsyRrL8NM/LuoIwSKvgkA
lwwGCv3E/wghexORDmIz
=q4Bu
-----END PGP SIGNATURE-----

--Bs2grsVC1JkwAvKeHIQs90qamjWBqBxpp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
