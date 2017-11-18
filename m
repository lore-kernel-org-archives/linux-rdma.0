From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rdma: Add Jason as a co-maintainer
Date: Fri, 17 Nov 2017 20:44:27 -0500
Message-ID: <1510969467.3973.83.camel@redhat.com>
References: <20171116204400.GA28216@mellanox.com>
         <1510941272.2846.46.camel@wdc.com> <20171117181410.GL4276@ziepe.ca>
         <1510947901.3973.26.camel@redhat.com> <20171117213227.GQ4276@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Ri0Ur1CJO/iKs90X7P+w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171117213227.GQ4276-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Ri0Ur1CJO/iKs90X7P+w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-17 at 14:32 -0700, Jason Gunthorpe wrote:
> On Fri, Nov 17, 2017 at 02:45:01PM -0500, Doug Ledford wrote:
>=20
> > On that point...I have my github repo tied into the 0day infrastructure=
,
> > not the official repo.  I do that because I've publicly announced that
> > my github repo is a WIP repo, and that it might be rebased.  That allow=
s
> > me to correct build issues by fixing up the broken patch and thereby
> > keep bisectability at its highest.  If you use a branch/tag on k.o for
> > your 0day testing, then fixes have to be incremental and depending on
> > which patch broke the build, there might be a significant segment of
> > code that is no longer bisectable.
>=20
> .. and this is because the k.o repo is setup to disallow force push
> for each branch, so a 0 day testing branch cannot be rebased?

Well, there are ways around the system if you really wanted to do so.=20
You can push to k.o with an empty ref, aka something like 'git push k.o
:k.o/for-next', which will delete the old branch.  Then you could rebase
it locally and repush it.  But that would make you a very evil person
and if Linus found out he would (rightfully!) yell at you for many
paragraphs with lots of all caps ;-).

The other option is to delete the bad branch and push a new branch with
a different name and the rebase already done.  I did that a couple times
in the early days of this job.  Now a days, I wouldn't even do this for
anything short of a disk corrupting issue or something like that.  I've
come to appreciate just how much people rely on unchanging commit IDs.

So the fact that the k.o repos don't allow non-fast-forward pushes is an
inconvenience, but it doesn't stop you from doing it if you really
wanted to.  But it's very bad form to do so, and that's the real reason
that I keep my 0day source on github and tell people regularly that my
github repo is a "rebase allowed" repo.

So, my workflow in order to prevent getting a bad branch on k.o goes
something like this:

1) Bundle up patches that belong together as a bundle in patchworks
2) Review patches
3) Download bundle from patchworks, apply using git -am.  Do any edits
to commit messages at this stage, either by hand editing the bundle file
before you run git -am, or afterwards by doing a git rebase -i.
4) Build locally and frequently as you take stuff in.  I suggest a build
between each bundle.  It's much easier to fix up errors when they aren't
buried 40 patches deep in your day's work.  I use partial builds for the
intermediate builds (make SUBDIRS=3Ddrivers/infiniband usually, but other
directories if the bundle touched code elsewhere).
5) When I think I'm basically done for the day, then I do a final, full
kernel build.
6) Push to 0day repo, wait for results.  This is a good time to do
whatever run testing you plan on doing for this push.
7) Push to k.o once 0day and your testing has passed.

Following that workflow minimizes the chances of having a broken push to
k.o.  If something does actually slip through this workflow, then you
just fix it incrementally unless leaving the issue will cause a meltdown
of the Internet or something.

The one thing it doesn't catch, which is actually what caused the time
or two I had to delete a branch and make a new branch on k.o, is when
you have to manually apply a patch because git am said the patch didn't
apply cleanly.

Most times, just running patch -p1 -l < .git/rebase-apply/patch gets the
patch in.  Git am will reject patches for any fuzz.  If we were using
git merge/pull, there is often enough context for git to know when to
allow the fuzz, but the am mode of git doesn't have that info and dumps
on very minor issues.

So you manually apply the patch, accepting some fuzz, and inspect the
result.  Where I screwed up in the past, is when the patch adds a
totally new file to the repo.  My usual workflow after applying the
patch manually, and then inspecting any suspect areas and hand editing
files when hunks get rejected, is to run git add -u.  This fails to add
new files to the commit.  So, I had to add an additional git status step
to see if there are any new, untracked files before I run the final git
am --continue.

If you split step 5 above into 5a) Push from local work repo to local
prep repo and 5b) Do full kernel build in prep repo to test that all
code needed to compile is tracked by git, it would catch that mistake
before it makes it outside the firewall.  That's a change I may make
just to be on the safe side in the future.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Ri0Ur1CJO/iKs90X7P+w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloPkHsACgkQuCajMw5X
L90Xfg//bfIpfxS7e4I2h5jecrQky6q1mMYN3i6bra/U4F8xY2yLhvGRJUXHKS4Q
6vW4rlaP0FblA3pnn3vXiVf5GW9eruQ4uNwF9d4yVMWP1a48qS4LGCf1COhSSbTl
M+dMyTiRRfgBcsgsWOfbIs40sej5bNUgTpH1xvN9a/JUkotsBttq+xDwS1lmN+G8
zgE2Rks6XJuRF0hw4x9V5mMMY3uN7QhQWa9HFdmu9ulVcueGfCHaOO8OT2jE21+l
qyrzUur+Le33S9qn2sFd+n8MRFuL0uzU3EdMtmo5klkB8um/pEPiPCWmOEyk735B
L8ndZ3Q8YK/LCQAtatURg69+UAWOsaR2jTKpyktv5xPPAr0diTcvusl5oizNUPbQ
EMD6p3f/v4U8b1a2dRqxN7hCsaAhiPzh+tKY23YNobPvSQLmHBrEYE3AwlyVcS9R
8nW5fhKkk8fPGw9t0oNFadk2HjRZ+7byj/v9PIhkNoiQemyzYAunIKaikQiRt6Qo
0vjNGx8Ub0juMfHW35Lr9/m4J6TF8Hyz62YmoeiKM/slUOPXVhLBMQYlkZ9Mzm4R
u3G1f7A+1wstUSX1Bxnh1jSukPi2ITACxw8aq9zMfstlDWOd9H3tZJIgz9psMwzx
GFSQfmY2kKmdjsrTNigAZnsqkM5DrsuGA7jwTrhtIPPh8vxj8QU=
=ZE6N
-----END PGP SIGNATURE-----

--=-Ri0Ur1CJO/iKs90X7P+w--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
