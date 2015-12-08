From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 8 Dec 2015 13:18:13 -0500
Message-ID: <56671EE5.3010209@redhat.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <5641C8BC.40507@dev.mellanox.co.il> <20151203142730.GA20520@infradead.org>
 <56605AB7.3000705@dev.mellanox.co.il> <20151208170139.GA425@infradead.org>
 <56671A31.7090401@redhat.com> <56671DAC.7060001@dev.mellanox.co.il>
 <56671EB8.6010207@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aLHfUmcBoNvmceNng0X02eBeiS548cC1M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56671EB8.6010207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aLHfUmcBoNvmceNng0X02eBeiS548cC1M
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 01:17 PM, Doug Ledford wrote:
> On 12/08/2015 01:13 PM, Sagi Grimberg wrote:
>>
>>> I've pulled these in.  Both of them failed to apply, and the first on=
e
>>> was just flat baffling in terms of how Sagi is working from a source
>>> base so different than the one in the upstream kernel.  They should b=
e
>>> double checked just to make sure I'm not missing something since they=

>>> were so far off from applying to an upstream kernel.
>>
>> Hi Doug,
>>
>> I mentioned this in v1. This patch set is applied over Christoph's
>> device attributes patch. Will it go in as well?
>=20
> No, that's too big and not the right sort of fix for 4.4-rc.  I had it
> on my radar for getting into for-next.  So, it'll have to be fixed up t=
o
> apply over the top of your patches which will already be applied.

BTW, it's already pushed out, you can look at it now.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--aLHfUmcBoNvmceNng0X02eBeiS548cC1M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZx7lAAoJELgmozMOVy/d1lMQAIUPJficQASXBGPo1rudSuZj
AhqbHk12dYv/uvvrq3iioEUtpw5OzYib04gbPCuU/BiWctvAOATTemxg3LjTiyLL
YHl21AGKrHbF77PlTdno0X8pgIR5h648JSjGNY6AGfytR+VmhM1Bxjk6E3MByVMV
TVHmIY49qQycOWBDLSLYZMCdnL5eEfnsF9wJpWNZzcE55arzyKLyqjIynS2M1A2M
QZ0jbqnWy6FGY49aMGyTm1gR/Ikk5xPMx3x65H5IqZeKWDnbWBH/LucXZpWW4ZIY
97dear5hAjBZXTsPXf6hlAuuSoOXt3YJZQ77pi29QWtnm3dThVqRRitz+5OhzbW3
TrUdTd4miRmBE6NldMkaDUeDhlpCzMe48qdL14RHeynf9Di5jgWcKFU/vFYZQyXm
tWgXNX1cJFUOlb62Mb2k4BOxCaHS149d5h9dwIhAd0HgBc8LIALW+wb6JsmrgJds
Nr9x3ea1wWpOyMZz+Qo2LpwicnrqPKNDwiglFDQ8HYohJKwogWvyUxpfo/ILOGt4
Sv1KbjjhjS9YCad1jrw1Iybhpxk/pX6I9W3Y4i7Wp9uhXJ6Y3ioKlNr9dB3MIY1b
CD3EzLalk74YOqE87Gc7KiUNcNU710l3k60mu6oa7uRwO5HcqaTcbxxXvHHicBE8
2fROX17pTAXLt737wm4E
=4zcO
-----END PGP SIGNATURE-----

--aLHfUmcBoNvmceNng0X02eBeiS548cC1M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
