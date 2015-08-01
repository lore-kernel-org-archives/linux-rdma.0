From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Sat, 1 Aug 2015 16:34:31 -0400
Message-ID: <55BD2D57.8030107@redhat.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com>
 <20150731073420.GB2485@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uLEVlrmEXs8JFPPanMGXSP1XBGuO5frxc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150731073420.GB2485-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uLEVlrmEXs8JFPPanMGXSP1XBGuO5frxc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 03:34 AM, Christoph Hellwig wrote:
> On Fri, Jul 31, 2015 at 02:05:06AM +0300, Or Gerlitz wrote:
>> So... enough is enough, please put it in a kernel module residing in
>> the IB core and use it in this driver, to begin with. The fact that
>> ipath is going to go, makes the cope duplication "only" 2X vs the 3X,
>> but it's still 2X
>=20
> Agreed.  Any if anyone tries to submit software RoCE again it'll be
> another duplication.

Or, I haven't looked at the soft-roce driver (ever).  Is it going to
need this library as well?  If it is, then as you have rung the bell for
getting this library written, I will expect Mellanox to work with Intel
to make sure that this library is suitable for not just their hardware
drivers but also the soft-roce driver you guys are working on.  I might
even suggest that it's time to work up the soft-roce submission sooner
rather than later in light of what I've done with the hfi1 driver.

On that note, Mike, I've taken the hfi1 driver into my tree, but I moved
it to the staging tree.  There, I created a TODO file with these items
from the review:

July, 2015

- Remove unneeded file entries in sysfs
- Remove software processing of IB protocol and place in library for use
  by qib, ipath (if still present), hfi1, and eventually soft-roce
- Clean up comments in code around CNP opcode

You will note that I have not placed "rework the /dev/ipath file
write/writev semantics" on that list.  I have yet to hear a convincing
technical reason that this must be done so I won't require it (you are
free to do so, however, if you just want to quite down the noise).  That
might change on the basis of any further emails in the thread.

So my plan here is that we will move the driver out of staging once
we've gotten these items taken care of.  However, I will note this
specific item: if the soft-roce driver needs the library too, and it is
not yet in a state to be submitted and even not in a state where its
needs can be articulated clearly so that the library can be written with
soft-roce's needs in mind as well as the Intel driver's needs, then I'll
let the hfi1 driver out of staging before that task is complete and
we'll just get to the library when we have all of the stake holders in
place and can actually work on all of them at once.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--uLEVlrmEXs8JFPPanMGXSP1XBGuO5frxc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVvS1XAAoJELgmozMOVy/dILUP+QERIZc174skwzbx5aNZKUG8
SESxUqKRJb/zQ8u8xVI/yMA7jgRAiSgxMcg8qCOngISvrRjEjXqPuJjHcmdx25sQ
4Gl+qSgdY6c09jn8gp+M35KSXuflxLMnR83i7aXwtwUf4YRrFeJnYCjuqfXY8nQg
EJRWDC3U2uVHoJvP2tOf9SYuKFIXYXS1icQhFo+MrPaf/PhYU9x5pgAcmLfazrRV
Vr1gyBBGLdrGmUKo58/kQG7utGXbCp7eJr1MT3XZlbWfBDYVSp92fukM+RmqdBWj
sZYeW9g5koz9XmYT8/sZ95DyQ0qxCELINEyRSUh/JG1uJZsiszMqfizX5h1YGR9n
hJpBOewQAYnfxohdfWomEo4AmTdWjszptswab/CP4bVrpvc7mbpGWfxnFkrX5suh
l75MUj7I8u3SLC5OiBgxcZdJKoGnsxid7z4cJp1pZcMq0wyeOg+0+g/gdnGOJgEH
VKwQvT4yGozWOlGy36vGqduBl6QAaoZNKGUovDPBo38ewSibhmllidUhuwGrA+1k
iY2p9nnp5sBF96tPx9y+jGiqQ072rS97YIQScmJnwqFngvraP18ORgLlOjUszPuQ
fYzD+4sSLfNW7pP6cUcP+PIsqvuVmIdo4gZazdjFNHqxVeVr78In2l2tPq1OXwx1
5PV2aQSVN8HKXdVRrEC+
=sT/J
-----END PGP SIGNATURE-----

--uLEVlrmEXs8JFPPanMGXSP1XBGuO5frxc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
