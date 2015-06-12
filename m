From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/3] IB/ipath: add counting for MTRR
Date: Thu, 11 Jun 2015 23:36:42 -0400
Message-ID: <557A53CA.8030607@redhat.com>
References: <1434045002-31575-1-git-send-email-mcgrof@do-not-panic.com> <1434045002-31575-3-git-send-email-mcgrof@do-not-panic.com> <20150611195424.GG30391@pd.tnic>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611195424.GG30391-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 03:54 PM, Borislav Petkov wrote:
> On Thu, Jun 11, 2015 at 10:50:01AM -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
>>
>> There is no good reason not to, we eventually delete it as well.
>>
>> Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
>> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Suresh Siddha <sbsiddha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
>> Cc: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
>> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> Cc: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Antonino Daplas <adaplas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>
>> Cc: Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
>> Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Luis R. Rodriguez <mcgrof-IBi9RG/b67k@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/i=
nfiniband/hw/ipath/ipath_wc_x86_64.c
>> index 4ad0b93..70c1f3a 100644
>> --- a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
>> +++ b/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
>> @@ -127,7 +127,7 @@ int ipath_enable_wc(struct ipath_devdata *dd)
>>  			   "(addr %llx, len=3D0x%llx)\n",
>>  			   (unsigned long long) pioaddr,
>>  			   (unsigned long long) piolen);
>> -		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
>> +		cookie =3D mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 1);
>>  		if (cookie < 0) {
>>  			{
>>  				dev_info(&dd->pcidev->dev,
>> --
>=20
> Doug, ack?
>=20

Ack.



--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVelPLAAoJELgmozMOVy/dhN4P+wSfNLyRQ9hda9uQfjQS5eDK
VrFc32VnqudghW4diOrN2mi3yOFZ6bD0MVoM4LlBCRxdTB6tFt8o6mmfIMZhzQnr
SO2P3taBPJHyPJJ4n8IggNdbsZJzrws9TU5PxlSFGrq6qEG25w/fCCwxYUocpZlS
3Ux3lLj/5LcJxiukiEVOwH9aUS/LyzCoQK5m6aqB+bGpQGZN+ypM6Xv6aWElFHCt
1CXI02toYztImpoliozpr+OS/pkXFlopct774ckw0w/DlqgDgU/H2QbRadDPIaDy
iuifQB1scnFvoxfzR6ZstPkQfAKcoKJM+s1TOAjUP4YzcOd1jBJ7QXDRa0AcaTrG
TaA/Xu08uUrteUolmV85o3bnxGBIjrbLThNkiIsmlA70kTVoSctxskpiIQ+qeyV0
PrrWfHIGS9scFwLz+YcxHc98g9891u6cS4OLy+R8ovQu7osGGshgaCmMB2pRXx1H
fT4h238bFbF9/tCLy7XcWxA5QzaKnzNH/zzNi8JE1cgzrD7QJceJ4KGwtCnZXD/a
lGF/0SnctcQo3FVJYkifn9lL28iyKRPuADxnsCDDD5k3AmvvzDuOjX6VSrUqkD0m
yGEuVIGUph2uyMg27GserInmgvoN2+hnQt0hd0DVobOOuTU2g+XImgc1cPsaE4KZ
xVmBwq+6mVMXYItcFLyC
=hDOz
-----END PGP SIGNATURE-----

--TjKokMuvLWFTs6vss1j9T2rV73fUmrJvX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
