From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 09:14:02 -0400
Message-ID: <10f7f884-8e65-b563-bdd8-7c2735906d14@redhat.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
 <20170530054609.GG17751@mtr-leonro.local>
 <20170723073905.GE3259@mtr-leonro.local>
 <20170723074153.GF3259@mtr-leonro.local> <1500812883.2610.7.camel@redhat.com>
 <20170723130445.GG3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d34m0dUsRs4k7xrsjCkGqLibL3Nr4JDBI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170723130445.GG3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d34m0dUsRs4k7xrsjCkGqLibL3Nr4JDBI
Content-Type: multipart/mixed; boundary="Irr2pRfBJFmbq7C3RLLNm9I01ePEDqwfD";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <10f7f884-8e65-b563-bdd8-7c2735906d14-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
References: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20170530002032.534.25061.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20170530054609.GG17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20170723073905.GE3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20170723074153.GF3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org> <1500812883.2610.7.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170723130445.GG3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170723130445.GG3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--Irr2pRfBJFmbq7C3RLLNm9I01ePEDqwfD
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> On Sun, Jul 23, 2017 at 08:28:03AM -0400, Doug Ledford wrote:
>> On Sun, 2017-07-23 at 10:41 +0300, Leon Romanovsky wrote:
>>> On Sun, Jul 23, 2017 at 10:39:05AM +0300, Leon Romanovsky wrote:
>>>> On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
>>>>> On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro
>>>>> wrote:
>>>>>> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>>
>>>>>> Playing with IP-O-IB interface can trigger a warning message:
>>>>>> "ib0: Failed to modify QP to ERROR state" to be logged.
>>>>>> This happens when the QP is in IB_QPS_RESET state and the stack
>>>>>> is trying to transition it to IB_QPS_ERR state in
>>>>>> ipoib_ib_dev_stop().
>>>>>>
>>>>>> According to the IB spec, Table 91 - "QP State Transition
>>>>>> Properties"
>>>>>> it looks like the transition from reset to error is valid:
>>>>>>
>>>>>> Transition: Any State to Error
>>>>>> Required Attributes: None
>>>>>> Optional Attributes: None allowed
>>>>>> Actions: Queue processing is stopped. Work Requests pending or
>>>>>> in
>>>>>> process are completed in error, when possible.
>>>>>>
>>>>>> This patch allows the transition and quiets the message.
>>>>>>
>>>>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>>>>>>>
>>>>>> ---
>>>>>
>>>>> Thanks,
>>>>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> Doug,
>>>>
>>>> After digging more with Erez's help, it looks like the sentence "it
>>>> looks like the transition from reset to error is valid:" is not
>>>> correct.
>>>>
>>>> According to the InfiniBandTM Architecture Release 1.3, Figure 126
>>>> QP/EE Context
>>>> State Diagram - transition to error from reset is not valid.
>>>>
>>>> The quote from the spec:
>>>> "An error can be forced from any state, except Reset, with the
>>>> Modify QP/EE Verb."
>>>>
>>>> I'll send revert patch along with proper fix.
>>>
>>> Ahh, it wasn't pushed to kernel.org, so no need to revert and you can=

>>> simply drop it.
>>
>> It *is* on kernel.org, and has already been pulled by Linus:
>=20
> Thanks, I updated the trees and got it.
>=20
> Also I prepared revert and patch and will send once it will finish our =
regression runs.
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/com=
mit/?h=3Drdma-rc&id=3Db287b76e89503ef1d403cc5cc8bd74b035d25bfa
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/com=
mit/?h=3Drdma-rc&id=3D5dc78ad1904db597bdb4427f3ead437aae86f54c
>=20
> BTW, when will you post for-4.14 branch so we will be able to base our
> submission queue for the -next?

Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of the
fixes that went in this week.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--Irr2pRfBJFmbq7C3RLLNm9I01ePEDqwfD--

--d34m0dUsRs4k7xrsjCkGqLibL3Nr4JDBI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZdKEhAAoJELgmozMOVy/d2MQQAIOl2SBm0As8h8YoDPBSSdK7
SzWBiSuPTAcGP7+AkNODF7KOfwnjRbs3PeXfdst16GnWuSF2LKRCThU49kC/4SoD
yztpc1agp25PGOSeLPPdM0QotmUFbtXwnbcOKxQQVegVbJR4kc9Jt5LsKvx1bnj1
0d5OcsXyKAybR+4xpev+pb/RWRZPYhusJGOu1LmEywMOwRInbi3JtEO7UzcycFyL
5YqSJeauTgSTi5R0Qis5DFNXMvt7uticYlBcRA9DTbqznpQmVaoy/fwcMkXBHMhz
oxkbL0sYKJla8hTJS7k2Kpk7j2s17/KJfHx+uk4Yay7GSxtk3upYt4y2MMBhchHD
XsooRlhgbmVxxdGZbX9hDXLyORPk7EwzpqOSuLr5ItvK52fCTU5+iQ5bAwjjLMsb
Be98J6t8GhgiqkgyWBy5QGkJ7w4H9xfxp1G7FtjXXC38yxIhn5tg94HpI8cgRjzc
RIKplxPP3X0L+Tm7tfvHX/6q25URu90ADjT7NBVa726cAtf3cIqJe6B9LrBIUJ4a
mdvgmZfOz7FX5ztkLa6DapFrXXLkCrWmnoKkr8MrOXDjWhgGFVd1ynDQu5SQht35
li1zMJ+y3a+MpR+VPldlzgvWXtbh20iV/Ncz3dKZHKDO1iuwymxWV3PtoY1wEumg
rKck5PYfK2iddavp/JFW
=ulXM
-----END PGP SIGNATURE-----

--d34m0dUsRs4k7xrsjCkGqLibL3Nr4JDBI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
