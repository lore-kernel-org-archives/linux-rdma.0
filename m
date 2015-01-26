From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Mon, 26 Jan 2015 14:30:21 -0500
Message-ID: <1422300621.2854.38.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
			 <1422031938.3352.286.camel@redhat.com>
			 <54C4E793.2010103@dev.mellanox.co.il>
		 <1422224477.3352.373.camel@redhat.com>
		 <54C616A8.3050804@dev.mellanox.co.il> <1422276712.2854.5.camel@redhat.com>
	 <54C6400E.30607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bAqmGy4BQvY7VRPPaIJb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C6400E.30607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-bAqmGy4BQvY7VRPPaIJb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 15:24 +0200, Erez Shitrit wrote:
> On 1/26/2015 2:51 PM, Doug Ledford wrote:
> > On Mon, 2015-01-26 at 12:27 +0200, Erez Shitrit wrote:
> >
> >> New (and full) dmesg attached, (after modprobe ib_ipoib, with all debu=
g
> >> flags set) it is all there.
> > Thank you, I know what's going on here now.  Will correct shortly.
>=20
> welcome -:)

I munged my opensm configuration so that I could forcibly replicate the
situation here (I intentionally took several well known multicast groups
and forbid their creation).

I was able to first replicate Eriz's problem.

Then I installed a new ib_ipoib module with my proposed fix for Erez's
problem and it worked exactly as expected.  It was a mistake in one of
my earlier patches (the third in the series).  When I added a delayed
queue of the task thread, I didn't have a separate work struct and
instead tried to queue the same work struct twice.  I reworked it so
that the work struct is only ever queued once and if the multicast task
gets to the end of its run and there are delayed entries waiting still,
it will queue itself to run again when the shortest delay has expired.
I'll send that through.

Here's the log of the attempt:

[root@rdma-master linus (firewall/for-rc)]$ dmesg | tail -10
[337072.429488] mlx4_ib0: successfully joined all multicast groups
[337073.856932] mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0002, starting sendonly join
[337073.869686] mlx4_ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0002, status -22
[337073.882754] mlx4_ib0: successfully joined all multicast groups
[337088.480082] mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0016, starting sendonly join
[337088.492789] mlx4_ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
[337088.505819] mlx4_ib0: successfully joined all multicast groups
[337089.897041] mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0002, starting sendonly join
[337089.909870] mlx4_ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0002, status -22
[337089.922893] mlx4_ib0: successfully joined all multicast groups
[root@rdma-master linus (firewall/for-rc)]$ ping6 -I mlx4_ib0 fe80::211:750=
0:77:d3cc
PING fe80::211:7500:77:d3cc(fe80::211:7500:77:d3cc) from fe80::f652:1403:7b=
:cba1 mlx4_ib0: 56 data bytes
64 bytes from fe80::211:7500:77:d3cc: icmp_seq=3D1 ttl=3D64 time=3D77.6 ms
64 bytes from fe80::211:7500:77:d3cc: icmp_seq=3D2 ttl=3D64 time=3D0.159 ms
64 bytes from fe80::211:7500:77:d3cc: icmp_seq=3D3 ttl=3D64 time=3D0.125 ms
64 bytes from fe80::211:7500:77:d3cc: icmp_seq=3D4 ttl=3D64 time=3D0.128 ms
^C
--- fe80::211:7500:77:d3cc ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3001ms
rtt min/avg/max/mdev =3D 0.125/19.503/77.600/33.542 ms
[root@rdma-master linus (firewall/for-rc)]$ dmesg | tail -10[337120.632427]=
 mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,=
 starting sendonly join
[337120.645166] mlx4_ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0016, status -22
[337120.658292] mlx4_ib0: successfully joined all multicast groups
[337121.977733] mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0000:0000:0002, starting sendonly join
[337121.990478] mlx4_ib0: sendonly multicast join failed for ff12:601b:ffff=
:0000:0000:0000:0000:0002, status -22
[337122.003589] mlx4_ib0: successfully joined all multicast groups
[337130.410559] mlx4_ib0: setting up send only multicast group for ff12:601=
b:ffff:0000:0000:0001:ff77:d3cc
[337130.423203] mlx4_ib0: no multicast record for ff12:601b:ffff:0000:0000:=
0001:ff77:d3cc, starting sendonly join
[337130.436327] mlx4_ib0: MGID ff12:601b:ffff:0000:0000:0001:ff77:d3cc AV f=
fff882027235f00, LID 0xc01e, SL 0
[337130.448970] mlx4_ib0: successfully joined all multicast groups
[root@rdma-master linus (firewall/for-rc)]$=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-bAqmGy4BQvY7VRPPaIJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxpXNAAoJELgmozMOVy/dEpQQAKGhWGj1Rn7w2OXL94vELfdt
hUHTvVDuYESj6LcQ97uxNmoqysLBTvk5kfsxwymrpJAly5cLyW74T6v2QiESPM4I
OO2aqa8BuIjrCrzarEl/sj3QUYuHFEg9VDfxvkKbvRJ8cYJFEOmysDToPKKgw1rt
tnHDH7DwUnc1io5XbW6Ia3bAd01hUp6wwZZZKF1CZsU4PUAQrK+7tBejFrYvU4Tk
0ASdL2HuWihtTtb+cMh6kBq7mEcux+udHNqw9HlFr1Kghx1HgB0al2AHpFF/0NCk
+uaVQbJXnFwrRRCIU7mE8psT1TbyM9twGIvj+SDlGLBwgiMiqZZw9Tw+cnZze/Yb
ErpTsl9R7Y3WL4V0Nu3js1+8wsZ1qtFnzE0DTJN8PVPH/nxTsa2kRuM3XCAarEQU
mw/rrAG18mwhHTDv2XX8l07iwWjz4FqzNMHyLgtcehM0d70m3nkvOPJfdrZsnSGI
EfO86n5m6a2b8+MJpxCGOaF2sz5uh5oliQRzkXIQmFSsxXFivYucDUu2J/DcPwib
mdrvYOHqDRCgYfMg189s561y4sFIyBwAKMBtc3dFoXjkbxS/3UfvcWMtwPSySZo2
OZqk0NtU1Hzh5QYAyTr6CPBYtXZ/5hacU8n/lCTYr2WTYRCDiiAPdeWgyAFCEpq6
AtuNeonp45ya9x3SAjs+
=N3Nb
-----END PGP SIGNATURE-----

--=-bAqmGy4BQvY7VRPPaIJb--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
