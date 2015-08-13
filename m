From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 13 Aug 2015 09:07:14 -0400
Message-ID: <55CC9682.1020203@redhat.com>
References: <20150806162438.GA27608@infradead.org>
 <55C393A0.6000002@opengridcomputing.com>
 <20150806173143.GA25497@infradead.org>
 <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
 <0B199DE1-B76A-44BD-91BC-E4285E439C70@oracle.com>
 <20150807063637.GE31458@infradead.org>
 <72E34077-7332-4F7D-8498-E67E7192CD2A@oracle.com>
 <20150807141929.GA12442@infradead.org> <55CBF6C1.8010803@redhat.com>
 <79BCB01F-AD69-4BEB-8F03-F5A52701211E@oracle.com>
 <20150813055450.GA19344@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hW5w0a2HxUaql839Ra4709ahpDxfOsEen"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150813055450.GA19344-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hW5w0a2HxUaql839Ra4709ahpDxfOsEen
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/13/2015 01:54 AM, Christoph Hellwig wrote:
> On Wed, Aug 12, 2015 at 07:24:44PM -0700, Chuck Lever wrote:
>> That makes sense, but you already Acked the change that breaks Lustre,=

>> and it's going in through the NFS tree. Are you changing that to a NAK=
?

No.  Lustre fits in my "languishing in the staging tree" category.

> It seems like Doug was mostly concened about to be removed drivers.
> I defintively refuse to fix Lustre for anything I tough because it's
> such a giant mess with uses just about every major subsystem in
> an incorrect way.
>=20
> Doug:  was your mail a request to fix up the two de-staged drivers?
> I'm happy to do that if you're fine with the patch in general.  amso110=
0
> should be trivial anyway, while ipath is a mess, just like the new inte=
l
> driver with the third copy of the soft ib stack.

Correct.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hW5w0a2HxUaql839Ra4709ahpDxfOsEen
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzJaCAAoJELgmozMOVy/dX68QAJI/hgP0oc7BC+PVbEx5kskq
iMWdMlW0fkD28IUXANZYeExSr07IgrDezKgSx4E3BJaNoq+GYIbJaTeLBXfLYsk6
kTtn/HfFwEkhgT7m9v6TtPO6lQtayl1jyinSn6dmkKm3OGUzWi4QiL4SLDzckrBe
Aj9XlxCJ+6zlZsb3bxQqi/7GI3CKrMY5HAx8w6SKjP/DZBns22nhgTHu+cVvxIqq
JSXUWsmByfeZ5c0kwJJDCtMj9wHpHkNMWX4l798BM6bKyegGKxd2EC49pSS64Rmz
H3eQd2mNE8tQiJj9unxa85niq7IBeKIQlms9tPoV2BYFxI6SOvd594R0VrFo8FD5
yWEkeD7Gx4y/EUc8A8AEXfqFLcQuU9ZfOC9rYSPU6XwXfO799hAjMsvcOaLsiVAn
817DGdiiJPmgjTd31Bw5Kp6jo/HcDCqMyIBaBTeEo4OHpuQ+VOEND5Ds8He4PFO0
6xkCeaP5ZMhYOuFcKJOx0jJDiMixLr6czOJAeRY02/ozQPPogwQ88BeK+ABHN3HN
/6FZJ190NanM7svLtccgeqNZzHz5IK15atwoiyu1ib7VSTEay3iRtOnKQgOG6dI/
9ky3tqRxgCvYHzXrEEDzH3fTxudDNyYwwsMS3Bd/WlhPw14x9OY/zVtQHZTwRhNR
vsVB9a95+5rv4mCMT9pH
=hEtY
-----END PGP SIGNATURE-----

--hW5w0a2HxUaql839Ra4709ahpDxfOsEen--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
