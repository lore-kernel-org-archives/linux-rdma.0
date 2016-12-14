From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Wed, 14 Dec 2016 17:36:26 -0500
Message-ID: <57fa42c9-5ef0-c6f5-f7fd-88ec5948d387@redhat.com>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hWLLxNxo90olA40d7cGgXL9jMq5VigxD3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161214212103.GA6947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hWLLxNxo90olA40d7cGgXL9jMq5VigxD3
Content-Type: multipart/mixed; boundary="reDVvSONCJDBNBnVnkW0VpmNPbk5SaH3g";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Message-ID: <57fa42c9-5ef0-c6f5-f7fd-88ec5948d387-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 <20161210143421.GC2521-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <20161214171111.GA4521-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <20161214212103.GA6947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161214212103.GA6947-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--reDVvSONCJDBNBnVnkW0VpmNPbk5SaH3g
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/14/2016 4:21 PM, Jason Gunthorpe wrote:
> On Wed, Dec 14, 2016 at 07:11:11PM +0200, Leon Romanovsky wrote:
>=20
>>>> This patch duplicates already existing code in most of providers and=
 libraries
>>>> in rdma-core, while two of our main goals for creating this consolid=
ated
>>>> library were simplification for users and reduce code duplication.
>>>>
>>>> It will be very beneficial if you:
>>>> 1. Use and promote general pr_debug(..), srp_tools has nice piece of=
 code,
>>>> to be general code.
>>>
>>> [Tatyana Nikolova] The debug/error printing macros available in
>>> rdma-core use different mechanisms to report information, for
>>> instance, they set/check one or more variables, or they use a bit
>>> mask to enable debug level. They also print to different outputs:
>>> stderr/stdout, debug files or syslog.
>>
>> At the end, all these prints are for debug. It is hard to see any
>> objections to see output from them in one place.
>=20
> Yes, let us just use stderr for now for provider debugging. If someone
> wants syslog then that can be a later patch. It makes no sense that
> there are difference here.
>=20
>> in rdma-core/util/env.h|c
>>
>> #define SET_VAR(type, var, field) \
>> 		(struct ##name*)env->field =3D get_env_var(...)
>>
>> void *get_env_vars(enum typ)
>> {
>> 	void *env;
>> 	switch(type) {
>> 	case I40W_ENV:
>> 		env =3D malloc(sizeof(struct i40w_env));
>> 		....
>> 		SET_VAR(i40w_env, "I40W_DEBUG", debug);
>> 		...
>> }
>=20
> Why?
>=20
> I was thinking more like a standard:
>=20
>   VERBS_PROVIDER_DEBUG=3Dqp,ah,blah
>=20
> parser since other than mlx5 that is what providers use env vars for.
>=20
> I'm not sure I agree at all with what mlx5 is doing with tuning
> parameters via env vars :\

Options (not necessarily tuning though) have long been enabled via env
vars for shared libraries.  That really isn't uncommon.  Env vars are
easy to set on a per-app or per-user or per-container basis.  The other
option, config files, are not so easy to separate out.

And one thing we might need this for in the future is to reserve QPs for
IPoIB use so we can actually have containers with consistent IPoIB
device hw addresses by using GID + Fixed QP number.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--reDVvSONCJDBNBnVnkW0VpmNPbk5SaH3g--

--hWLLxNxo90olA40d7cGgXL9jMq5VigxD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUclqAAoJELgmozMOVy/dfqYP/3KcgoUXcsPNnwGGbP36pZ4F
1FTpUbRy/Fz3Qjrb2R833AF/x36egLfR3MX2auW12d0KoNl6GDQYGWnwQGU6Nzb8
9j1ahwbK/Zlj96vfbEYrvD3Sh56sCCJXwQ1BO6F2sAPrqi4IPERjNAuIH6S5F7TM
UPTOA84V94rbMmHPW/AwPQ+QadZmpf2x6Hi9SWCDDerUehVxTdQp3YuSeXVWbY8M
RQ9kxOOHMalQz/8UbFkXwiLXOlSQxcnaI/1f5TdQAyF52zb3zJRXdVpSVTi5Ii+k
XNWn6+Ugj3jaQK96bSiFe+kO0DJSv83YKlVLaRNDMHIy+YNrT/V6pdOnhqnuiik3
93bpTQspeZxAYvAUyOdVORnsuLnEq8paS2nmoRDoA/UT/gHGqHZp9YGb/Pub3ibB
mzGtuP4J0aXP/NtF7pSb/MHGL5X3UbpS5KcowIHCTxAKSWqjPXdHxWKeEb56U0Ir
L/+Kbx6rs27OLZKsLHgXgSfOH74qamT81E9UwUn3SF2U3FYugzC9lr7XBIJ1aM9P
3s1N7k0zVKFQaKK/rliXC7T2o7YH6+HJJt559rGJ3u7IlSsJ5o4dIIKLDHxHCT/p
C+QTOfKUwxt7LxolZ6lxpgdbjlz0GQsE5mB3FA8Hl3Rc2IlSnU90XiekIL7HwWec
AojSrO6UsMm0X5j+wK/t
=87/s
-----END PGP SIGNATURE-----

--hWLLxNxo90olA40d7cGgXL9jMq5VigxD3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
