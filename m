From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Sat, 1 Aug 2015 16:18:31 -0400
Message-ID: <55BD2997.6000203@redhat.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com> <20150731073158.GA2485@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Eq1LjLe8tOQv7OQoG2FCi2Ae7c9NhTfdx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731073158.GA2485-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Eq1LjLe8tOQv7OQoG2FCi2Ae7c9NhTfdx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 03:31 AM, Christoph Hellwig wrote:
> On Thu, Jul 30, 2015 at 05:42:16PM -0400, Doug Ledford wrote:
>> I have no problem with this code.  That Al finds the user space ABI fo=
r
>> this driver to be bizarre is neither here nor there to me.  Sure, this=

>> file does not exhibit normal file API behavior.  Who cares?
>=20
> Everyone who cares about filesystem semantics does.

If this were a filesystem and this were its file semantics, that would
be all kinds of screwed up.  But this is a private character special devi=
ce.

> A NACK from me for a this features,

If you have a legitimate technical reason to NACK this feature, make
your case.  I've publicly stated, in response to Al no less, that I
don't see justification for making a team re-engineer a working, private
interface because a disinterested third party finds it "weird".  If you
provide no valid technical justification for your NACK, I'm going to
disregard it.

> and b) for trying to sneak it in
> after a negative comment without cc to -fsdevel and Al.

Not that I was trying to "sneak it in", but that's neither here nor
there, you Cc:ed Al for me, and we already had our discussion (unless Al
wishes to come back and say more, he so far has allowed me to have the
last word).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Eq1LjLe8tOQv7OQoG2FCi2Ae7c9NhTfdx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVvSmXAAoJELgmozMOVy/dgD0QAKLNWWgZI1pLRjxNe9LJwkOd
wRCNq83wnAQ2gX+tT9YTY6F+Vf1eX9ICwoZ+H6EUUIgqVUenBNs7UfmpPR2qUV7h
55D1K6pmQkRvp7lJBSKNopaMf+d9s2TdfCF+pv4hCK+9OXCcdw1H5QCMntRHjwKC
uKSkbuXqsXrex3QPWpzExCnMc9q4bdYdIK7pigDHf3aVmMgA89bu2RaxQAr3mvHY
quxoxEIMCX+Mbb5XCuwKa9we5bJmJwRPwJw0nB4j/P9nsQBLBa3977pQWDtsY9S/
uiy3OuvDoekbeDMt9xDGJBfYlMgldchkWGVf33SCRkMxivipsap/Z9FmyWRPGRog
8PHgozxwTT+bb8gui08hfSSh3aaJBWxSKgtItmumh/xLLYbDFyB6ra6iLzCFsYpc
sVAn37pbMKQdgkgzGA8pA/noI598QDLz72NzpnxxoJbZz4zmSx3nY84AmmepKd9q
LOS9UV9szzTf2mI1opMv5Tn8LFpbYoZSLkKpkAXIbQ6MxTgT2Xm2tywDDZG3datt
U7Q/DtLyzpxjuRKEFJYcXQBHGX/O4hdvkvdl+oocBJRGSqGonaaSM2yfQ5JioLqn
xNZ33wpI4UiA7/VhIy5hAde226rsT/ZL+8jI0cVtdC2d8TFO17bDrfMkUsfzne9C
tvySarHAYvQtIdV+CW1d
=2OOV
-----END PGP SIGNATURE-----

--Eq1LjLe8tOQv7OQoG2FCi2Ae7c9NhTfdx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
