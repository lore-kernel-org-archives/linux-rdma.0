From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/4] ibacm: acmp retry issues
Date: Tue, 14 Nov 2017 21:40:35 +0200
Message-ID: <20171114194035.GJ18825@mtr-leonro.local>
References: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
 <20171114184603.GG18825@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E86639F0C279D@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CZSH3HuPF+BTlXjX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E86639F0C279D-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CZSH3HuPF+BTlXjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 07:10:45PM +0000, Ruhl, Michael J wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > Sent: Tuesday, November 14, 2017 1:46 PM
> > To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH v3 0/4] ibacm: acmp retry issues
> >
> > On Tue, Nov 14, 2017 at 11:43:00AM -0500, Michael J. Ruhl wrote:
> > > While testing the retry mechanism for the acmp provider, I observed
> > > that the retry event_wait() did not appear to be working correctly.
> > > After studying the issue a bit more, I discovered that there were a
> > > couple of issues.
> > >
> > > This patch set addresses those issues.
> > >
> > > v2 - added patch for MONOTONIC time base
> > > v3 - Updated and cleaned various type cast issues
> > >
> > > ---
> > >
> > > Michael J. Ruhl (4):
> > >       ibacm: Fix an incorrect expiration check for the retry timer
> > >       ibacm: Calculate correct tv_nsec value in event_wait()
> > >       ibacm: Fix a retry loop calculation race condition
> > >       ibacm: Use MONOTONIC time base to avoid timer expiration issues
> > >
> > >
> > >  ibacm/linux/osd.h          |   25 ++++++++++++++++---------
> > >  ibacm/prov/acmp/src/acmp.c |   12 +++++++-----
> > >  2 files changed, 23 insertions(+), 14 deletions(-)
> > >
> >
> > Can you please use [PATCH rdma-core ..] format for rdma-core patches?
>
> Hi Leon,
>
> Yes, I will reformat.
>
> Is there a place to put patch set version information?  i.e [PATCH rdma-core v4, x/y]?  (should I just drop it for this patch set?)

1. There is no need to resubmit this series.
2. I'm looking for "rdma-core", anything else (versions and locations) is up to you.

>
> Thanks,
>
> Mike
>
> > We are using patchworks to handle queue and it is so handy to filter
> > patches in such way:
> > https://patchwork.kernel.org/project/linux-rdma/list/?q=rdma-core
> >
> > Thanks
> >
> > > --
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CZSH3HuPF+BTlXjX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLRrMACgkQ5GN7iDZy
WKcBqw//Wl2jH/kdYZW52Ic3H2ZW9vjdI2JK5q1E46meRzoTFDY86mo89AKoWehP
qNMqt7C48nsMQQxm9H4jE5m518IH8isea16guaYT2hWHrC5zGQEaYnJyuQFHE4sC
Z1q0pTV38lAlpcTTrY+DAnLAgTjU5nF/gq6UUGM5YY9BBVjlktor1kjrdCFvGL1+
sC4cP0PuPAC2Jz0LP3zuuxP2Mt3G+0h0t4fxftc4UFEjGgksCa9Aj6wxCJEAoGhy
GUqIf/mFdhNrdCYSrxF8pskRSJOVxCJzJdim+xTHR8TOxmwRowXGSLqvq0xHcS/E
Nxc6wh38/OtaTeRcC0LYbRnP2IAXcsNWqL5EYvKdKfcdhjrzWNQQSiYk0w1DVBrA
ykGAHC7njHPFubgBi+jL1K+61t5jhZF0seCncq+ARBznd/hRUoWiiUHAxS0shUNt
iSNELFLkUyQC8rLFRlRIS2oluPkgbEZreiemFUAMuDcWmk8Yr8xQy6o0gQrmw9d7
p1iMDhIPKheaObTOiTfjAZayFMK3PX/XKReKVmUdqk99QLupEf/sGBEpJkRX/3eg
lE7RHmlBanR2rWRKztX2wzUiSvCRiv1En8WpvIqEYptlOBo6uFByVvs2g+FScAnY
xo9wd+l8enXCPAmnCb/p8G3UUflEfWpfxzBNCoBcrr6Gs8OL/MM=
=2I72
-----END PGP SIGNATURE-----

--CZSH3HuPF+BTlXjX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
