From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 3 Sep 2015 16:29:45 -0400
Message-ID: <55E8ADB9.4090900@redhat.com>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <55BA531E.6060403@sandisk.com> <20150730200907.GA3487@yuval-lab>
 <55BAD76A.1070700@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kav42nbRIFEiNFBCdcRGSj2F8lfbx9Q7v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BAD76A.1070700-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kav42nbRIFEiNFBCdcRGSj2F8lfbx9Q7v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 10:03 PM, Bart Van Assche wrote:
> On 07/30/15 13:09, Yuval Shaia wrote:
>> On Thu, Jul 30, 2015 at 09:38:54AM -0700, Bart Van Assche wrote:
>>> On 07/30/2015 04:46 AM, Yuval Shaia wrote:
>>>>   struct ipoib_cm_data {
>>>>       __be32 qpn; /* High byte MUST be ignored on receive */
>>>>       __be32 mtu;
>>>> +    __be16 sig; /* must be IPOIB_CM_PROTO_SIG */
>>>> +    __be16 caps; /* 4 bits proto ver and 12 bits capabilities */
>>>>   };
>>>
>>> This patch modifies the private login data format that has been
>>> standardized by the IETF in RFC 4755. Has this modification already
>>> been discussed with the IETF ?
>>>
>> Yes.
>=20
> Hello Yuval,
>=20
> It should have been mentioned in the patch description that this patch
> modifies the wire format, how it modifies the wire format, and also
> which feedback (if any) has been received so far from the IETF.

There hasn't been any follow up on this patch in the last month.  Yuval,
is there still progress being made?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--kav42nbRIFEiNFBCdcRGSj2F8lfbx9Q7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6K25AAoJELgmozMOVy/driYP/1DLQyJUlwHTt17ANJ2QF9bf
4oun4fykjI5Nt9K1l60TchlFVDyQW3EgMZxa/TKdKpvbNgBtWrColk0ZDZmKyem7
wQ8EuIGT2RRFQCXVLwyeMzNcZp2N6ApxyNu4MDKTbGespo0DlE6K8iD2ss1XMEiU
dWMmI8HVyu+RNSAm7qCoP2ZzmZAROD/ylOAhrzuB56Z342fVoQ50yB5JcET/G5Nt
PGv03qjkx1KHLOniXWjcNSDzdXajdTVH2i8UtRy49jsHY+L02tr6W090IgnZSdPS
pMkKGUENbxJH9xI8NPvj6NcYZkvh+7G1py7KnV/LdjHYo/kFG3Kf6hnhOjD3jCUE
i+0r/6cJhQjia4skHeLBoZCzVwG6TrCC87O8taG6lmDuphR/Q6RARWKPg8qb6hIv
on8uc+zQC1ZgS0xHrX96CO06J82qp3/yXIwG+UDYCAcjWbMrjvoILVA707r4+/2V
xK4HiBePTze+Z07b5l4gbqCdKMSRmxgShy+ZqmcHJUM7y4iO9GU9lH72cnO9bTaf
3WLre5jecbVgs5PMg50MXSdv5a2e43hzAu1b8yKODKHbA/PT9O0DQgaIzMN0S81S
rdOiwhENV0fy9fzsoR2we9+Ira2ZGflSxVsKg1PD1sSqSZTS+WHdv5wvE/FN3vKj
WerGmMXnhKNttr5BIq2T
=zjWB
-----END PGP SIGNATURE-----

--kav42nbRIFEiNFBCdcRGSj2F8lfbx9Q7v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
