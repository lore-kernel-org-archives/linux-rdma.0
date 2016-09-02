From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] iw_cxgb4: call dev_put() on l2t allocation failure
Date: Fri, 2 Sep 2016 13:15:24 -0400
Message-ID: <cc8d63ca-b9b3-c62c-4e45-1efdcd870422@redhat.com>
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise@opengridcomputing.com>
 <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>
 <05141088-7c92-daba-1e0b-da1bc5656a75@redhat.com>
 <1a5401d20525$b0a52ef0$11ef8cd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HBIdO6OdDEm7ekMhQ73BK6vO2pOcV0EPe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1a5401d20525$b0a52ef0$11ef8cd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HBIdO6OdDEm7ekMhQ73BK6vO2pOcV0EPe
Content-Type: multipart/mixed; boundary="Ls9qwpm0nbsgVmrieNJaChadgdCDITxlQ";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Message-ID: <cc8d63ca-b9b3-c62c-4e45-1efdcd870422-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] iw_cxgb4: call dev_put() on l2t allocation failure
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com>
 <05141088-7c92-daba-1e0b-da1bc5656a75-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <1a5401d20525$b0a52ef0$11ef8cd0$@opengridcomputing.com>
In-Reply-To: <1a5401d20525$b0a52ef0$11ef8cd0$@opengridcomputing.com>

--Ls9qwpm0nbsgVmrieNJaChadgdCDITxlQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/2/2016 10:24 AM, Steve Wise wrote:
>>
>> On 8/29/2016 3:25 PM, Steve Wise wrote:
>>> Hey Doug, I was hoping these two could make 4.8-rc.  Particularly pat=
ch
>> 2/2.
>>>
>>> Steve.
>>>
>>>
>>
>> Hi Steve,
>>
>> You've submitted these both individually and as part of a larger nvme
>> patchset.  You should know that I generally ignore nvme patch sets (I
>> have enough stuff to review), I just happened to catch it this time.
>> Submitting these both ways is likely to cause problems down the road,
>> including getting me yelled at by Linus when the same patches come fro=
m
>> two different places.  Please try to avoid that.
>>
>> Now, in regards to these two patches, how are you wanting to proceed?
>>
>=20
> Sorry about that.  My screw up.   I should have just CCed linux-rdma an=
d you
> on the original nvme series as it progressed, instead of posting the
> iw_cxgb4 patches to linux-rdma separately.  In v4 of the nvme series, w=
hich
> CCed you and linux-rdma,  I propose that Sagi merge these through the
> nvme-fabrics.  I haven't heard back from him on that yet.   So I want t=
o
> wait until we hear from him before proceeding. =20

Your call.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Ls9qwpm0nbsgVmrieNJaChadgdCDITxlQ--

--HBIdO6OdDEm7ekMhQ73BK6vO2pOcV0EPe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXybOsAAoJELgmozMOVy/dFBwQAInFiX6hGX4ImXwOkUWrfmVA
7kApERm1snd16JnkQCmVIVEws1QrsEaydHW1KJthiCjpJcq3PFzeAwNOQZtdQMTI
bXficZYI/EOxNTAxbpC7UvrviZZgK1H9Itmy8MdBnNbw5yhZIhnkicsm4nZzd9uZ
TTwJPgB3GqtshR6UJOT5ggUwOIWhrkHyO0DxV6/M2diIgHwbfWo83r9jb4dFQT6N
XtHaKURinZiGdJTlj3U1clCDwV+PVtLfgivSuSNQ99VuxowS6/73eN08RygL5KWn
OuHdENVVaLh/VFyEvBqXtYM6x3sRwz9TM53GRd+sSxDQSrJ/fdQPQaz+3Xqn/RfT
a+mWOz6x1Ag87a7Wg0QEsNGqs/RCjUKmEbtun/RmDo1MmGRgI/vy5leE4I1mGFhE
GFN0UQzCb63BH3kluohN8Y9ZyL1YfZYbq1ZiQ65ZqSCYhhI6Ori3P4mjT9bV/3sC
SXYbncfItf9WvtI7NLwUj/7hzvYe3MRggkCp0L9Xebwym+2DvgkKLMOeaVgr/F5g
g71YjWw2S2/ymWGyXDsNy7lfWt5l0A7buqgrWT51mpCxg4r1TQiVt2j+keuIXioV
R2G9i6lL0tcN0HriRpj7Pkl31Emy2r1Mo5XU96nNtL8BUdhqPeIug6c/G8VlVPfQ
xynNzBSNhIPppyjaRE/w
=5Xkz
-----END PGP SIGNATURE-----

--HBIdO6OdDEm7ekMhQ73BK6vO2pOcV0EPe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
