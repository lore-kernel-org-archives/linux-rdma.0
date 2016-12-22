From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Thu, 22 Dec 2016 14:19:28 -0500
Message-ID: <370c562e-3309-d036-65de-5df299824d9f@redhat.com>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1a61e971-4944-b8db-0fd5-b73118b578db@redhat.com>
 <20161222171323.GC18935@mtr-leonro.local>
 <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd@redhat.com>
 <20161222191759.GF18935@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R9lLtthqGQc3cteAU2e6S4iKJ9f43iRv6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222191759.GF18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R9lLtthqGQc3cteAU2e6S4iKJ9f43iRv6
Content-Type: multipart/mixed; boundary="w9iNNOer63t6CNSvdEVCXPOJ0hVHrTBUr";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <370c562e-3309-d036-65de-5df299824d9f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <1a61e971-4944-b8db-0fd5-b73118b578db-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222171323.GC18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <ed8ea5d4-9cb2-465d-88a8-bdca848efcfd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222191759.GF18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161222191759.GF18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--w9iNNOer63t6CNSvdEVCXPOJ0hVHrTBUr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 2:17 PM, Leon Romanovsky wrote:
> On Thu, Dec 22, 2016 at 01:19:35PM -0500, Doug Ledford wrote:
>> On 12/22/2016 12:13 PM, Leon Romanovsky wrote:
>>> On Thu, Dec 22, 2016 at 11:53:20AM -0500, Doug Ledford wrote:
>>>> On 12/19/2016 3:31 PM, Tatyana Nikolova wrote:
>>>>> RQ WQE size other than 128B is not supported.
>>>>> Correct RQ size calculation to use 128B only.
>>>>>
>>>>> Since this breaks ABI, add code to provide
>>>>> compatibility with V4 kernel driver, i40iw.
>>>>>
>>>>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>
>>>> Thanks, applied.
>>>
>>> Hi Doug,
>>>
>>> Please can you clarify a process here?
>>>
>>> In previous discussions, you mentioned that the reason of not accepti=
ng
>>> some code to rdma-core was because it is part of next kernel and we
>>> patiently waited for release. This code is definitely not relevant fo=
r
>>> current kernel, but you are already took it before we ever released f=
irst
>>> version of rdma-core.
>>>
>>> So why are we waiting with libpvrdma and RoCE address handle?
>>
>> You're right, that was a mistake on my part.  I'll probably have to
>> revert this patch, then reapply it for the next version since the 4.10=

>> kernel is the first one to provide the abi field to the user space lib=
rary.
>=20
> I assume that you are waiting for RHEL spec fixes to do actual release,=
 but
> maybe we should release it anyway now (replace rc3 with actual release)=
?

Can't.  rc3 had the wrong patch in it.  I've reverted it and have pushed
it out.

> We are preparing fixes for Debian package which is not in perfect shape=
 too,
> and I don't want to let people wait till all these packages are finaliz=
ed.
>=20
> What do you think?
>=20
>>
>>>>
>>>> --
>>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>     GPG Key ID: B826A3330E572FDD
>>>>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E5=
7 2FDD
>>>>
>>>
>>>
>>>
>>
>>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>     GPG Key ID: B826A3330E572FDD
>>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 =
2FDD
>>
>=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--w9iNNOer63t6CNSvdEVCXPOJ0hVHrTBUr--

--R9lLtthqGQc3cteAU2e6S4iKJ9f43iRv6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXCdAAAoJELgmozMOVy/dLTMP/j10vOrUCsaSuyc1NU7jBncX
5BrDBJh/WvUYOA5P9Gm5dBWbgWEXzf1LY3Aog1txqb2xn5pzYwTkUQr8O/hOayMF
NLiFbwBxcH+gIaYAeyNneePIMVZSlmJas2Bg7S0NFJ00T0/KhdopsqT4VMcY0qeM
dWSr6H8Ie8FN3M+MQnSsoCFFNkxuGQ2JllpI+mzfYA6EtJLpsXfafI0xzwm1oG54
gctBET2E97pnwDwbQgZi+UyGW78R6z/F+IBGs/cAOh4wF+7YBK/LyyTlcNmSoEbo
68rdphYOMB/rS19bsHoic/DaPZ2ojfq47Hy6FZC1ON8bQb5l48NBpqAvKVK+9r68
gD2MO3Ri9qpGWAp1Irm0Gpy6R1Oudpl3DHZ11IgoUHLVkgEQD8XLQSmiYSYLY/qq
hicQwwMco3+Y4Jm+kCH6O1PfxkxdQBOcnLdAKU/bqCazQM20VGREgUKduSsZIRO6
rp8mah8gXMIfPxp62ssf4hb0wCYDmX9HP0ilmRrSNXV/xlzjyNucdKc7KpN3+18j
lobyAOEyFuBXyGcc8zDuJF17wXQxdFdel2jWv65PiiksePxcOD8Sp92f+2WNFnFK
8smR8bm0rxFZx/a41RZ19yhdLlBYXcX3qnMllNe1FpSqz8P3nOKLIPRdE3M2j6Wy
QlJFFTMAy6vyhcQHkfeK
=sNR5
-----END PGP SIGNATURE-----

--R9lLtthqGQc3cteAU2e6S4iKJ9f43iRv6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
