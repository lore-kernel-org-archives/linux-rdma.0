From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
Date: Thu, 15 Dec 2016 22:53:51 -0500
Message-ID: <2fb4958f-ea10-f326-0002-6bd9ebbf4ef7@redhat.com>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
 <1480592596-20126-3-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA789@ORSMSX109.amr.corp.intel.com>
 <20161202143957.GF4497@leon.nu>
 <HE1PR0501MB28122735F9F3DFD700B43BFBB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
 <67d4e948-0ada-bd75-8855-79eed2ae9a7b@redhat.com>
 <20161216024834.GA27188@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1e0jPpwQw5x9f8Ke2RFKBC6LCdwcPbA8J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161216024834.GA27188-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1e0jPpwQw5x9f8Ke2RFKBC6LCdwcPbA8J
Content-Type: multipart/mixed; boundary="HbjH4lqF5OMm7kSONWu7UuRE4JTtOhUOs";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <2fb4958f-ea10-f326-0002-6bd9ebbf4ef7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
References: <1480592596-20126-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1480592596-20126-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA789-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20161202143957.GF4497-2ukJVAZIZ/Y@public.gmane.org>
 <HE1PR0501MB28122735F9F3DFD700B43BFBB1800-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
 <67d4e948-0ada-bd75-8855-79eed2ae9a7b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161216024834.GA27188-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
In-Reply-To: <20161216024834.GA27188-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>

--HbjH4lqF5OMm7kSONWu7UuRE4JTtOhUOs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/15/2016 9:48 PM, ira.weiny wrote:
> On Wed, Dec 14, 2016 at 02:03:14PM -0500, Doug Ledford wrote:
>> On 12/4/2016 6:53 AM, Liran Liss wrote:
>>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
>>>
>>>>
>>>> On Thu, Dec 01, 2016 at 07:40:44PM +0000, Hefty, Sean wrote:
>>>>>>  enum ib_qp_state {
>>>>>> @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
>>>>>>  	u8			rnr_retry;
>>>>>>  	u8			alt_port_num;
>>>>>>  	u8			alt_timeout;
>>>>>> +	u32			rate_limit;
>>>>>>  };
>>>>>
>>>>> And I still disagree with this approach, as there is already an exi=
sting field in the
>>>> API that limits rate.
>>>>
>>>> Hi Sean,
>>>>
>>>> We would like to elaborate more on the subject, and we need your hel=
p here.
>>>> Our cover letter [1] has description why the existing field is not e=
nough. Can you
>>>> write a little bit more why you didn't like the proposed approach to=
 an existing
>>>> and real problem?
>>>>
>>>
>>> Clearly, we need a new field that is greater than 8 bits that uses di=
fferent encoding (actual rate rather than a predefined enumeration of val=
ues).
>>>
>>> However, this is not only a new field - this rate is also conceptuall=
y different than AH static rate:
>>> 1) It is not related to the fabric path.
>>> 2) It is determined by the application rather than the fabric.
>>> 3) It needs to apply to QPs that don't use AH (raw Ethernet QPs)
>>>
>>> Of course, we might require raw Ethernet QPs to use an AH just for th=
e sake of rate-limiting.
>>> But 1) + 2) indicate that this should be a concept orthogonal to netw=
ork paths. In fact, it could apply to RC and UD QPs as well.
>>> In addition, if we implement full connection establishment in the ker=
nel (i.e., the static_rate field is filled in the kernel), we would still=
 like to allow applications to further restrict their rate using a differ=
ent component mask.
>>> --Liran
>>>
>>
>> I applied this series.  I agree with Liran that the need for something=

>> other than an enum to denote rates is needed.  We will have to work ou=
t
>> exactly how to present this to user space (keep both, replace
>> static_rate and bumb the verbs API number, other options?)
>=20
> I think in the new ioctl interface values like this should be more gene=
ric.
> MTU is another example.

Agreed.

> FWIW I agree with Sean that static rate should have been changed to acc=
ommodate
> this expanded meaning.

Changing static rate only matters at the user application level.  At the
driver to kernel level, it's easy to say this is driver specific and the
user space driver can communicate with the kernel driver any way it
chooses.  It's a non issue at this level.  It's later that we have to
figure things out, which was the point of my comments and why I took this=
=2E

> With this new structure definition which rate is in effect?  Are device=
s
> supposed to take the min of the 2?

How did you write your kernel driver and how did you write your user
space library?  Because until the rdma-core to application API gets some
modification, your user space driver will only ever get static_rate with
its existing meaning from the user app and what your driver does with it
internally is moot.  What's more, it doesn't matter if mlx5 and hfi1 do
the same thing, only that what they do is consistent with themselves.
It's when we add that user bit that we have to make things right and set
them in concrete.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--HbjH4lqF5OMm7kSONWu7UuRE4JTtOhUOs--

--1e0jPpwQw5x9f8Ke2RFKBC6LCdwcPbA8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYU2VPAAoJELgmozMOVy/dDvYP/iYI4pDeBzWxrZnK254UhlWV
JQ4CYflYPVVQVi8FqsBqVYfkjjOY84cbuZW1uOSfFmthTBVsFhmWscfuHOmhbCUX
bdZ0joqH3+flwrrtFBNLmCLeBlyzQiJTLdd6cf5OfykEIBns7hjyHfe5LVKeEN5P
Sjc6U2OVHAGlSblUf1Z9cFZaX7dTJ6NRrSjw9QIF/yokquZNm0RmGU/F8CMt9i+d
5JhzczBE1Avgj2jEXFus5m6ZE8eNI8R9gl5dVbKH0vuhM4HU6dfu4BdAE7H0XlRB
Cz+z4RVMAOAuUWT881Mc3QRvLpC8iSg41P9teYdqoDizfpMXGwoVTB11kt06vzws
ysMgKvmOc+0AsX6wYTNaJX8qbU5LEloHBOz6d9w+lRwpfWSWLZVuJTWwQ8Qsarmx
imHP1dFpE/asPfiIdePnsAcQb0MO+nTid5siXfCFitLEc8HkD90dw7ZNbjVxeDSP
kBRxZNvpNEIwfPDeQtusxvLugZiZPFbSVmM7g9BZ11dP4MpJGdx4krmmiG7Q2hoL
JPC5VmGsdNK/wjBPa2Vl51busATDtmizSwM485XJ2hwmCEUgiMAkw7s+IGfBrHn0
gwtxyS0aLcWYPoGDR3ZwWeMwmcRr1ThaAN9z7TDvtiNrcuH3aH86Ez4vX3Xikebw
cJ7YEFKSI/8OoUOi9W5l
=i43p
-----END PGP SIGNATURE-----

--1e0jPpwQw5x9f8Ke2RFKBC6LCdwcPbA8J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
