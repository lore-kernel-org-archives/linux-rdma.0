From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] ibverbs: Allow vendor data response in
 create_ah command
Date: Thu, 1 Dec 2016 22:30:12 -0500
Message-ID: <4863b845-0043-4e4a-6b32-dfc9e114fe76@redhat.com>
References: <1480602353-8600-1-git-send-email-yishaih@mellanox.com>
 <1480602353-8600-2-git-send-email-yishaih@mellanox.com>
 <20161201160058.GA22216@obsidianresearch.com>
 <c9eb6ee8-e3ca-a540-82f5-0b3580b00c78@dev.mellanox.co.il>
 <20161201164056.GB24190@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3I7tBCjLPcqDUK7XvLKVOUs2Kcjil80Wb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161201164056.GB24190-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3I7tBCjLPcqDUK7XvLKVOUs2Kcjil80Wb
Content-Type: multipart/mixed; boundary="jR58Vpx2aEeNNUT50JxGSn5DLQRUEgGe9";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <4863b845-0043-4e4a-6b32-dfc9e114fe76-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] ibverbs: Allow vendor data response in
 create_ah command
References: <1480602353-8600-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <1480602353-8600-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <20161201160058.GA22216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <c9eb6ee8-e3ca-a540-82f5-0b3580b00c78-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
 <20161201164056.GB24190-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161201164056.GB24190-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--jR58Vpx2aEeNNUT50JxGSn5DLQRUEgGe9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/1/2016 11:40 AM, Jason Gunthorpe wrote:
> On Thu, Dec 01, 2016 at 06:30:05PM +0200, Yishai Hadas wrote:
>>>> int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
>>>> -		      struct ibv_ah_attr *attr)
>>>> +		      struct ibv_ah_attr *attr,
>>>> +		      struct ibv_create_ah_resp *resp,
>>>> +		      size_t resp_size)
>>>
>>> NAK without changing the name of this function..
>>>
>>> We need to decide if we want to have comapt for ibv_cmd_ driver facin=
g
>>> entry points, or discard that idea now that we only have one tree.
>>
>> The idea was that moving to one tree can drop the need to maintain 2
>> different symbols, all vendors around where changed to use the new com=
mand.
>> As this API is not used directly by an applications I don't see a real=
 need
>> for 2 APIs.

Agreed.

> I'm fine with that, but we still need to change the dynamic link
> symbol name when the signature is changed to ensure dynamlic linking
> of wrong providers fails.

Right.

> This might just be as simple as moving ibv_cmd_create_ah from
> IBVERBS_1.0 to IBVERBS_1.4 in the .map file. Please test and confirm.

I'm pretty positive a symbol version change should be sufficient, but I
agree a test to confirm can't hurt.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jR58Vpx2aEeNNUT50JxGSn5DLQRUEgGe9--

--3I7tBCjLPcqDUK7XvLKVOUs2Kcjil80Wb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYQOrEAAoJELgmozMOVy/dU/EP/AyANiiDAPtSvNygremzj0gh
RkSaT+YwXHSUPNpz7HLsDBSaFGh5REJXcvh4PePFCVMupEs//CHMkTgGEBq/CvZi
ow9IjO3od+0L/XGEMbyMM9JnrOs1fZ9x1LnlofQBNfZsg509iiwVS7riLnKLoa9l
89M8fsZpbLvYuSdWolx7l0UaGNlmzcPetnHv4AcLaXLInU1EQEDHH8rlFOj6/dJ1
mD2WpOTtL/NM8eWdJ2KYo6AVfKTeI5cH4KvY+FVHkZsyM06rgjffN5QDa1Ytvt35
vjrjYEKEUe9c3uMxaTlzKueD3Ch7hnyq4OM9EyF2OLwPP9Kx8eJXe5QTG69dFIRx
dUEL1qkMf7JaLBWNau1Oqcz0alz+8z/E4cTjVEdimivu7IEbs07NzALvEtwPcA+Z
0iLxhQK49gMR5uNmWBULzXiAT/0WNObbuAtwJn54VIm2qs02DBO4F03rOONsjaMo
g3uc799VioukxeYZSYa1vTKULrwlBMbHwWUxL+wEBbLc/vJTNfsesqGQkMcwlr/F
h7vNvCBihiykGjTWv9qJddizrvt1wbfska8M97SydPdOuqsd08o9wjuB58TZQPwq
ibDEQYq11CAD3kL0ARBzHv08YX5z92C0LjOCN6id/6JK2XzMqd9H+DRIJia9MnGT
kgcTzkI00h9do2Jz2xAa
=TZSk
-----END PGP SIGNATURE-----

--3I7tBCjLPcqDUK7XvLKVOUs2Kcjil80Wb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
