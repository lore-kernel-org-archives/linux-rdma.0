From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Wed, 18 May 2016 14:11:27 -0400
Message-ID: <12e991bc-aa9b-a8b0-3cd4-b56d58a44d60@redhat.com>
References: <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
 <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
 <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
 <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
 <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
 <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org>
 <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com>
 <20160517170027.GC19976@obsidianresearch.com>
 <bc83cc75-aa2e-6fc6-e1c6-a0190b972013@redhat.com>
 <20160518172542.GA15516@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8a7x8aeIlds3xS0mgtkRah4Gmsf4HcUGa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518172542.GA15516-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8a7x8aeIlds3xS0mgtkRah4Gmsf4HcUGa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 01:25 PM, Jason Gunthorpe wrote:
> On Tue, May 17, 2016 at 01:34:34PM -0400, Doug Ledford wrote:
>>> I noticed this too, but for sysfs reading I just felt it doesn't
>>> matter.
>>
>> I prefer not to have O(n^2), even for sysfs.  You say it doesn't matte=
r,
>> but if someone creates a script to check all of their stats via
>> sysfs
>=20
> Well, it matters if it actually takes a long time, but I don't really
> care of it is O(n^2) and still only adding a few additional 100us's..

If I understood Steve's response to this thread right, each access to
these stats on cxgb3 still involves a PCI register read/write.  Is that
right Steve?  Not a mailbox command but config space access?

Anyway, it's easy to imagine that as this grows, it might include more
and more stuff that hits the card.  I'm loathe to doing something as
inefficient as "read all stats, print one stat" on every access.

>>> and nothing should use sysfs except
>>> debugging.
>>
>> Nobody manually checking on numbers themselves will use netlink.  And =
if
>> the stats are there, people will check them.  You can't depend on this=

>> being used for debug access only.  If I recall correctly, ibstatus use=
s
>> all sysfs entries, and people would easily think that using it uses th=
e
>> "preferred" method.  So, like I said, if it's there, it *will* get use=
d,
>> and not just for debug,
>=20
> Why would people manually use sysfs? A netlink interface would be
> accompanied by a tool. I don't schlep around in sysfs for netdev, I
> use 'ip -s link show'

And how are you going to get RNR Retries from an IB device with that?
It might get added in the future, but it's currently not there (and
there's a decent argument against adding it to ip since that's actually
looking at the ipoib device and not the underlying ib device).  For some
stats, you may have no choice but to schlep around in sysfs.  If someone
does that, it needs to not suck.

>>> Caching is going to detrimental to apps that sync stats with external=

>>> time. (which is almost every real-world app)
>>
>> That's problematic with or without caching as the stats don't have a
>> timestamp, so scheduling delays could easily make the stats that you
>> get
>=20
> One can avoid scheduling delays with the right SCHED_ policy. how do
> you avoid timing jitter from caching?

I don't say I do.  I was pointing out that this isn't the distinction
you make it out to be.  However, as I'm working on this, the stats are
aged, and when they pass a certain age, they get recollected.  To make
that happen, I save the age in jiffies when they are taken.  That could
be used to provide their timestamp and give meaningful time context to
the counter.  They simply don't when you are reading the files in sysfs.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8a7x8aeIlds3xS0mgtkRah4Gmsf4HcUGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPLBPAAoJELgmozMOVy/d1u0QAIE4YkAkdF7AcLR5IFV5KfHT
O0dahEC2Q+JtzOESmCZSbKGOyt99BiNnMxHKD0jYdHbOvCBxQ5PhUo0sBTnfNq3k
osXE85uErYjuWLjoyOsPLmHxxMI3AGhx/BaZMSZVPqZ2BMaOPrE6nOxKP5emHzy6
L4RrGymmR8CyUiuf8vTZrvUhaMew7qiitSSkmD5IJsCERXdImVv7vFdZhrxFnjP0
+amdY8MEvHlhAwwdNGj7rkICaA5S+5t+q/eNmkY8mOqOePFxWVBC/ImuvwP+gA5P
dxtZlm4A1y4TRYme8aJrGtCmaqn76H51sCkudFntML1Qsh+CzasjUhPH86gO5Qe7
9M5oLsxYX0ssT3XG0ZKKmGxeQ0oaK5GZ6UnTDHyK0w50P9Fz1oVToECtnf22eiR4
MLAD53wfpI2g4iT0rnSIFk/qAz9Sp3AaNs0o929jsiAp9Y13+WfZ6YCB/zSOc35L
sVP4+YADKKbJ/gTZdbYwKodLX6+I98YZaf6MgEweEYlvv5hTfpBkOT2W7Uf33+A9
GzFMbqf3a+XA+HIw6+g5mz8VoYYQnmHNFW5NilPjVD54lNOkLrM4KO2FkEvK4vgV
lJq9VSue4LRAcJOe6QATX64uuUMikGNFM5uCBMaFISVsq2952ELL5qEYfDrPcv1/
ts6bm6LTk/z5dFQB7rGR
=yaSf
-----END PGP SIGNATURE-----

--8a7x8aeIlds3xS0mgtkRah4Gmsf4HcUGa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
