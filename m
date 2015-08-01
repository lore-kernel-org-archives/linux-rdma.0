From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Sat, 1 Aug 2015 16:05:29 -0400
Message-ID: <55BD2689.3080602@redhat.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150731223153.GA1518@obsidianresearch.com>
 <55BBFF03.7000505@sandisk.com> <20150731231430.GA1955@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rxbvFjKs2QQKK5Sp1trskudfVo54kN87A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731231430.GA1955-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rxbvFjKs2QQKK5Sp1trskudfVo54kN87A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 07:14 PM, Jason Gunthorpe wrote:
> On Fri, Jul 31, 2015 at 04:04:35PM -0700, Bart Van Assche wrote:
> =20
>> With only patches 1/12 and 8/12 applied my test passes.
>=20
> Thanks Bart!
>=20
> If you like, I can try and work on #9 (no promises :(), but I think
> I'll need some way to test it here.
>=20
> Do you by chance have a straightforward recipe to setup SRP and SRPT
> on two Linux's for this simple purpose?
>=20
> Doug, just drop #9 'IB/srp: Do not create an all physical insecure
> rkey by default' please, thanks.

I've pulled in the series for 4.3.  I've included patch #9, but that's
on the understanding that if it can't be fixed before the initial pull
request, I'll drop it at that time.  I have the resources to test this,
so I can work on it, and that factors into my path forward here.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rxbvFjKs2QQKK5Sp1trskudfVo54kN87A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVvSaJAAoJELgmozMOVy/dF6UQAMASRvd0p3uN88k1jlU1Oarj
spJzLhLG9Y7tUfvA4c4kd8Wb5Lw7nF2TxkMtURj2D9j8soVPbnZy31huC39gigfg
uPvKRiINZVnYf3gMOQzfHlK762Yt+DsgwZW5989zek+dZBu2rySv/dm0+df5QbuU
Mg/VhZGNmGcUxjNaByN8WtPWBVS/kVIULBLUbsyLTVq07CzY4TR8Tedyhqr38MHM
R5nGAy3VSwzzqo4ms7XVjfz1cOClei3Dq7DNDBMZW5Lha4Nu7QnSYw5fiHTQY1Io
aTOh51ZmTosk+i+fl//hDoHR+brGXbNI6/6XQbKDBIsNHX1TnXTrr9S/22DRQ9vz
QavH4nfk91Mq/M0ALNDVq2/W0jV0Bhs33QOv/QcQGEBG14K1gM4XUOfjSjqUl1/R
aesGudkJfZnH8Mi+B9byZ2UnO0QJLhT4sqtr2ygplARQq1Z7PKZC2viGNjM77Ln0
p2W0VYzfZmn46PyDsqurKsRADqRxw+NZRmqoMybfMs5U0r0xyusSjRGdo7XB2YNA
4OUrBwhUlNT7kWaceO8cAGRajAF2xbhjmckVdKVGMxDdQ2dxPQbh4sszqq/rCjMz
fL2bnI0QUYd7DkbqbIUaBpxx50CJwM5z3kQgnT/spSfq0ky1NjJr0A4LHLPKObca
BWcefiGx0DKW5Y8WzBma
=BMRE
-----END PGP SIGNATURE-----

--rxbvFjKs2QQKK5Sp1trskudfVo54kN87A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
