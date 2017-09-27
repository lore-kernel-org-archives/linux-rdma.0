From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Wed, 27 Sep 2017 09:20:19 +0300
Message-ID: <20170927062019.GB2297@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926181214.GA41364-wPcXA7LoDC+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 11:12:16AM -0700, Vishwanathapura, Niranjana wrote:
> On Tue, Sep 26, 2017 at 08:55:24PM +0300, Leon Romanovsky wrote:
> > On Tue, Sep 26, 2017 at 08:49:46PM +0300, Leon Romanovsky wrote:
> > > On Tue, Sep 26, 2017 at 07:08:37AM -0700, Dennis Dalessandro wrote:
> > > > Hi Doug,
> > > >
> > > > Here are the other two patches for opa_vnic. This adds a debugfs interface and
> > > > that is why I'm sending it as a separate series apart from the rest of our
> > > > submissions. The goal is to support view/modify of the VESW port config.
> > > >
> > > > Patches can can also be found in my GitHub repo at:
> > > > https://github.com/ddalessa/kernel/tree/for-4.15
> > > >
> > > > ---
> > >
> > > Can you elaborate more on the reasons why debugfs was chosen over more
> > > generic configuration tool?
> > >
> > > +DEBUGFS_FILE_OPS(vport_state);
> > >
> > > Maybe, I'm too biased with rdmatool, but I don't see many reasons to
> > > introduce debugfs for the ULP.
> >
> > And honestly, netdevices have so much tools to configure them (ethtool,
> > iproute2, e.t.c.) so I completely don't understand the rationale behind
> > debugfs for OPA-VNIC.
> >
> > Thanks
> >
> Hi,
>
> The debugfs interface here is for VNIC port encapsulation configuration.
> They are not related to netdevice functionality.
>
> They are for debug purpose only and not the supported configuration mechanism.
> Hence, I think they probably shouldn't be in a tool like rdmatool.

Usually, there are two types of "debug":
 * One time during development and such thing shouldn't be part of upstream code.
 * During the daily work to understand misconfigured system and this is
   usable for all users of that feature.

There are exceptions to this rule, but they are not relevant for the
general ULP which is supposed to work on all OPA-capable devices.

Thanks

>
> Niranjana
>
> > >
> > > Thanks
> >
> >
>
>

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLQyMACgkQ5GN7iDZy
WKel9w/+Peig8MsTdiBWZUFhHlh8vPSHuSuk0zS7LB8B9L1qvKyt+qez9odn1jvq
HKAvxwRlYTQhny/9Pk/1qa1iWvouYV6AhqjXQ0k4qpzy2dlOuJ9h8Bc6hVSI0bKW
iS5WXn5WOLPB3Z0EtWeKC+cMwS42pAas2A7u81qOIJORy3zKHTl7sLrEj4EfHXD6
BUkInNnyKuCvWxav+rh/5lmzswrMRtCRx2y9Viwgvx9qsJq8hRwevnqVvEzf1RAn
5/wf2vBOmEf+91fwhyj2jQeVzhIlHtZHKTqPBdzkDlXDK9OmNBHbt3R7st8Lm4Pu
G9EqCIOp72NB0XX+OlXeDoKXJ4phUVlQJjXXMdSExuZ3SXtSPUNr6wBfwDMj4Y7p
L/HZzRwD3ymOmitiJ38IhW3IGtLf1LGs9mbVAuBY4IpGpatDliXmqow30gMuk+/c
jMvOVtpMy2TFAF8MjSvUYlnoQH4qS2q7uiSW6KmcND/1SvcTfYb0noYpH42/8IFe
RU88j8XqHld0B9wknbjXhrd2YOrQoZ4vFQE1ms7TH4n6WqFHx1y2/ZLAtdBa63qz
UZZeWFHvgUX736nV2yVquRm1HxD88jKf3JaY1SUt8ZnoiIpEm3LrmT3FwWwwWilU
Sa/vrVpdgoIQahgz3TGQ1JTkcFC8j1HBghhnIGol3XeBheuXIdc=
=1UAC
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
