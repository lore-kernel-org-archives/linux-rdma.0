From: Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH] configfs: switch ->default groups to a linked list
Date: Fri, 26 Feb 2016 14:43:00 +0200
Message-ID: <87y4a7fxrf.fsf@ti.com>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456490031-7132-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jlbec@evilplan.org
Cc: laurent.pinchart@ideasonboard.com, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@lst.de> writes:

> Replace the current NULL-terminated array of default groups with a linked
> list.  This gets rid of lots of nasty code to size and/or dynamically
> allocate the array.
>
> While we're at it also provide a conveniant helper to remove the default
> groups.
>

looks ok to my eyes. For drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW0EhVAAoJEIaOsuA1yqRElmQP/3Si5u8oH05RSMkb8oPkr+HZ
Acn4F1BptGFHfWG/eGggHtzT50OMqOGK4uBobbObrYNAFL/9nV31dGED2HUeSVJi
wUSXzLo7Su0F2A3B90VEFkyzLJnlZqOOdTuvIHHjFxH2obrYRvuc7vJWJsuliF+R
WZJB1ldnhVxHQdKBtR4RRbhN4l5/krmFxeqrOuJ4SiD2PwdO2Fk0igISAoq5xYnp
4obS2J2ccx/xymwr1YVNURiq/hZ0L2Qt12wSx4PzWjZXw5+kEMH5UjEjbZPymzNM
WUY8++gd90G+o6M5uvXj+vp1htsspDUfc9nAMcJcJoRMzXui9VwuQL6zIlD1LeMP
CODhNQjmvHls19DmNwV/9q5c6zXahhVUHxpshQGlyWehW6iZZvjjn5D/uDHxiIHe
E7eWTYjqThY7jYyBdM/4f32sGH1q4m0ot4zKYvhkbrY3NhUsxCmxMsZX4asp8i/b
JxrzlM8pHQX60ReiBWb7OKDe22qerknZ41ApO+oc/I53hmSPHv7eYaQeVkUPgQXc
qslZemgaXa49L2XCOLfZU0p+s8P06uK7pedZvq00O7nyNCgUPaqtVP6sWdzTdw3k
oXHL4i8meSPrILBo0Oklj8yhQz5G68WXbjcDagtQ0jIiYyS+EsQuINQS3vKAqkkd
xGdnq5E7qfhvJp2qMSSc
=1LYT
-----END PGP SIGNATURE-----
--=-=-=--
