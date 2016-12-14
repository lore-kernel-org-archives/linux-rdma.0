From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
Date: Wed, 14 Dec 2016 14:03:14 -0500
Message-ID: <67d4e948-0ada-bd75-8855-79eed2ae9a7b@redhat.com>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
 <1480592596-20126-3-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA789@ORSMSX109.amr.corp.intel.com>
 <20161202143957.GF4497@leon.nu>
 <HE1PR0501MB28122735F9F3DFD700B43BFBB1800@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2U3XGKAIMlg1rp6xDVkE2974r4vm7tems"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0501MB28122735F9F3DFD700B43BFBB1800-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2U3XGKAIMlg1rp6xDVkE2974r4vm7tems
Content-Type: multipart/mixed; boundary="owjvroT27nx3eXfEhKXDqVLwdWWjv0uxO";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <67d4e948-0ada-bd75-8855-79eed2ae9a7b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
References: <1480592596-20126-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1480592596-20126-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA789-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20161202143957.GF4497-2ukJVAZIZ/Y@public.gmane.org>
 <HE1PR0501MB28122735F9F3DFD700B43BFBB1800-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
In-Reply-To: <HE1PR0501MB28122735F9F3DFD700B43BFBB1800-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>

--owjvroT27nx3eXfEhKXDqVLwdWWjv0uxO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/4/2016 6:53 AM, Liran Liss wrote:
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
>=20
>>
>> On Thu, Dec 01, 2016 at 07:40:44PM +0000, Hefty, Sean wrote:
>>>>  enum ib_qp_state {
>>>> @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
>>>>  	u8			rnr_retry;
>>>>  	u8			alt_port_num;
>>>>  	u8			alt_timeout;
>>>> +	u32			rate_limit;
>>>>  };
>>>
>>> And I still disagree with this approach, as there is already an exist=
ing field in the
>> API that limits rate.
>>
>> Hi Sean,
>>
>> We would like to elaborate more on the subject, and we need your help =
here.
>> Our cover letter [1] has description why the existing field is not eno=
ugh. Can you
>> write a little bit more why you didn't like the proposed approach to a=
n existing
>> and real problem?
>>
>=20
> Clearly, we need a new field that is greater than 8 bits that uses diff=
erent encoding (actual rate rather than a predefined enumeration of value=
s).
>=20
> However, this is not only a new field - this rate is also conceptually =
different than AH static rate:
> 1) It is not related to the fabric path.
> 2) It is determined by the application rather than the fabric.
> 3) It needs to apply to QPs that don't use AH (raw Ethernet QPs)
>=20
> Of course, we might require raw Ethernet QPs to use an AH just for the =
sake of rate-limiting.
> But 1) + 2) indicate that this should be a concept orthogonal to networ=
k paths. In fact, it could apply to RC and UD QPs as well.
> In addition, if we implement full connection establishment in the kerne=
l (i.e., the static_rate field is filled in the kernel), we would still l=
ike to allow applications to further restrict their rate using a differen=
t component mask.
> --Liran
>=20

I applied this series.  I agree with Liran that the need for something
other than an enum to denote rates is needed.  We will have to work out
exactly how to present this to user space (keep both, replace
static_rate and bumb the verbs API number, other options?)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--owjvroT27nx3eXfEhKXDqVLwdWWjv0uxO--

--2U3XGKAIMlg1rp6xDVkE2974r4vm7tems
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZdyAAoJELgmozMOVy/d+bIP/3ft50o5qYjIkGdwQhvorrGu
6OfhZz5xsSkTFJRPyQn+ZtdupjiVoMhtwbrSciPsDaB+pv6j4K+x8sRJVWAHsD2C
k46Der1F7ZNnvU8OXgaVy0GCDxGT5YC0SOZPqptK0HLSzF7h5Npx/mIxS/0yvd7g
S4ifgC4Y0pW97A/mIOY97HVj01Q5PmaqUhalwoCcXFAw5aY7JkFS7svOgncGebJH
CmDK6PXasmFddW3+LHKhyyT1BnMf+HxCmI770tAN1AuncAkayzT3nTQkeTdeOqq1
FpLglQi40KR20jYQvk6wGRm3Fe2T3TRpC51Z4+G90UYMYvyq4ty9cpuLJnJBXnVp
Uj+zLJNoWg+HaaldPLyV1KB0OnSfBhX+R33lctLPiw1RMQpz0rnD12ld/24IxZqp
pFnwFiRjphd6o+LlEdxDFBKYzeKgzq3q/zJEoMiBe5JzEYBBuiSCwE5U3Ev7TTfu
2njKRTPBUeZYejlXqq/tENGIUWhWMadUlHb9s5dFIlm+xuKJ5s0da1emx2TOU7JG
cs51E0mIH98o2SnylqfUXIs0PnMHIIKBhVaULLy0InKEBpRSHlEgcbFjywLtUXB1
4bu9bbiq/Cv0//7IOwZNgq6oh3ZYyS5PEgvLKkkAhKcJ00xOGLwgLIrrFFGoXBi2
5G1lljKcPCtzB3NUb5GR
=Z471
-----END PGP SIGNATURE-----

--2U3XGKAIMlg1rp6xDVkE2974r4vm7tems--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
