From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 18:20:40 -0500
Message-ID: <5637EFC8.4010300@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com> <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6UDgK45q7ACJUkLQhrTmnjjrLaIC15gFC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151101180609.GC13943-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6UDgK45q7ACJUkLQhrTmnjjrLaIC15gFC
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/01/2015 01:06 PM, Greg Kroah-Hartman wrote:
> On Sun, Nov 01, 2015 at 02:10:48PM +0200, Or Gerlitz wrote:
>> On 10/29/2015 1:51 PM, Christoph Hellwig wrote:
>>> On Wed, Oct 28, 2015 at 10:57:59PM -0400, Doug Ledford wrote:
>>>>>>> I had to do a minor hand merge to get this to apply, but it has b=
een
>>>>>>> pulled in for 4.4.
>>>>>
>>>>> This breaks all of the drivers in staging BTW.  That will need fixe=
d up
>>>>> before the pull request goes in during the merge window.
>>> That latest branch on infradead.org should have fixed all the staging=

>>> drivers.  But Linus just clarified that we indeed do not have to care=
 for
>>> staging drivers, I asked him at kernel summit in front of the whole a=
udience.
>>
>> Can you and/or Greg clarify this a little further... when someone modi=
fied
>> an API called by others
>> drivers,  they don't have to deal with staging drivers?
>=20
> Yes, that is correct.
>=20
>> that is, the folks that care for this staging code need to handle
>> that?
>=20
> Yes, that is correct.
>=20
> It's up to the owners of the staging drivers to do the work, we do not
> make it the responsibility of anyone else.  Now most of the time people=

> are nice and fix up everything else, but it's not a requirement at all.=

>=20
> hope this helps,

Not really.  That may be a satisfactory answer for most of the things in
the staging area, but it is not a satisfactory for the items I moved
into that area.  The things I moved there belong in one of two categories=
:

1) Aging, but working, drivers that will be removed in the future.
Since we no longer have a deprecation mechanism, I was informed that the
normal procedure now is to move the driver to staging for a while and
then remove it permanently on a future schedule.  This provides an
orderly removal process.  But, if you make it so that random people can
break the driver with no responsibility for fixing up their breakage, in
contrast to the entire rest of the kernel, then you eliminate that
orderly removal process and turn it into a completely non-deterministic
and chaotic removal process.  So, no, if that's how it will be handled,
I will move the deprecated drivers back to the main rdma tree and time
them out and perform the orderly removal myself.

2) New drivers (one currently, one other one submitted but not yet
pulled in) under active development but which need specific things fixed
up.  These have people already working on them full time.  They were
submitted to the staging tree with a specific TODO in order to get out.
 If you then break that driver and force the driver author to fix it,
you have in essence changed the TODO list.  That means you now have a
moving goal post scenario.

And this behavior is somewhat justified if you have a driver that is
languishing in staging and being mostly ignored by the
authors/maintainers of the driver.  If the maintainers don't care enough
about it to fix it up, why should the core kernel developers keeping the
kernel modern fix them up?

But what about when the drivers *are* being actively maintained and
worked on?  From the perspective of a maintainer trying to get their
driver out of staging, this policy means that drivers that are already
in the main tree get help from the core developer who *must* fix them up
to work with their changes according to policy, while the same core
developer is allowed to ignore any responsibility for fixing up any
staging drivers.  At the same time, it is highly likely that since the
core kernel drivers have reached a level of maturity that they don't
really *need* a lot of help keeping up with changes nor require a lot of
work.  The maintainer trying to get their driver out of staging however
could probably use the help the most, and certainly likely doesn't need
any extra work dumped on their back.

So, no, for the drivers I have moved into the staging tree, I don't
support this policy.  This policy is really just a means of not making
core developers work on drivers that no one cares about.  The *means* of
saving those core developers that work turns out to effectively be a
punishment to any driver maintainer in the staging area who isn't
allowing their driver to languish and go unmaintained.  Because the
staging tree is not limited to just drivers deserving of this
punishment, the policy itself is inappropriate IMO.  If that's going to
be a problem, I have no issue moving the entire staging/rdma tree back
into the drivers/infiniband area and fixing it up appropriately.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6UDgK45q7ACJUkLQhrTmnjjrLaIC15gFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWN+/IAAoJELgmozMOVy/dhEEP/0AfY4T1p46uv+/8J0quih//
UBPCk9Bn1VxooZKOkHJfcryisqYklzrndVwfwME6SrhsT8EssNFD6TjRIXQ4+746
hYQy6OVXSCrHPpsY2kjGLcPQsxUXV+Y2vsTtnDH54WLmGr1bPSDmy762su2i0wmC
SkQvL6hH2sGTlvLFON+293AlqPAUvpjd+/flcpnryMMyu+uKEs3saI4hv7PZpFKQ
lqK3Hi/PXaxp7IDJqskRb8V/XRCD0iQ/Fhdats0HTjM+pUn3ybh9ISTW2W4I6PVz
QlayoV5xU6cOZV+z1XktNMOqeYxBhTdxIUGZ1lBjJCRcuIxLuiXgO/xsDW4tUF1K
mF7K3jWm55Jr2OS62+3VO2wDoZZ5WIlE54Hz//u65HEQmc92qpA6PWQOcsDZsgnH
bbhS+jOHfWOq51IfDlMge+ELGpyyTkogIDi1BMjPfRLmxJU4AD+dW2gWmNO96kex
dK/irHvOLfP5DUvy6hb1DBJOa9goAF5T3M+FJP5DV4VTdpGg/IUqqpBWNfriF2hD
6CRIZEe+Qsy9IMY2P8DViBGnTNWslDtmFGQXNjrXJmSfyQYpDeofAFR24B7t7GH7
wndF6upJd3/c2vRiYdtGAiKOWszQ1SQ8by3elExEE2A8nlmzsfRQVNYchkIM57WX
Peks4PeuenNr0Rq7uu5a
=hpQi
-----END PGP SIGNATURE-----

--6UDgK45q7ACJUkLQhrTmnjjrLaIC15gFC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
