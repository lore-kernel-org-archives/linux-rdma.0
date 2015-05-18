From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH RFC v2] Documentation/infiniband: Add docs for
 rdma-helpers
Date: Mon, 18 May 2015 12:58:11 -0400
Message-ID: <1431968291.3114.13.camel@redhat.com>
References: <1431938505-31779-1-git-send-email-yun.wang@profitbricks.com>
		 <CAJ3xEMgkrUgSvRV7m_M9CE4w66Wyk-Svnfejvavj38iTNyH9HQ@mail.gmail.com>
		 <5559B997.1030502@profitbricks.com> <1431962485.3114.8.camel@redhat.com>
	 <555A04C8.10802@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wYLeACg5xzs23bHAFzMP"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <555A04C8.10802@profitbricks.com>
Sender: linux-doc-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Or Gerlitz <gerlitz.or@gmail.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org


--=-wYLeACg5xzs23bHAFzMP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-18 at 17:27 +0200, Michael Wang wrote:
>=20
> On 05/18/2015 05:21 PM, Doug Ledford wrote:
> [snip]
> >>
> >> I'll put the highlights and changelog under '---' in next version, is =
it
> >> looks like this?
> >=20
> > We're still missing Jason's feedback request though.  Specifically, he
> > pointed out that kdocs are usually not done in Documentation/*, they ar=
e
> > done in the .c files where the function is (or the .h file if the
> > function is an inline, which these all are).  So, you included some
> > limited documentation for each of these items in your original patches
> > that added them.  His request was that you put this expanded informatio=
n
> > not in Documentation/infiniband where someone has to go looking for it,
> > but as part of the kdoc header for each of the various helpers in
> > ib_verbs.h itself.
>=20
> I see :-) I've not work with the kdoc yet, not sure if there is any
> guidelines on how to write the header of inline func for kdoc?

It's an automated tool thing.  Any comment section that starts with /**
is automatically included as a kdoc.  Then there is an expected format
after that.  See Documentation/kernel-doc-nano-HOWTO.txt.

> >=20
> > Just because I want to move this along versus waiting for another
> > respin, I'm going to copy and paste these into those locations and clea=
n
> > up the changelog when I integrate this patch.
>=20
> Got it, if there is anything I could help, please let me know ;-)

I'm sending the patch for review, please let me know if you are OK with
how I handled the attribution.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


--=-wYLeACg5xzs23bHAFzMP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVWhojAAoJELgmozMOVy/d6XwP/jG6PxdMFdiVVIBLDyJeuTI/
f3M7NcZZDfeXZvWiaTtD08OB827Le/rq9j2CDvrdXTD375jQa79CcpumM82DDNOh
UOQZPLm5yD59Ri1RWuDE0tHoJHoq4Wn0T3DeyBvbAISAzcpUWrUiafSFRrHkvB6G
NasN0xLh0nAl8I9XB4CBxIB8D8y/TNX/P6S9ZJVggFcG33Q2LH1VZhxHdbOsTzZH
6DzCdQkkac1M8xTu9pGHm2kGAaq/dtN38TQNGxnv2zn7sDy/48ihF0GbzFhko6TF
IJ0ZjwqgvjTA3kHlcRNx3G9NSnVS6lvL28o1ocrrIg2K7KMvJm6bhyR+QxuYIltw
PQ08DtSR4/PCB61prXFb9bv54FTKZbrstSgi23PxWau0Es+rVHrN1JmBQy1wWbi/
s2hRTt+h8+z+uo4+omJ71ytQb7UGpNQvFLMoaqpV3QPscjeoRt1fTJBTn8m/xRkV
lYVRz30JJl3iea06hMFH9tHkd1RcM5BiO+tzqyBToahQyJCuPfhtUE7jLUmDJ/2R
zodmtH+eGDBdiU06SqWvsZztJsBZBF+R7H0ye0/AziYE+OTGzn++ySL59gixiGUX
SUf6bsZqjFdADYgqVBXz2w6gccaLWsu/vAjJsb6Tqhxme3sF9SXsbk+y1iwvG2An
TvasfqlNsJ+Hdsc6rRjG
=QX6b
-----END PGP SIGNATURE-----

--=-wYLeACg5xzs23bHAFzMP--

