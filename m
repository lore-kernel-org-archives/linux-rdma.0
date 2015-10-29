From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 10:42:34 -0400
Message-ID: <5632305A.6050800@redhat.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
 <56262676.7000403@dev.mellanox.co.il> <563185AC.10804@redhat.com>
 <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
 <56322A41.9050004@redhat.com> <56322E39.6020602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OhaBSn2s9UgELOV4gQ6qaMUE6bv3SK8Rr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56322E39.6020602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OhaBSn2s9UgELOV4gQ6qaMUE6bv3SK8Rr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 10:33 AM, Sagi Grimberg wrote:
>=20
>=20
> On 29/10/2015 16:16, Doug Ledford wrote:
>> On 10/29/2015 01:42 AM, Or Gerlitz wrote:
>>> On Thu, Oct 29, 2015 at 4:34 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>> Yes, I've pulled this in for 4.4.  Thanks!
>>>
>>> Doug, we want to run regression over the 4.4 bits, when do you expect=

>>> for them to show up @ your kernel.org tree?
>>
>> Sorry, when the fast registration API caused compile failure yesterday=
 I
>> stopped at it and forgot to push the result out.  So, I've removed the=

>> last patch of that series so it resolves the build breakage for now.  =
We
>> can add the last patch back in after the staging drivers are fixed up.=

>> The result has been pushed to both github and k.o.
>=20
> I can provide a patch for hfi, anything else needed?

It breaks all of them in staging, not just hgi1.  So, hfi1, amso1100,
ipath, and ehca.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--OhaBSn2s9UgELOV4gQ6qaMUE6bv3SK8Rr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMjBaAAoJELgmozMOVy/d88wP/RkRbV3z5Ys/WTwOfl/8iDvN
R8Y5ESH5DCwCenEUWh7pJJYAF6hUaxUdCo0PZOzUhlg8Z8y60ETEZ6kgVABv5Rch
X9Y4I3fInnoQAfyrvXxbV39VTNtn8OD8PK/RvnNLppt92bIgLZlKjQKFbhyx/Afd
WcUTIg/eHJx269af5rBzbHIReDh7lh+zH5w/kxLNfZUVOS93cTm4RWOccCr2Id4A
8EmrVAiuxenpRRNRF+set+ft2+b7xO2gKLKy/eXKprPnGQUeioMvYnkKIjuTDOBz
oNaHGf3sec8A4S87KSND4lXrTwIim+gjFRNCFe0HHGdT3Dimo/dzSDatUeU4l7ko
XYAhm3v2i5WKM5kGjDG8gt8ryW/9eC3LeAZ3nPcqahLDVge4Mjvive6s5PtPRtG0
uZnJ92jPpfeC0CP8r+r/qMtcl1ESuCujf8O+N8L5gY0gMWG1WrmorgaYfto/9Ytt
m3xSpnlfHhdlI/QMNPn0OQHIlXdmfSPEyTZ1g/Pdpl0mjuhXocK/OQXqEPjp28cl
GvjstnpMQDzvbVQkYZjTElnr2BpTRSSseyqcvDH+mZPPdFcF8xfsiDqkcLAwa171
6mS2BVP9FwWajWwRxkKf9Ub+j7+9103fKXfZXyHMYNYbgQ1HdUKJXbjHM3i2Sc2k
Z0w3UMl2YV34j1PSj8o3
=itVP
-----END PGP SIGNATURE-----

--OhaBSn2s9UgELOV4gQ6qaMUE6bv3SK8Rr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
