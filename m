From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 04/22] IB/mlx4: SRIOV IB context objects and
 proxy/tunnel sqp support
Date: Tue, 11 Sep 2012 13:10:00 -0400
Message-ID: <504F7068.6020606@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-5-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC17AC33CC19560DFB080B3E2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-5-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC17AC33CC19560DFB080B3E2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> 1. Introduce the basic sriov parvirtualization context objects
>    for multiplexing and demultiplexing MADs.
> 2. Introduce support for the new proxy and tunnel QP types.
>=20
> This patch introduces the objects required by the master
> for managing QP paravirtualization for guests.
>=20
> struct mlx4_ib_sriov{} is created by the master only.
> It is a container for the following:
> 1. All the info required by the PPF to multiplex and de-multiplex MADs
>    (including those from the PF). (struct mlx4_ib_demux_ctx demux)

OK, so can we have at least a single reference to the various
abbreviations before using them exclusively?  I know PF and PPF may be
common, but it might be nice that they were used once in full form
before abbreviated in commit messages.

> 2. All the info required to manage alias GUIDs (i.e., the GUID at
>    index 0 that each guest perceives.  In fact, this is not the
>    GUID which is actually at index 0, but is, in fact, the GUID
>    which is at index[<VF number>] in the physical table.

OK, this has been one of the things that has made reviewing this
difficult.  I freely admit that I've steadfastly ignored SRIOV for as
long as I can, so maybe this is just me.  But, in the context of this
driver, how am I supposed to know which code paths will be on the host
and which on the guest?

Also, I note that you do math every time you want to know if you are on
a parent device or a virtual device.  Do you really want to do math all
the time, or would it be better to save off your status on device init
and just refer to that when you would do math in this patch?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigC17AC33CC19560DFB080B3E2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT3BpAAoJELgmozMOVy/dso8P/3jp3O51ckdoCbkr1zMEqYSQ
vcpAd1FbfkbTb61iB50lxHp5SZacQWAQ87DwR0WCoRs9KDFQDKQn7aBatc738jZL
DHNNfCT44lq7+LD723RV129AFxJhsBMY85rrXrM+ReX/supsrdoC8WA8JTKA1QPn
FLttnk9bCqBncQMQtOFnOh2v67FU4SlJMjEElkGQpvkRB3vb0YYKJznZH/o6ccBc
3OykRpVoxmyIpJamis3Rx/T7e6mkitzTbixH49XnI4j7jYODGckMBMtikpX5JWcq
ksYq4KnnTBuNpc7Htup3MTZW1xru6m5ZLlzonyFLH6WKgGEng9d+bt5XspN1eFKS
+Tj37TMtSxbgUeXQi9gxcuo814ocERUp+krxQDfMXrE+wQ3Iax72N1YE92X6+l2+
XU04cUnHoLxAazHpg4YmEamt33BGbFwEpCenY/P83c6oSGOUQx0S1QvyroUcfL8R
hn+xRz6qRPq4k0hQAUMFfVQhkUee0929DDhCWGtxQDUpm0DPIM4TSS+bsv+RFWJ9
W/+W7mIKJtfUvQq4nFkTmXpgFteJzqJ3PmZ1fZ76zGiZExvDG64uQI/ME3HK5pFY
7jdIAJrXTigKUrGOvDpN7GEnUFANb9uwBJ+e+Tt6/vnysshHabpFScohq/uRflI9
IbE3nABs3dIn6HC4zDc1
=oUBW
-----END PGP SIGNATURE-----

--------------enigC17AC33CC19560DFB080B3E2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
