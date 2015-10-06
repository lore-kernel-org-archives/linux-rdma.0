From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Tue, 6 Oct 2015 17:26:38 -0400
Message-ID: <56143C8E.9090407@redhat.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
 <CAKHjkjnQNqeLu+irEg97a1hcKp_ziXsDOFaTRwcaPpZAX_fMng@mail.gmail.com>
 <560AD75A.7080700@redhat.com>
 <CAJ3xEMiuPEJZ5EQueC=8wQyok2QbEaywQ3gRYVpqOwSaFQcj0A@mail.gmail.com>
 <5613F145.3040204@redhat.com>
 <CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3ns9kPCKT183D2PsL3gq55Mi0GRMR6g2H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhsr5uRLZ=Ur56TOpZy5XT3UbK=M1kcgjt=zx_x3HNcSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3ns9kPCKT183D2PsL3gq55Mi0GRMR6g2H
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/06/2015 04:54 PM, Or Gerlitz wrote:
> On Tue, Oct 6, 2015 at 7:05 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> I'll have some sort of answer for that soon.  I spent the better part =
of
>> last week, and what time I worked on the weekend, plus all day yesterd=
ay
>> on the internal infrastructure here at Red Hat.  We're experiencing so=
me
>> growing pains in our cluster and some downtime as a result that keeps =
me
>> from being able to test code effectively.  I wouldn't be surprised if =
it
>> takes another day or two to get it completely sorted out (or sorted as=

>> best I can, some things are out of my control).  Then I have to see if=

>> any of the currently posted fixes for 4.3rc that I haven't grabbed yet=

>> resolve the iSER issue I'm seeing, then I'll move on to for-next proce=
ssing.
>=20
> Doug,
>=20
> From my experience with VPI (IB/RoCE) clusters, librdmacm/rping is the
> answer... namely -- if you have **rping** up and running over kernel X
> for both IB and RoCE, things aren't in such a bad state. If you want
> to go deeper, have it working over IB non-default partition and
> Ethernet VLAN.

Nothing so simple unfortunately.  And it isn't an IB/RoCE cluster, it's
IB/IB/OPA/RoCE/IWARP cluster.  Regardless though, that's not my problem
and what I'm chasing.

> Also, for IB multicast, mckey with IPoIB port space, iperf multicast
> over IPoIB would tell you how things are.
>=20
> So all to all, sans SRIOV, it should take you whole 20m to figure out
> if something is really DOA over IB/RoCE HW and I believe iWARP too
> (rping) - makes sense?

Yes, I know how to do DOA testing.

> What we do know that needs fixing for 4.3-rc
>=20
> --> RoCE, you need the patch re-posted by Haggai few hours ago
> "IB/cma: Accept connection without a valid netdev on RoCE" -- without
> it, RoCE isn't working.

I have that already.  It's available on both github and k.o and just
waiting for a pull request.

> --> **mlx5** devices and no-default IB pkeys, Haggai and Co are
> working on a fix since this isn't working since 4.3-rc1. I told them
> we need it till rc5.5 (i.e few days before rc6 and if not, will have
> to revert some 4.3-rc1 bits.

I already have on patch related to this in my repo as well.  The 0day
testing just came back and it's all good.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3ns9kPCKT183D2PsL3gq55Mi0GRMR6g2H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFDyOAAoJELgmozMOVy/doEoP/3um9rNsEITRHgS83yAJZ/+0
Az1AqvHEH/jofl8ha1Q95R47UIs3PZWCwE5GLzdSfdQiRqDX/BK0e0qCmsoh1nT8
b2CbzTtMpHA893Q04Tkz0G8r+YYESSP1WdXCVX2YAxNe2F9v7SdgOrYoA5U1XKDH
Nt4ni/XMj6J8tTl+Oe+YhtMdXf3TJEbMiR05OKYP4IT7KlPpeoHqU9Gv+mF2GX/2
haHU8TVZ4nU2q3CmctodCrh1D7OC0piQ7uIG0eLYbyppTZUsYjZ2ff9qdFe95V61
RQN3o/ho7T2C0XmC4pc8xDdHBh4oMVXOaFQY9JG5BWBTlU4OwqicCY3grntbs/g1
hl53YikcUwSb9VcUtMZsRcCUef0neLKe1owaPdv79zmtnIzl+LADQZVI4Mx5Wx+C
U/2wTywxe1fguu1QJJ9qqE5EdiKcPo5sBwivv4AKZ8tmew0IHMVPsQigCZTcA42S
FaCpLxyp8b7JKA/YB6lQYkS63RKq2kJeQkcej/GZopG4KcauqmFdqIDeAv9PGORS
G6EXxBlt26kmjC2dCEkB22yu1VO5p0ynR4h6c2znapXiMs9b6UimXLKf4VO7EIgf
1IIR+P2+bqouoTQPGNaNnYIVxbzwIJTTtuLt6zGV3yFS33nzIkjfXqUNw2wHY4Vb
Ix6XSbJTAFKGwiXcuqjZ
=Av7I
-----END PGP SIGNATURE-----

--3ns9kPCKT183D2PsL3gq55Mi0GRMR6g2H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
