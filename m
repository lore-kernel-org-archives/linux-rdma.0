From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Tue, 19 Jan 2016 13:44:18 -0500
Message-ID: <569E8402.2080001@redhat.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
 <00d301d14d69$18257d70$48707850$@opengridcomputing.com>
 <CAAKD3BAWUfg6sVLCEtb-vBrC9kGtVYO784xg4_tGqiZaOVh-2Q@mail.gmail.com>
 <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com>
 <56974AEE.6060201@mellanox.com>
 <004401d14edb$65c6b260$31541720$@opengridcomputing.com>
 <5697B80E.5090903@mellanox.com> <20160114174014.GA30615@leon.nu>
 <56994CE2.1060205@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JkF8CxCS7RMLAc8duSU4TR3tMeR6lLRJd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56994CE2.1060205-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JkF8CxCS7RMLAc8duSU4TR3tMeR6lLRJd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/15/2016 02:47 PM, Steve Wise wrote:
> On 1/14/2016 11:40 AM, Leon Romanovsky wrote:
>> On Thu, Jan 14, 2016 at 05:00:30PM +0200, Or Gerlitz wrote:
>>> On 1/14/2016 4:53 PM, Steve Wise wrote:
>>>> Hey Or, iWARP is non-functional in 4.4, and this patch fixes the
>>>> regression.  I suggest we get this fix in stable asap.
>>> sure, we can make an exception in our usual track for this one, but
>>> you need
>>> upstream commit ID ## -- Doug is your key person here
>> Or, there are no doubts that commit ID is important for our work, howe=
ver
>> submission to stable can be done without it [1].
>>
>> Just follow the Steve's advice on cc-ing stable list in sign-off secti=
on.
>>
>> [1]
>> http://lxr.free-electrons.com/source/Documentation/stable_kernel_rules=
=2Etxt#L40
>>
>>
>=20
> Hey Doug, can you please accept this and add the Cc: line to get it int=
o
> stable-4.x?
>=20
> Thanks,
>=20
> Steve.

I've pulled this in.  I had to fix it up to work with some other code,
and I added the Cc: to stable.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--JkF8CxCS7RMLAc8duSU4TR3tMeR6lLRJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnoQCAAoJELgmozMOVy/d1kgQAJoXOKxHlnKvxnnH5/97bm18
lCMgUkDQnlMvdZVd2+PQJ9mSfX2WFYDK5VNX5/AlpEAlCg6KBMJGbzDd3YiKOOHg
D+U419aIBq8/jsycgPoav/Jlu3iCiFvL8dbJKGJpLHZWy8VtLF9wImfgBIbRw8c7
WDsZKq74RFZC+aIMbQKvjGrYdFMd+0rkWQm/r1vdjr2RBujYXuItGqMlISwTQW04
42rEenp4inCkpjr4W+B/+79mp0mZyVEAPbciWb7h69NwqDJ1Ps2h0RqoOERCtZvn
z9mMoIZTtbQml1zlUVvMizEYw04jaNr7zCIhZ+L+5k+7uVE/925Kn5fEXNt5LdeL
kGRvKSgpjHsGAu2ZT+SZpcBg6ElsD2paG3Gs96otCz0R5WayHuRg0HdRWWK0q/2R
1aXQa6ckvIj3kc0azYc5egVkKzWmno/TK2TvV49N3tWU9qlXdmKp0KMjb3WN30M/
V4qpGz3FXj5GvRJz1e+zD3a3aklbV917YRsyzka5Kyh0DHSzuP9IsEkgN41QJqtz
yZDQl1iRuRJPDrngz0u7IMJfIgd9lKlIJYN5TS2zYo6IUA1EOXXlmTrIyZUCr2qw
IG5WrMrE2Faxy0pnSnPjp/THasrNL/ppLIgkDsRLVeN3dtYXuq2DJU/fczbEosR+
vHkUhcfimc6xiv7RpkRK
=apQf
-----END PGP SIGNATURE-----

--JkF8CxCS7RMLAc8duSU4TR3tMeR6lLRJd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
