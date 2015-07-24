From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can
 exceed 32b
Date: Fri, 24 Jul 2015 10:44:53 -0400
Message-ID: <55B24F65.5040103@redhat.com>
References: <20150722191417.9306.17387.stgit@build2.ogc.int>
 <55B15D7D.3090601@redhat.com>
 <00d501d0c599$84afdb50$8e0f91f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wFNONn8gx1tMa3e7kpS91IWCeI0FuHLx0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00d501d0c599$84afdb50$8e0f91f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wFNONn8gx1tMa3e7kpS91IWCeI0FuHLx0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/23/2015 06:47 PM, Steve Wise wrote:
>> -----Original Message----- From: Doug Ledford
>> Should this be a static check of the pointer size versus installed=20
>> memory?  Would it be possible to have this work for machines with
>> less than 4GB of physical memory even if they have 64bit pointers,
>> or are you concerned that hotplug memory could take us over the
>> limit after registration and cause problems?
>=20
> NFSRDMA doesn't need dma-mrs for T3 since it has FRMR + local dma
> lkey support.  And since the deficiency really can cause problems on
> 64b systems if the memory grows > 4GB after dma-mr allocation, I
> decided to just not allow them for potential large memory systems.

Ok.  I've pulled this for 4.2-rc then.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--wFNONn8gx1tMa3e7kpS91IWCeI0FuHLx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsk9lAAoJELgmozMOVy/d/+cQAJv4UA2FDETT9hmzqn9nT41U
mMchuiT9m3OhekWo19gaTTXBSN5Jy9MvSw7cvcSA/JqYpHWsz2XOWTrufS05/QqF
f+pCzhrHvPlLvKOkh60xe2bUfi7t+7wyEDA7W3GXx5Nqo8ZO5sAtf3PcL14qdaaA
S/FrDnlyQZrV6ANW96VwiW8e7mBGZX90ukOTZFo+qWHqRgIblS7ZTwKwpzZHaczR
9C7Lp/mTJqMcOD+c9lNbYq1PJc3pb+FwstA3GhPV7HQP0oqN6/AuZ5ahGLNNyIoX
zPrcVVLfu2Sg+B7kSvs+RraJmB+AgqEk1+X+uxs8YXfdRu2VL/ZHAxyllvymvKyo
n/c1B+++y6A7NnzVMcqCBqniKIRvHHfM0YeRwAlUU2qngWq/YkWbtLkn5QpTFyq6
9iJLugf3pavFGSqDDD8kTz5ANBIq/CQwhNiO9A79/OGZQHE1lzyWLlEULnG32kKM
+2fOU73ykgCte/eRFdS/iWmkcQ/FhgBbk6QLskiBNqaB53+jsFK/koPK1P8IfFj+
yJo9kawNvpj50YappX5n7JyYvmgpNS5tb7QZfT5m+tN/19khhnCvRM6PouDx71ZI
1uyPjQ1zkbVPOrO1qetSIhu0nF8dxNJgKuQsT8DOiLT/v0OBEFGGAqQWDU+G/gzp
bW6gTs9f01yXrg+hhK+p
=IZjt
-----END PGP SIGNATURE-----

--wFNONn8gx1tMa3e7kpS91IWCeI0FuHLx0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
