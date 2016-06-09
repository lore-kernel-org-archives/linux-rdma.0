From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V5 libibverbs 0/7] Completion timestamping
Date: Wed, 8 Jun 2016 21:35:55 -0400
Message-ID: <4bccf342-d463-d33f-96e5-83967bfadc4e@redhat.com>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
 <1b0ea11b-3762-2335-28dd-eb3ac243104e@redhat.com>
 <20160606233325.GA28769@obsidianresearch.com>
 <bd0b54e6-70ae-27b3-fe1e-8ee729e20479@redhat.com>
 <20160608191412.GA27089@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="auB2jfjThbrwwK2eReJOnKq1RkEr62NiS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608191412.GA27089-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--auB2jfjThbrwwK2eReJOnKq1RkEr62NiS
Content-Type: multipart/mixed; boundary="dr6lhoHP8ePxPDI3MmirHINsRi4LbDXBC"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <4bccf342-d463-d33f-96e5-83967bfadc4e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V5 libibverbs 0/7] Completion timestamping
References: <1464786340-7630-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <1b0ea11b-3762-2335-28dd-eb3ac243104e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160606233325.GA28769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <bd0b54e6-70ae-27b3-fe1e-8ee729e20479-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160608191412.GA27089-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160608191412.GA27089-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--dr6lhoHP8ePxPDI3MmirHINsRi4LbDXBC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/8/2016 3:14 PM, Jason Gunthorpe wrote:
> On Mon, Jun 06, 2016 at 10:20:12PM -0400, Doug Ledford wrote:
>=20
>> Judging by the way yours and mines conversation went in v4 it seemed y=
ou
>> were pretty much in favor of it.  If you have specific objections,
>> please raise them, we can do incremental fixes.
>=20
> In favor of the general approach, there were still lots of details to
> be delt with, including what QPs can be joined, the exact set of
> accessors and enablement flags,

These items need to be settled before the next official libibverbs releas=
e.

> the compat layer,

This also needs to be settled before the next official release.

> minor coding issues
> and micro optimizations.

These can be done any time and does not have to be done for an initial
feature release.

> Fruther, there hasn't seen sign off from any
> other vendors which we said we wanted for these sorts of things.

An official release has not been made, and none of the other vendors
have really shown much interest in moving forward with this on their own
hardware.  If they have an interest, they still have time before
official release to bring up any shortcomings related to their hardware.

> All of these have been raised on the mailing list, but you killed the
> discussion when you said you didn't like the series,

And a discussion ensued.  In that discussion, it became apparent that
while I didn't like the way it was implemented, it was probably in fact
the best of a bad situation.  I didn't kill anything else, and
discussion continued in the v5 patch series.

> so many issues
> never reached a closure.

Indeed, but that's not to say things are set in stone.  There is still
plenty of time to fix things up if there are specific objections.  But
people now have something easy to build/work against, so if other
vendors want to see if they can implement this feature on their
hardware, they can try it out and if it doesn't work, send incremental
patches to the list.


--dr6lhoHP8ePxPDI3MmirHINsRi4LbDXBC--

--auB2jfjThbrwwK2eReJOnKq1RkEr62NiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXWMf8AAoJELgmozMOVy/dTIsQAKoamRZssl6LlwMErzebRUkZ
HRtluQ4RNZnzPdY45PgKWigN+EGc9/lFU+hiWvy9CNHhm34WR+wX4PMSUcqNVmyz
bzxjd5dOLktoCVVh0CPAGniv2tw3nid8FsDlLN/JQ3uM91wJidGaYWPyXZF5cxAK
Oq2dwSZtL4l3CDj/Zdw8Q5n+Aty05kAug/mcSK6OTvDypTAllAto5IwG19QqLuan
W88wUQJZO4hN+PALrwRKTmLG7Ni4Wzn2Xm9hKfqoO1SZTkCi5bGquh9b7YyqfADR
1GbXbToShmB0qhBKWEUZrmJfZKWAVWjBBU8VCNH6r9LUv5vRXg/nrLgv/MTDJryK
Tf4OtExCSn4F395wYCb4fnPmj2WIK+TXC11d4nqVzh5LnSA26fGnqoD76l867ZmD
01enSkpT86R0LhNFVaHWVi0YMkj2aSUI+0KaxKQaD5beJbkgs1NFKa3nTI7Cwsqp
+92A2qmsyaR6i8+OTXipqn0zLbN1DR7tbhNACDv7DvuZgrymZNlxTILYu8iRQY4p
c+Ta3jpEsReJ5+FGk9aEYZIuy1VBvCqLXDqqtiuYZNhjFXfVNSNerxmX+O+rvQxK
z/rJ8JlbU5Y3Hww/BcU4KN2xQtO0E83leeO8yAH72yxQWm/xBoEgmE5EIXQ/cGby
o2iQz0eNC64QKLwENe+l
=KjvV
-----END PGP SIGNATURE-----

--auB2jfjThbrwwK2eReJOnKq1RkEr62NiS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
