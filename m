From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: cmake minimum version issue on RH 6.5
Date: Sun, 2 Oct 2016 09:14:16 -0400
Message-ID: <9df240d0-0d57-0283-c3f9-d500d8e6e999@redhat.com>
References: <5169a490-10b4-cb9f-d7b7-fb552692f1f6@dev.mellanox.co.il>
 <57ED2E87.50008@redhat.com> <20160929164653.GC774@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bopjsNK1V1gcOqs8H8lkFCXh17WnN2CNX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160929164653.GC774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bopjsNK1V1gcOqs8H8lkFCXh17WnN2CNX
Content-Type: multipart/mixed; boundary="SQSR4dfGMe3AqiVQT1Gjk6PKiEleHi9Gx";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <9df240d0-0d57-0283-c3f9-d500d8e6e999-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: cmake minimum version issue on RH 6.5
References: <5169a490-10b4-cb9f-d7b7-fb552692f1f6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
 <57ED2E87.50008-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20160929164653.GC774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160929164653.GC774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--SQSR4dfGMe3AqiVQT1Gjk6PKiEleHi9Gx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/29/2016 12:46 PM, Jason Gunthorpe wrote:
> On Thu, Sep 29, 2016 at 11:08:55AM -0400, Doug Ledford wrote:


>> Is anyone really running 6.5?  I mean the current version in the 6
>> family is 6.8, and there are significant improvements between 6.5 and =
6.8.
>=20
> Indeed, I did my testing on CentOS 6.8 and everything is fine. I
> expect that RHEL6.8 has the same cmake version.
>=20
> Simple Options:
> - Upgrade to 6.8 and forget about 6.5, it is years old and deficient
>   on security updates at this point?

I have no interest in trying to support 6.5.  It's older than dirt.

> - Do your build on 6.8, the resulting binary should still work on 6.5?

I think is an acceptable workaround that allows us to not support 6.5
directly as it can be indirectly supported.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--SQSR4dfGMe3AqiVQT1Gjk6PKiEleHi9Gx--

--bopjsNK1V1gcOqs8H8lkFCXh17WnN2CNX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8QgpAAoJELgmozMOVy/d7QQP/1DgC9xsOz5RtKxEaGWOZZjB
eOcHRtOxSIpZEYYWLTXE8G0KaGX0sHcz3JjyblLYizLd2To3fi5WeOfwaWXhdXli
Is2AKh+E30vrslwJvmUOQdZJP8EQNEbp2OcNx85za824cABI844v9HicUH7LLnJy
8W76pHqVnKprzKyS/HIstNRr0eP6Qz7AAd4436eHIQFI2/9qqz64lv4ilUEnzRny
hhl/4TpPuY1/pn8QrdgnJryE0KFBSOQFDsAti61KRUBY1UUrWn7Nre/9KI1qixal
6v6kIkZgLQF6kSte4HkTWVlhV57AGP4xCDutY3i9YB5DvE0W35GOHLuG2mZZzm2R
AOB94bs77LGUt7w8nEgUr+qPILnDAsoSr9MHtMgNwPBnC8E9+lnPN8Xe2P4FTJbj
Pz3kP6IDOSf0fdR79Ac+32UsfIF2DzGI/G7fDyvIA3xezZakBoaCKWKYSSrWvvr6
XxSgdzXKVh1G/8D5l71koG4a+hA2su8bbwFeidZdCvMG1rntdUbXSNifqeyKlBkg
+trrzpRH1y/q4I2H2QZgdZ27qGAYiJ4uaqJZrS4w2zI0lSQdjhZg4AuFlExukqf/
1F+AVzD68ld5lwrZHNu8IuqMu3KA1RR5AAtlXGBOCa+HYG8HkPWuFJUeyFW+nwNJ
QgsZoRtsDnrbTRDPVOE7
=Ep/j
-----END PGP SIGNATURE-----

--bopjsNK1V1gcOqs8H8lkFCXh17WnN2CNX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
