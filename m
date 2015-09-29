From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Tue, 29 Sep 2015 00:56:51 -0400
Message-ID: <560A1A13.8060104@redhat.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com> <5609A19A.806@redhat.com>
 <20150928211546.GA10311@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250B6A@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EmS8eR4uR608rlaUbQVKNdD1SQxmMkl54"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7D250B6A-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EmS8eR4uR608rlaUbQVKNdD1SQxmMkl54
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 06:08 PM, Woodruff, Robert J wrote:
> Jason wrote,
>> IMHO - we should be talking about getting to the point where we can
>> deliver the kernel rc and uapi rc together to someplace like UNH
>> and vendor internal labs and >expect them to test that pair.
>> Regularly, ideally on the kernel release time line.
>=20
> I am all for doing more testing earlier, but I am not sure that
> people (like UNH and the vendor validation teams will sign up to do
> it. This would essentially double their testing effort (and costs),
> first testing the user-space packages with the upstream kernel that
> is under development, but also still having to test what comes out of
> the distro or OFED. This is because it is what is in OFED and/or the
> distro that their customers will actually run. Very few customers
> actually run the kernel.org kernel, they run what is in the distro.=20
> And BTW, UNH gets paid to do testing, so someone would have to cough
> up the $$ to get them to add this additional testing.

I disagree Bob.

> So it all really comes down to resources and cost and being able to
> justify that doing more testing of upstream code is worth it.

Hopefully this isn't too blunt, but the EWG has the open source paradigm
ass-backwards.

Right now, OS distros (us and SuSE) do their own releases with their own
QE testing.

Upstream we have some people from different companies participating and
contributing code, but with admittedly thin testing resources devoted to
upcoming upstream kernels.  We catch some things, but I've also see
something slip through the cracks on mlx4 hardware in both of the last
two upstream kernel releases.

The EWG does its own integration and testing work for OFED.

Finally, the UNH-IOL does an entirely different type of testing, but no
fixes.

If an end users wants to know if bug X is fixed, then it matters who
found the bug because it is likely fixed in that group's product, but
not necessarily in the other group's products.  If a user needs both bug
X and bug Y fixed, and they were fixed by different groups, then things
are screwed.

That's not how open source is supposed to work.  That is not the best
use of all of our time.  First and foremost, we should all be
concentrating on upstream, because that is the work that pays off for
all of the people distributing this code.  You say end users don't use
upstream?  Of course they do.  No matter whether they use OFED or Red
Hat or SuSE or something else, all of them start with upstream.  Put the
effort where you get the most payback.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--EmS8eR4uR608rlaUbQVKNdD1SQxmMkl54
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWChoTAAoJELgmozMOVy/dIUMP/jQw3PZwINkspIeR9OxoB1YD
b1KAD+YNuOjd1gAQ6l5aamDxXbx3QNzuTZckLcHauq7GhqjEZuL6NLBYDlKZD9+H
N4xFv5kHS7lWEQBCX/Nz5/ER+Vxn8WwLqPVau6Jk92Gx9lq7NdzbKqNYZtpvQoYv
tF1cJQWdteYU+OVUHGl/LBAp0VIZd5pgOOoIV2p3E5gJmX7oeAi4GWo8DXzyn08c
BTFaWA7MmDHeihVhGzIbn7cb8VyApktzeHMTclkfcMCd6T9BMFg899kDKVbYXcF8
zDJWIAHIMINf8/bw1neCH5tByHS78kunW8ZTlo0o/u/DBW1mCzz73JyQBScHaXGQ
alW6yYoMfcbi2sGWUtSDCtBM3tTW2DI6CpZDYQYGS1OY+juzICTmEmekvdjfWi7z
/oXUD7QXOEKU7k00STcNyqmOxoRjkqOUiwTqB9iD9UUhxP6FMtctftavU1K+r3ys
QXzZLoRjlv7w1cfW7KDlSiSX96EtQT6KG644943xvEcRkS2jWc/rFVmJFV4F/Kn1
HR/lg27dHFTFztphDDI3ho+HN1/irMHKMQ2xyomAU7TFNFOuzlqgPb6+tBp1pc4c
sXEd94m8NAWhleF+EEPBQtfJfudNMuuqDz95nRs0eOBHJ2fhKw90edhsKS1J+WRt
+Tv6IMf3sqtaFu8Em239
=6EDY
-----END PGP SIGNATURE-----

--EmS8eR4uR608rlaUbQVKNdD1SQxmMkl54--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
