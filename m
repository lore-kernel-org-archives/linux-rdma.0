From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 19:02:04 -0500
Message-ID: <5637F97C.5090205@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Xm9F6xBFlqF6UknTPT8KjbSi1HROXOqM7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102233726.GA18251-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Xm9F6xBFlqF6UknTPT8KjbSi1HROXOqM7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/02/2015 06:37 PM, Greg Kroah-Hartman wrote:
> On Mon, Nov 02, 2015 at 06:20:40PM -0500, Doug Ledford wrote:
>> 1) Aging, but working, drivers that will be removed in the future.
>> Since we no longer have a deprecation mechanism, I was informed that t=
he
>> normal procedure now is to move the driver to staging for a while and
>> then remove it permanently on a future schedule.  This provides an
>> orderly removal process.  But, if you make it so that random people ca=
n
>> break the driver with no responsibility for fixing up their breakage, =
in
>> contrast to the entire rest of the kernel, then you eliminate that
>> orderly removal process and turn it into a completely non-deterministi=
c
>> and chaotic removal process.  So, no, if that's how it will be handled=
,
>> I will move the deprecated drivers back to the main rdma tree and time=

>> them out and perform the orderly removal myself.
>=20
> So you have what, one more kernel release before these are deleted?

4.6 merge window.

> Odds are, nothing is going to be broken so badly that a simple patch
> will not fix up before they are removed.  So don't worry about this.
>=20
> And why would you want a developer wasting time on fixing up these
> drivers if they are about to be deleted anyway?  Obviously no one even
> uses them, otherwise they wouldn't be about to be removed.

Because they are *scheduled* for removal.  If I simply didn't care if
they went away, then I wouldn't screw around with deprecating them or
tagging them to be removed, I'd just delete them.  Breaking them before
the scheduled removal time defeats that entire purpose.

>> 2) New drivers (one currently, one other one submitted but not yet
>> pulled in) under active development but which need specific things fix=
ed
>> up.  These have people already working on them full time.  They were
>> submitted to the staging tree with a specific TODO in order to get out=
=2E
>>  If you then break that driver and force the driver author to fix it,
>> you have in essence changed the TODO list.  That means you now have a
>> moving goal post scenario.
>=20
> Again, this shouldn't be taking you all that long to get out of staging=
,
> right?

No, the one item on the TODO list is fairly big and requires
multi-vendor joint engineering efforts.  It could easily take multiple
kernel releases.

>  And again, the number of api changes that cause breakage are
> usually very minor, if they happen at all (remember, this is a
> theoretical, not what usually happens.)

We've already had two in the 4.4 for-next window in the InfiniBand
subsystem.  I requested that the authors fix up the staging drivers and
included that with the patches that required the fix ups, so you didn't
see it.

>  And a driver in this state
> doesn't deserve to be in the "real" portion of the kernel,

That's arguable.  Certainly scheduling a driver for removal doesn't mean
it no longer "deserves" to be in the "real" portion of the kernel.  It's
on its way out, yes, but that doesn't make it automatically and
immediately undeserving of being in the "real" kernel.

> so you can't
> merge it anywhere else,

Of course I could.  The deprecated drivers didn't have to be moved, I
could have created an INFINIBAND_DEPRECATED group and moved them in
their via Kconfig without ever moving the files themselves anywhere, and
then deleted them when the time came.

The new driver(s) could have been merged as it was.  It's only crime is
that it was the third driver to have a software transfer engine in it,
and so we wanted to get a transfer library built and move the transfer
management code out of the driver and into the library.  We did the same
thing with the SCSI stack, and we didn't make every new driver go
through staging while we built the library, which is what we are doing
here.  Staging is a carrot to get the library built, not an indication
that this driver is unsuitable for the "real" kernel.

> so overall it still benifits being in the
> staging tree, so a few minor breakages every once in a while should be
> easy for you to fix up, _if_ they happen.
>=20
> Again, I don't know of any recent api change that has caused any
> problems in a long time, but the VFS developers really hate having to
> touch lustre code, and I don't blame them, so sometimes that codebase
> breaks.  That will not affect your drivers at all, so I wouldn't worry
> about this.

Yes.  I get that.  And I understand that.  But because of Lustre, you
have made a global policy that effects all staging drivers without
legitimate cause, proudly broadcast that policy at a conference, even
answered a question from Christoph confirming that policy, and now in
this email thread where I object to that policy you say "It doesn't
really happen anyway, don't worry about it.'  But the person who quoted
you (Christoph) is the author of one of the API changes that *did* break
the RDMA drivers in the staging tree and he fixed them up when I asked
him to.  Christoph then later quoted you and his interaction with you at
conference to indicate he didn't have to.  And what I'm telling him, and
you since you are the person he's quoting to justify not fixing up
things, is that I don't care what you say, when it comes to those
drivers that I moved into staging, if he wants me to take his core
patches, then he needs to make sure they don't break those drivers I
moved into staging.  I draw an exception for Lustre for the same reason
the VFS people like Al do.  But for everything I moved over there, the
decision is what it is.

> So relax, this isn't going to be an issue, or if it is, you can easily
> handle it,

Indeed, I can easily can and did handle it.  I had Christoph and Sagi
fix up their patchsets to include the staging drivers.

> it is no different from any other tree-wide api change that
> happens.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Xm9F6xBFlqF6UknTPT8KjbSi1HROXOqM7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWN/l8AAoJELgmozMOVy/duawP/1Ey+4PUiijmcfuPPw4XYtoH
YTrkNdLA6fbXy1KuYYKXKTgPRBFGpH2mWPYGk4OLDX35z7I2feM/5apnrXMJIEgH
rvzPQwibC8EgPD9XXQNqOujc6N26T3ExgGr+6CLfmx8poQom7sumTKPYRQj4iFMH
zXIqogbUd5FIBpJ2h9OpF6ji56VoDUSJWPz5J3rcas3EeWWO65lwkOWloT1sGTsQ
box9+J2Gbb7zbJUSHxDqBb8rv8G6k40PzbTXIXU+oLYa5pzUbW50gZX18oSyzguW
XNPaCzYVd6IxtooD84PdNPw2ce7gVfnD8YMouYwK6Ui3ZvN/H+Rj1GuvAlkJP3PX
MzdUOm5TFPqE4TlogcFcIO0Pu33SDn/J6R1oMxui0lXPQDjq35QRDyW1WqKV6Ihz
6Yjiwc3z2lquE7NBKjh0gbHNYND22mgYQ7+GQtpJZ3shCPj2yfZ1568n/sxjwnpi
t+lw/oC7ZRaLEyRMpZZhjQD6646cMFXG1rgOrsnWl14cKcPlWf0NEgJLkemISkfx
Sbws4K4KThKsBlqQqu+MzOZ/bywlVQO/XbAZNGr8DCqDqtSymxj2zDpxaduSaEId
gQjJgg4Dykdt3Zwp/LUYbRTL/BogJeDszlXYOcVWsdp5yQ9CeytA8Qssf8ks9ftq
SrOe4o0Rjp9ak9rAfEd6
=jtfF
-----END PGP SIGNATURE-----

--Xm9F6xBFlqF6UknTPT8KjbSi1HROXOqM7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
