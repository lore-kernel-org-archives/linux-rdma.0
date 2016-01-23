From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 17:27:59 -0500
Message-ID: <56A3FE6F.4000800@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
 <56A30910.9010002@redhat.com>
 <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
 <56A3A777.3@redhat.com>
 <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4Rr9m5qhR6xQ32aMqM688OEUq4JB8A8hW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4Rr9m5qhR6xQ32aMqM688OEUq4JB8A8hW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/23/2016 02:02 PM, Linus Torvalds wrote:
> On Sat, Jan 23, 2016 at 8:16 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>
>> I don't think it's as "clearly not ready" as you think, but that's jus=
t
>> my opinion ;-)
>=20
> So how ready and stable is this? IOW, if I do this pull, can I rely on
> that being "it", and really just get fixes.

I still want to send the staging changes.  But those are actually very
small: there are three drivers in staging/rdma that we put there as a
deprecation step and that need to be deleted, and I need to update the
maintainers file to exclude staging/rdma from the directory list for the
primary staging area so people quit sending patches for it to the normal
staging mailing list.  The problem we had with staging/rdma is that it's
waffled back and forth as to whether Greg or I would handle the patches,
but the hfi1 driver is now at a point where it needs to have its patches
coordinated with patches in the main rdma tree, and so it was agreed
that I would take over staging/rdma and Greg would ignore it, but Greg
needed to go ahead and push through all of his staged changes before we
put that in place and I'll take over starting with the next for-next
cycle.  Otherwise, yes, the pull request I sent you is "it" for this
release.  I have no other queued series or misc items, everything else
is relegated to for-next status (of which I have quite a few of those
and probably need to open my for-next quickly anyway).

> One of the reasons I absolutely detest the "last Friday" pull requests
> is that it really tends to smell like "this pull request was hurried
> to hit the merge window".

I tried to carefully select what I felt was ready versus should wait
when I processed patches upon my return from PTO.  There are 171 patches
total in the pull request.  Of those, 99 have been there since before
Dec. 24th.  There were 57 that I processed on Monday and Tuesday when I
got back from PTO.  That broke down to 34 one off patches that include a
smattering of things like sparse and other checker fixes, actual oops
fixes, and cleanups; 12 patches for the NFSoRDMA stack that were
previously in Bruce's tree; and a series specific to the mlx4 driver.  I
let this sit specifically for linux-next automated runs.  On Thursday I
decided to take a series I had previously skipped (support for raw QP
types in the mlx5 driver) and I took one fix I had previously missed and
was brought to my attention, and I took one fix that didn't get authored
until that morning and needs to go into your tree even if the rest of
the pull request doesn't.  I then let that sit overnight again just to
get another round of linux-next testing.  It goes without saying that I
got positive 0day results on all of these, and generally much faster
than waiting overnight and checking to see if any failure messages came
back.

>  I much prefer seeing early pull requests
> because that just shows that the subsystem is on top of the timing.
> And that in turn means that I also get that warm and fuzzy feeling
> that if the subsystem has its act together, I'll be getting just fixes
> after the merge window is over.
>=20
> (The _other_ reason I don't like the last-Friday pull requests and
> prefer the early ones is that then I'm not hurried, and I can take my
> time and do the pull requests in sensible groups - filesystems
> together etc)
>=20
> So if I end up pulling this, can I rely on getting just fixes for the
> next ~6-7 weeks?

Yes, that much I can assure you.  And if you don't take it, I can also
attest that there will be roughly 20 fixes coming your way shortly ;-)


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4Rr9m5qhR6xQ32aMqM688OEUq4JB8A8hW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWo/5vAAoJELgmozMOVy/dZpIP/RuPgmaGIBkWCS3knbwFaG3O
A6+yyo9avq9jX4Uy9IpIBCw9k6bjKyvJLfDbDst9tuGXByHunU/+IUbLpesoepyw
KufkVVfUH8r9RhbIkPE+bWO8nJ4+GPToNG6ssO6g80m/qg4q68Tjwmg17EuW9lp+
upRZpHVUkQ/kPTVHaJCZZDcb/JomuMaoDGri0QYPQV6VsWmJ6+26pyRDHoZexam1
pfRRHhO8Gjb3sZSkdg1+p9k8vqKeNuaQaC2hjR9Q+IRtEmMdNl4I2cxaV+/6shJD
MJW7zaz3RlODL4hEKbFC5fBECExKVLQZABVaAsJp53VCFdEigH5BoaoUzGA3S7om
FhjWBAQ7kGVQKNErlO6vcarkpyauS8LKkQ0YCrWDzxAnjv+afJhF5MbwlERXo7hq
q5p9aFBiCNRyVhJEVAze8cc4bYfQAuSAqaBIgpC61yXtIkjMpR3d0RaQ8V90XQB4
KtdCnOkVooNNxqfIW6Ig2hhQ7IMMK1msnUopQ9w4ftWg8KXB/BMSFaUujvn3p2OT
oc5eNTwP/NEL3DTNbqRgzJxjNsSHUeDN8t9kM8tm/yVTdbLCfj3x9o28x/N/Kjc5
7bM0Dv8WLyOvYFBlV9SOoxQjPy2rsOwXTv6mWjzxuUkb/r2KCdiWLtI/LU3v3ZWv
4PyvEnLxBFG6X0bXWoHP
=9jjj
-----END PGP SIGNATURE-----

--4Rr9m5qhR6xQ32aMqM688OEUq4JB8A8hW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
