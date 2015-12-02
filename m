From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: stalled again
Date: Wed, 2 Dec 2015 15:10:13 -0500
Message-ID: <565F5025.2090002@redhat.com>
References: <565DCB24.7020304@mellanox.com>
 <20151202122927.GC28278@infradead.org>
 <20151202184201.GB17021@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Iu9jQowCut3GWM77C9LJCLnt8v2GOhF6T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151202184201.GB17021-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Iu9jQowCut3GWM77C9LJCLnt8v2GOhF6T
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/02/2015 01:42 PM, Jason Gunthorpe wrote:
> On Wed, Dec 02, 2015 at 04:29:27AM -0800, Christoph Hellwig wrote:
>> Maybe we need more co-maintainers if the two current maintainers can't=

>> handle the workload?
>=20
> Doug is the only maintainer. The idea of co-maintainers was rejected
> by some parties.
>=20
> Don't be confused, the other 'M' people in the MAINTAINERS file are
> really doing the 'R' job.

For certain of those, I defer to their opinion on any patches.  For
example, I deferred to Sean's opinion on the recent changes to the
rdma_cm in regards to it no longer being sync versus async due to the
RoCE changes.

> If Doug wasn't able to become full time on this project we should
> probably revisit that.

I'm more or less full time.  There is still some lingering work on my
part in terms of helping out my replacements internally come fully up to
speed.  But even full time I don't sit around reading mail and slurping
up patches all day, there are other aspects to what I do in my role now.

However, that's neither here nor there.  The real issue for the last
month plus has been the paternity leave.  Things still haven't settled
fully down at home and I'm simply horribly behind.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Iu9jQowCut3GWM77C9LJCLnt8v2GOhF6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWX1AlAAoJELgmozMOVy/dqngP/j09L07FmNYLEoWnGfjiQ+iG
cNWg/LxvUmwpqqGIxKisfPwPBPJA5QqJzKIs8ZGCtliDyrqvs4MUm2X/RIO3dhsB
j0qGd1KevMvAiMoMBmw3A9GhOtCAt+PZeQUUT56TpEHCFNV/WITa1ujzaH0G+PIm
6e+3nFnU/HsDihXlex2PQ4jV9m97tfge525zFKaj4pTZrWwMftJ4gTut6RtM+NTs
a/FtNuYHuciS4EJLoOOF5LMBH3JVgbTvx/rcQmh1gdF6Xz3PtSShLV48AiR5aqYE
05uHmG7iRORhh7DFtdylVkXuDqYuMysK8lgHUKVInJ/TnevYBpTnLr46hyyOI5cy
E+Unc1hohDPCxJPvyX1dZAt6Td87l3pFfv6j7u4x9rxpodBIXBIQw9CprH1Y3hfj
MMGhnpVF4XqUm2W9KlmGS4ijuaOU2U9uBLaU+XB99rWS6OMsnxn2Eq7Xlw+Yo+IM
4IuS+US0gCm7A7E+eebm8+XZihmI+bQpKqV2329AHakd+fcd7tlnlRvdcNbkuOif
a1eG89JwItQ3ZPoeDewgocmqW+DD6LCjgSrHc8EDx20ZjV8T4lIkTX7GYQqZPzhR
Hc4yif+uxiQPbLKVGD/RDa/d7x3B/hJJI4e5jdwVnON73I24cXlBCpj+rxgEtNmR
45N0asA9jprRV/qZxAqi
=eYE2
-----END PGP SIGNATURE-----

--Iu9jQowCut3GWM77C9LJCLnt8v2GOhF6T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
