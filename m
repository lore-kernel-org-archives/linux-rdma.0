From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 00/32] Soft-RoCE driver
Date: Sat, 26 Dec 2015 13:09:27 -0500
Message-ID: <567ED7D7.90602@redhat.com>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
 <20151224100228.GB21387@infradead.org>
 <CAJ3xEMiR7gcgScbiCkx3YpXJpJO4LYHvUY=1kpxxwiGtudF-qw@mail.gmail.com>
 <20151224142047.GA29757@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S2biFFfex6NLM2BdHEwuPSoqPMUNVQwIX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151224142047.GA29757-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S2biFFfex6NLM2BdHEwuPSoqPMUNVQwIX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/24/2015 09:20 AM, Christoph Hellwig wrote:
> On Thu, Dec 24, 2015 at 02:58:10PM +0200, Or Gerlitz wrote:
>> On Thu, Dec 24, 2015 at 12:02 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>>> On Thu, Dec 24, 2015 at 11:17:46AM +0200, Kamal Heib wrote:
>>>> We've located the driver in the staging subtree. This follows a requ=
irement
>>>> to implement an IB transport library - Soft RoCE is in the same boat=
 like the hfi1
>>>> driver. We need to define and implement a lib to prevent those code
>>>> duplications.
>>>
>>> Given the trainwreck that the staging process is it might seems more
>>> sensible to get it into a stage and then merge it directly.  You'll
>>> probably save yourself a lot of work that way.
>>
>> I am not sure what you mean by "get it into a stage and then merge it
>> directly" --i
>> is that not go through staging at all?
>=20
> Sorry, I should have not finished that email in a hurry before leaving
> the house.  Let me rephrase:
>=20
> Given the trainwreck that the staging process is it, might be more
> sensible to get it into shape and then merge it directly.  You'll
> probably save yourself a lot of work that way.
>=20

Greg and I have an agreement (again) on staging/rdma.  This shouldn't be
an issue.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--S2biFFfex6NLM2BdHEwuPSoqPMUNVQwIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWftfXAAoJELgmozMOVy/dKRoQAIGKLvnxXTOuWCidtnD83r9X
wiOwKxmBrJ9Kx0bw+nq88QuY1pOwq/BXi+5Hp/spt7gmmw1yxNrgvRSCLVkMERt8
StSdqTz+7WosGRqpVIsUd6bPIRXaHdSqudI/wlRzcY/WcOGdSoHJoc2G3tyi4KRM
HUXQk0LErUYSfeYaiA8dCUVsldPAncgg9DzM4MWweAb4rfKFBX0Jg9i14SYR78UP
wISBA5N/+fsJZUr344drbdqjnwR/8bPC5wx8mkzfdMlwpExkx3RvgEaeh6nNXDTf
nfEnADUJapQTMNzGoggSZBUkTVPlwNu1HlAqrt/9C8yjfTmvaFd7Xi15j2DRhsuO
CaDwvKaDXVItcvPIBwL3F/Tkxccrpoh7+T0rrvR7HcXlLa6D1khLDV302oc85sd6
M0/xvR3XuQTR5RzKGmLh4Ynq+6YpzEbWi+53jFWPwxRbLYZzRLNDH/84zPkASJwu
9iGGr5HumeijnCr13FZOyaqK4+CIpqo6wCp/LxobpMWz1PRadgjMuyO93Zz/HA8r
fXJ6q0ycqBAVDIRxlYchFOCH8FGJbxYASlsixwiv8y1erRPvRFpxgnwj2CXRtfrb
S+fbxTMD8C/+OBDP/+VEu07P4PEwqFE9tmaNqK4SrzMW+OGvgqsunx5nWhIv6H8s
Y1HcasrEbmPmQBRb7uxr
=jjul
-----END PGP SIGNATURE-----

--S2biFFfex6NLM2BdHEwuPSoqPMUNVQwIX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
