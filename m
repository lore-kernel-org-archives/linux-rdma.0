From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 18:00:18 +0300
Message-ID: <20171010150018.GC2106@mtr-leonro.local>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
 <20171006214243.11296-4-bart.vanassche@wdc.com>
 <20171008100317.GR25829@mtr-leonro.local>
 <1507568205.46071.46.camel@redhat.com>
 <1507568492.2674.11.camel@wdc.com>
 <20171010041423.GJ1252@mtr-leonro.local>
 <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9443ec1f-0acd-9fa3-4621-a29085d2c606-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 10:34:19AM -0400, Doug Ledford wrote:
> On 10/10/2017 12:14 AM, Leon Romanovsky wrote:
> > On Mon, Oct 09, 2017 at 05:01:33PM +0000, Bart Van Assche wrote:
> >> On Mon, 2017-10-09 at 12:56 -0400, Doug Ledford wrote:
> >>> On Sun, 2017-10-08 at 13:03 +0300, Leon Romanovsky wrote:
> >>>> It is a little bit strange to ask from user to decide if his adapter
> >>>> supports SRQ or not.
> >>>>
> >>>> It should be automatically.
> >>>
> >>> I think Bart's intent is that the driver not use SRQ as the default
> >>> behavior even if the adapter supports it, so querying the adapter for
> >>> support and enabling it if it exists would not achieve his desired
> >>> result.  This would then be used to override that behavior.  Is that
> >>> correct Bart?
> >>
> >> Hello Leon and Doug,
> >>
> >> The changes realized by this patch are:
> >> - Instead of using SRQ as default, use non-SRQ mode as default.
> >> - If SRQ has been chosen as default, and if SRQ is not supported, fall back
> >>   to non-SRQ mode (see also the if (IS_ERR(sdev->srq)) ... code).
> >>
> >> Please let me know if you have any further questions about this patch.
> >
> > Yes, in case HCA supports SRQ, when do you set that module parameter?
>
> You set it in your /etc/modprobe.d/ib_srp.conf file or the equivalent in
> your OS.

Doug,
But my question was "when" and not "how". When should I set this
parameter to true?

>
> > In the commit message, you mentioned disadvantages of using SRQ is a
> > default and among them - locks contention, which can be changed in the
> > future. Won't it mean that users stuck with current default, because
> > change of default will "break" their scripts?
>
> No, it won't.  If you change the default, you don't remove the variable,
> you just change what its setting is.  Then existing modprobe.d files
> become redundant, but nothing breaks.  People that don't want the new
> setting add a new file to the modprobe.d directory to change the option.

Not accurate, now I won't set any parameter because I'm relying on the
fact that the default is without SRQ. Once the default will be changed,
it will break my assumption.

>
> > Setting visible to user default won't allow us to change SRP behavior in
> > the future.
>
> No it doesn't.
>
> > I wouldn't recommend to make such option accessible by users.
> >
> > Thanks
> >
> >>
> >> Bart.
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnc4IIACgkQ5GN7iDZy
WKelZg//Q0hPj7VPFJ0rv7I6pWOW2xXdqk5TiLLkTMimZvhazsQkb+TVSw5P7/rO
dFFqjg+n+9ovYFVpa8e3FZR19ZvgKF6VPwYmwjCAqxLdUCnecbjZB5EwLL8FuPkO
ZtX3rMnwGh9gDLbiVV9RPyrXgQ60qbdCfWEUdClF8/lTAj91mb2NO9Y8Eb2J/6+C
hV4HddliHz32gIfXPQebKq/UUmuv0x6Z01KrgLf/zFAp3XNTSsDbHO8o9rfanE9K
VJJ61QLHyR8pQEvij8eJs1BfJgFEDcD8VjHVA8mFfJVi1AVT6i/mURBF/VP/tOHf
Wux/wbnPyvgk4Yyx2sxrHppqxct0rAR/4ch9wyYC3qDs2u2kPnvXN63Mk+iW/9Lu
8R/3hvPQuFTRJYqkI700301+W9IBCNJkZylGIpB2SB3TPOHrggvUtH8Oq+9jU2pk
sKDZqO+2GUPQ+AWQJjYycBrc6B6UxDUJSMoCXVd5pPDshlqp7hXC5EZqdOYDLA7N
2sJqvypCUrEXNaKYo6YKUdHZdA0I/5VBEz/Acc77Cczp2erYvJ7E3VhmHZQJ5xIZ
xAlJ5av+fyUmT+O4/MOU+OyyAEXHZodE58UKqbqAMz5CSYeDwXm3qS/XfgZ4c6dE
NlxXUjQA/lJafD5a8vjiaY8ECeGQJiOO+f3VxxjL/96NU9Oz4G4=
=vclc
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
