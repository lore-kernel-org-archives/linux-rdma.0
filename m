From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] IB/cma: Use inner P_Key to determine netdev
Date: Tue, 20 Oct 2015 16:46:18 -0400
Message-ID: <5626A81A.6010605@redhat.com>
References: <1445323981-28582-1-git-send-email-haggaie@mellanox.com>
 <5625EB59.4020304@redhat.com> <5625FCD8.8080807@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xRjD5QCrX4QS2vivHkHI5NMhT0XxVfoF9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5625FCD8.8080807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xRjD5QCrX4QS2vivHkHI5NMhT0XxVfoF9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 04:35 AM, Haggai Eran wrote:
> On 20/10/2015 10:20, Doug Ledford wrote:
>> On 10/20/2015 02:53 AM, Haggai Eran wrote:
>>> When discussing the patches to demux ids in rdma_cm instead of ib_cm,=
 it
>>> was decided that it is best to use the P_Key value in the packet head=
ers.
>>> However, the mlx5 and ipath drivers are currently unable to send corr=
ect
>>> P_Key values in GMP headers. They always send using a single P_Key th=
at is
>>> set during the GSI QP initialization.
>>>
>>> Change the rdma_cm code to look at the P_Key value that is part of th=
e
>>> packet payload as a workaround. Once the drivers are fixed this patch=
 can
>>> be reverted.
>>>
>>> Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
>>> RDMA CM")
>>> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>> Changes from v0:
>>> - improve commit message
>>>
>>>  drivers/infiniband/core/cma.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
>>> index 59a2dafc8c57..e8324543e085 100644
>>> --- a/drivers/infiniband/core/cma.c
>>> +++ b/drivers/infiniband/core/cma.c
>>> @@ -1067,14 +1067,14 @@ static int cma_save_req_info(const struct ib_=
cm_event *ib_event,
>>>  		       sizeof(req->local_gid));
>>>  		req->has_gid	=3D true;
>>>  		req->service_id	=3D req_param->primary_path->service_id;
>>> -		req->pkey	=3D req_param->bth_pkey;
>>> +		req->pkey	=3D be16_to_cpu(req_param->primary_path->pkey);
>>>  		break;
>>>  	case IB_CM_SIDR_REQ_RECEIVED:
>>>  		req->device	=3D sidr_param->listen_id->device;
>>>  		req->port	=3D sidr_param->port;
>>>  		req->has_gid	=3D false;
>>>  		req->service_id	=3D sidr_param->service_id;
>>> -		req->pkey	=3D sidr_param->bth_pkey;
>>> +		req->pkey	=3D sidr_param->pkey;
>>>  		break;
>>>  	default:
>>>  		return -EINVAL;
>>>
>>
>> And, to be clear, you are looking for this to be part of 4.3-rc update=
s,
>> yes?
>=20
> Yes, the issue was introduced in 4.3 in my cma demux patch.

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xRjD5QCrX4QS2vivHkHI5NMhT0XxVfoF9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJqgaAAoJELgmozMOVy/dSUMQAKO4DwJ+3onp8L4wXzTREh4X
250G0P99MeoSOLXbcFvX3yGVeif4NHuoOPSx0quF5iQ46ya3Woo8zVcKUz+yjctg
Hv9Guq+Pf5+H6qrpXmjGNTzKBxytlGOcGhfee6pT6zqwJdJ9w5rDmmp4zOppHnbp
ZKozTmNhoL3OmoymchM4kPoRGzWaL+T/FSAGJJu+3p1UcgP2IKl6ufi5RWifAAWf
12qUvX3b0whlTt5ZxYA30kQ9n+9osvPMew2y1zzScmVtLXIEzBHgksdvd4kroO77
4chDMPmuX/YsTJ7SFl/hy5dyqPcCLo27rDZNBqkCZt581RF2CzfR8mjagx/XKl/Y
3TjA2DnNq13tDjVthFDvKFB544b/9FRnGhdssysId9Yi7y1Jo985VkWwYk1JHjhw
/i6QYXhzpGPEiAUZMxNqdPo3Y+7ZeBW8mBnplSypqS+DHRleczuTPsuZPrGe9nxU
i5tLqaCYJdWhEP0bjOT36OogrIFusALh6kcJwY5x3i3lLXlipTBnOJK2SprIeFHb
krKknksn8jkqRm/DGcE5f+L+wZHa/WehCn7ks9vl7+HqwNegzYVrvxjBJgBU6fOw
6vzma/xM69KWs5ZF+oCUvCl8poF8s7n5E9qp1QhY1/YvfHFsJIVTA+HoeDNhRL3p
68CeYzu2lsDYoibFylL8
=at8C
-----END PGP SIGNATURE-----

--xRjD5QCrX4QS2vivHkHI5NMhT0XxVfoF9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
