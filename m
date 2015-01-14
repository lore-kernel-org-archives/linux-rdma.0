From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 11:09:22 -0500
Message-ID: <1421251762.43839.249.camel@redhat.com>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>
	 <54B692FB.1010904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iVUywuV/q81eIldLg6my"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B692FB.1010904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-iVUywuV/q81eIldLg6my
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-14 at 18:02 +0200, Erez Shitrit wrote:
> Hi Doug,
>=20
> Perhaps I am missing something here, but ping6 still doesn't work for me=
=20
> in many cases.
>=20
> I think the reason is that your origin patch does the following:
> in function ipoib_mcast_join_task
>          if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
>              ipoib_mcast_sendonly_join(mcast);
>          else
>              ipoib_mcast_join(dev, mcast, 1);
>          return;
> The flow for sendonly_join doesn't include handling the mc_task, so only=
=20
> the first mc in the list (if it is sendonly mcg) will be sent, and no=20
> more mcg's that are in the ipoib mc list are going to be sent. (see how=
=20
> it is in ipoib_mcast_join flow)

Yes, I know what you are talking about.  However, my patches did not add
this bug, it was present in the original code.  Please check a plain
v3.18 kernel, which does not have my patches, and you will see that
ipoib_mcast_sendonly_join_complete also fails to restart the mcast join
thread there as well.

>=20
> I can demonstrate it with the log of ipoib:
> I am trying to ping6 fe80::202:c903:9f:3b0a via ib0
>=20
> The log is:
> ib0: restarting multicast task
> ib0: setting up send only multicast group for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016
> ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff43:3=
bf1
> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=20
> starting sendonly join
> ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (status =
0)
> ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88081afb5f40,=
=20
> LID 0xc015, SL 0
> ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (status =
0)
> ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff88081e1c42c0,=
=20
> LID 0xc014, SL 0
> ib0: sendonly multicast join failed for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=20
> starting sendonly join
> ib0: sendonly multicast join failed for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=20
> starting sendonly join
> ib0: sendonly multicast join failed for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> ib0: setting up send only multicast group for=20
> ff12:601b:ffff:0000:0000:0000:0000:0002
> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=20
> starting sendonly join
> ib0: sendonly multicast join failed for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> ib0: setting up send only multicast group for=20
> ff12:601b:ffff:0000:0000:0001:ff9f:3b0a
>      >>>>>> here you can see that the ipv6 address is added and queued=
=20
> to the list
> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=20
> starting sendonly join
> ib0: sendonly multicast join failed for=20
> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>      >>>>>> the ipv6 mcg will not be sent because it is after some other=
=20
> sendonly, and no one in that flow re-queue the mc_task again.

This is a problem with the design of the original mcast task thread.
I'm looking at a fix now.  Currently the design only allows one join to
be outstanding at a time.  Is there a reason for that that I'm not aware
of?  Some historical context that I don't know about?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-iVUywuV/q81eIldLg6my
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtpSzAAoJELgmozMOVy/d9FMP/iS0yBcNofAu1d/vf2VqsBOS
3V1sQliZKr9VunFX3Bqd9j38+NgEsGuhucSBGoE4un1zoE+tPF+GpvNNXu03lpPG
0FI+EWgnWWBIdjwIXP3wGqGocykOu8qInQFwUUW4xmocWn/uLhfB6VF0HJMwdh6e
lhtWOkCjx8fhpamHrpcS0X1JOxZI+/DMHpRCRL4C6aNM6YABYrNtLByGIrG6wyOV
S1ppjHLayG8sNpjiS1F1x7Sr0SfRK3lek/JfW1ekCsRc5XPnjLPIWPPPxjz1LyzO
5+eWWFt+w8hhu3wJLGw0yzEJEz/zvo5gBfxHuh0ODMDzycgN+34DvaZ8WMI/OmY1
e48xOkwu2ScV9ZF+DBGi6UZ8kzJuVl0dP8JvfRYF6N4EIch/X8RZtVV8DzuAdl0V
QjKIa+8rU0KLPdKnrIkB9g2rUk7Nc2gq6YyQyWGQBeLRA/qeTvbzlh4jEmzFU1pL
D9E2DVNfuaHCOtl1D+OQmhyHgmwIrap5hovERgr4L+KoUKLKMbLqzW84NhuPsj72
NJ2hfQ7Ka4qkeNVx+dQK6qpXKOYjgdxuNPfWXHtqRDat1EprS273w7rA/Ay0EVI/
8J1hchGmv51Z9zgs99jk0CC4LXNxH2MSyBJY2zyAkAEzO1aIhGtYsFgpBEoD1jll
yA7H6MlfiBEzmpIJfJLD
=BUpg
-----END PGP SIGNATURE-----

--=-iVUywuV/q81eIldLg6my--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
