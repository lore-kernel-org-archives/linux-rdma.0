From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB core: 64 bit counter support V3
Date: Wed, 23 Dec 2015 14:33:24 -0500
Message-ID: <567AF704.3020804@redhat.com>
References: <20151221142026.238104419@linux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r94CBN189K4pPVGt4XactdiVNE5xamJpU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221142026.238104419-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r94CBN189K4pPVGt4XactdiVNE5xamJpU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/21/2015 09:20 AM, Christoph Lameter wrote:
> V2->V3
>   - Also add support for NOIETF counter mode where we have 64 bit
>   	counters but not the multicast/unicast counters.
>   - Add Reviewed-by's from Hal.
>=20
> V1->V2
>   - Add detection of the capability for 64 bit counter support
>   - Lots of improvements as a result of suggestions by Hal Rosenstock.
>=20
> Currently we only use 32 bits for the packet and byte counters. There h=
ave
> been extended countes available for some time but we have no support fo=
r
> those yet upstream. We keep having issues with 32 bit counters wrapping=
=2E
> Especially the byte counter can wrap frequently (as in multiple times p=
er
> minute)
>=20
> This patch adds 4 new counters (for full extended mode) and updates 4 3=
2
> bit counters to use the 64 bit sizes (for NOIETF and full extended mode=
)
> so that they no longer wrap.
>=20
> Should the device not support 64 bit counters then only the original 32=

> bit counters will be visible.
>=20
> This patchset can be pulled from my git repo on kernel.org
>=20
> git pull git://git.kernel.org/pub/scm/linux/kernle/git/christoph/rdma.g=
it counter_64bit
>=20
> Thanks to Hal Rosenstock and Ira Weiny for reviewing this patchset.
>=20

Hi Christoph,

I've pulled this set in.  However, two things would be helpful in the
future:

1) Prepend the area you are patching to your patch subjects.  Aka, you
put IB core: on the cover letter, but the individual patches did not
have that.  They should (and generally I would use IB/core:).

2) When assigning a V1/V2/V3, pass that as part of the --subject-prefix
you give to git.  When you use it on the cover letter, patchworks drops
it entirely (patchworks does not keep cover letters, and does not
transfer v1 tags from cover letters to the subsequent patches).  This
makes it *much* easier for me to pick out which of your patches in
patchworks are the most recent.

Thanks ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--r94CBN189K4pPVGt4XactdiVNE5xamJpU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWevcEAAoJELgmozMOVy/d7OwQAL7GtRm/UtunLrgr0Wgib9bb
PhJ/f6O1kiQn+n9Qlo2DfcWcSAYn2rHAtuFU1rdfVfZ18Q7ayh4OES5t5VJ4kYz+
bSUXwV+fdVpHxJUWxk2PDlniZUMNIk002ccORqJp71ctkKbq3m/mI0JtufYoKWDE
i3oKiNh567Ig9uE0+nK2ioGalH7o/dNQkr7jJagdDRM0TG0abz/5LZSwFP4lPv3J
UFt9Bj1lYNbYeFrnn7GSRtKF18qAAklLB9rJc0aaYt1Ibn1y6T9mHKzFtztVRiba
5BA9aBaWNt4VEq8DI8wLwtx/n0FtWW+OedbUdT6Fb3akbbbo5GF72SkSF61QHJpx
bmrx8cxGMryACSJssvytgK4qhzWMoudegi2yXfXKIEg9SnYY+/841tYTCIoccBIF
dLXSUcjb0MhYTx6iguhbG56DKqBMrCnR0s9/rbq2c40Vyb1gUbh4H5yhMXHCmw4h
Yd0f5veemuCwhQEuCMQK9hOE1Ervlqt5xU9Vjlg0+P82C9e8kCsmM1Qyc4heM6oi
xJrqJe7VMK8d80AmfwYq6JQY1noj1InbtvxVC4NLelqmHM0MAwAqt6ICU3Hutmsk
odE5dIRrHDgMaPCskxOQBuvyDxa7yg6AmRJvK3kh370fl+fbA8Mtn3Qeo398fIPj
DnX97ZhyjAH+s0RWm9d7
=uwHW
-----END PGP SIGNATURE-----

--r94CBN189K4pPVGt4XactdiVNE5xamJpU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
