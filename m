From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Mon, 19 Sep 2016 16:25:18 +0300
Message-ID: <20160919132518.GH3273@leon.nu>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
 <20160919061558.GG3273@leon.nu>
 <1474288178.6520.12.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474288178.6520.12.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 19, 2016 at 12:29:43PM +0000, Dalessandro, Dennis wrote:
> On Mon, 2016-09-19 at 09:15 +0300, Leon Romanovsky wrote:
> > The function pointers will cause us to create two similar functions
> > (debug/regular) for every important function. It will leave to code
> > duplication and/or introducing of new code to fill additional fields
> > in returns to debug functions, so they will be able to print it.
>
> I do sort of like Doug's idea. It means you can easily instrument the
> heck out of a routine and have it always available. It provides more
> flexibility in what you can do in a debug version.
>
> You do make a valid point though about duplicating code. Perhaps that
> can be alleviated to some extent just by refactoring and adding
> inlines, etc. =A0

At the end, we will invent tracepoints :)

>
> > I wanted to propose to use tracepoints to provide debug information
> > in
> > data paths. The tracepoints infrastructure uses hooks in the code
> > with
> > minimal impact on performance.
>
> This is so far the path we have chosen for hfi1. We have a number of
> tracepoints in various parts of the code. Again it's available on
> demand without special kernels or boot/driver options.=A0

CONFIG_SDMA_VERBOSITY ????

>
> > > Then we can drop the CONFIG_*_DEBUG options out of all of the
> > > drivers.=A0=A0That would be my preference.=A0=A0I don't want any comp=
ile
> > > time
> > > options because you never will be running a debug kernel when you
> > > need
> > > it.=A0=A0Per device, run time selectable so that you get 0 overhead in
> > > the
> > > normal case is what I would like to see.
> >
> > Great,
> > We are aligned on this point, so do I. I see no reason in special
> > compiled
> > kernel or global module parameter to print debug prints for whole
> > driver.
>
> Same here.
>
> -Denny

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX3+c+AAoJEORje4g2clinQEoQAId0jLZNwxR9eUyPseaiMwg7
5X+gnoBCtUWE+2z8adQIp2fLuTt8/jg0oUW6sgA+en5OuFNpFEzmEkFUnI7e3D0u
cV8+bDkWG930kZxTopjkoym2okNF4nmi2HLLKVHXoDwZ6FxOZ+6CdbXgmrMuTQAV
cgZ28LCPw7NcINthamylgb3nZ86nv9lqakeB6T8X96nAMfssow1N4vcQbpUIXM23
m5sKJQNGJL90KY5JvQxBYerwALgc3187JguaMNb1bsh8X490/QAW+xbCoYDZHAcs
f2qnHnwhRbXz3Kgx/czLOuY+x6JMVFK8KrOgZHkKMGvIDCLjeyEjAkZlCRv6sddA
WPX/Z5C3Wzj6dthjChxRIlquiZjadqhspcBV82nPqHEe2vhFvX87KLxaZJCk2JjJ
pcIQoUq0KINa8P1q/+ksV4bVUGTiaMRIz0BOmb4ywZYtXe2PDMvS4yI9FJROzAAH
R6JY1iFSuxZKIxDI1cQavUu54puTMkmohX2/DesRgLNL/qXqbSxMUR2wgDCws9/4
f4zvDfPUIytjqPBkbScxXBPkUnprQB6te/6gLMq/IcyL0S9gGWnRfrWQgkU1YZC4
WQVC6vWe3OAmwSpoKn3trGDAPWW022eQBAa3o4P97RlvwW/0cq7GRWOiSqN1ypew
N2RSi8NE79kb8qpfw3mW
=TdyJ
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
