From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] iw_cxgb3/4 bug fixes
Date: Thu, 28 Apr 2016 10:25:13 -0400
Message-ID: <57221D49.7050406@redhat.com>
References: <20160412143035.3B08CE08CA@smtp.ogc.us>
 <00af01d19b27$f2ed8fe0$d8c8afa0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wacQAapbkNQ13nU1dNEBv5F6CcWMQKat6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00af01d19b27$f2ed8fe0$d8c8afa0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wacQAapbkNQ13nU1dNEBv5F6CcWMQKat6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/20/2016 01:13 PM, Steve Wise wrote:
>>
>> Here are three important bug fixes that I recommend get pulled into
>> 4.6-rc.
>>
>> Steve Wise (3):
>>   iw_cxgb4: initialize ibdev.iwcm->ifname for port mapping
>>   iw_cxgb3: initialize ibdev.iwcm->ifname for port mapping
>>   iw_cxgb4: handing draining an idle qp
>>
>>  drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 ++
>>  drivers/infiniband/hw/cxgb4/provider.c      |  2 ++
>>  drivers/infiniband/hw/cxgb4/qp.c            | 18 ++++++++++++++++--
>>  3 files changed, 20 insertions(+), 2 deletions(-)
>>
>=20
> Hey Doug, Will you pull these in for 4.6-rc?

I did, yes.  Thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wacQAapbkNQ13nU1dNEBv5F6CcWMQKat6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIh1JAAoJELgmozMOVy/dHv0P/2IUb1nuWMvTLegOCXPwK/vf
R5vdwnjvbtsdoOs8Gw8MJZqiXQqIIyVe205ThmzzngZ/gMGktybqkLJxm/6IcqEm
Rca38dcO7SLyD+/56sGCZAQMQ09XCay4GhQYOYh4o039hFd/C1LefAEyKUaDcR9E
D3kwzbyO9NaolKhMKix+hXltZM95fuo6h6pes+7nFBY9O338B6qeqzAEaC3ONJkD
n4+mgtfJAdNzsmbTCGaiCjw4yjZNYkr+NlC5Itgb+WHxFVU/lcLi3tPXfi6HYXvN
RSrPEZ8bYbHPlxfFytI4V05xjCdXNAnM+EwJo+g2FbFqb3ATdNx+vdWBIorm4h78
dzHib/Ah9AHxd4Dzs3DX4UzHgLuyR5gGV5NYRD2FUEUa3DqupmKmeSDM2TtuGfr7
MNiqNOCVJ43qTtBxiLG8zycAkdALqOTBWJ7pKlJWwcQoXwJBfhbQQSIP+7oDa4hv
u/My0VZbjLcN9V054hFOuBDd8jsGQy6CFXP8uP+NiLBpXCuT1nGCF1Mfv7jkp3G4
7wjTsiERABxv7+c9J67ofXbxy0gKjDiIv24O/n3PGvT2CMP2T0XrXeP/kutThcA+
F0QfSGhJSnAgvI6hwjYANpk49V0gYM4qk+lbtNuAGRtvuTljO8A4i7awR1JT4Qmq
w/A+EnqyzcVHAHylv8Lq
=/86h
-----END PGP SIGNATURE-----

--wacQAapbkNQ13nU1dNEBv5F6CcWMQKat6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
