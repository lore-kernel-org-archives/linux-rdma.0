From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 20 Nov 2016 14:53:33 +0200
Message-ID: <20161120125333.GC4946@leon.nu>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu>
 <582E089A.3040106@redhat.com>
 <20161117200203.GQ4240@leon.nu>
 <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
 <fea924a0-f399-8ecf-c039-5cb7c5e0acb8@redhat.com>
 <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>
 <710f3e81-dd9c-8221-cf5e-7a96f4cad5b9@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <710f3e81-dd9c-8221-cf5e-7a96f4cad5b9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 19, 2016 at 06:11:22PM -0500, Doug Ledford wrote:
> On 11/19/2016 2:46 PM, Or Gerlitz wrote:
> > On Fri, Nov 18, 2016 at 4:01 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> On 11/17/2016 5:24 PM, Or Gerlitz wrote:
> >
> > [...]
> > Are you going to comment on that to the submitter? if not, they are
> > going to continue with this practice.
>
> Comment on what to the submitter?  That the patch might not have been
> -rc material?  I would have been OK with it around rc1 or rc2, just not
> this late in the rc cycle.  In the end, I don't, nor can I, rely on
> submitters to determine what's RC material and what isn't, that's what
> I'm supposed to be doing.  I will always apply my own judgment on that
> issue and submitters will learn over time when their patches get skipped
> on any sort of a regular basis.

And I'm pretty fine with Doug's judgement regarding -rc vs. -next. Our
submission flow meets the expected by RDMA maintainer and we will
continue to work in the same mode as long it suits Doug's expectations
for acceptable/unacceptable submission.

>
> > How are we supposed to realize from patchworks + your github branches
> > that patches that were submitted for 4.9-rc are picked for 4.10? this
> > is very confusing and error prone too.
>
> I emailed the submitters off list about it and provided them a list of
> what patches went where and why.

Thank you, I compared the submitted list with found in your trees and
everything looks in place.

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYMZzNAAoJEORje4g2clinjxQP/iCptAkX7YdqZgtC4tIgLjMZ
+6YrX962SMbnKNFYH5oGVNaylDoUiUJtIKwG6aUYP50OxEY43/hJLSZotcvLcqq8
wHT6XzLL/Uhlemlxbvtg280egQth0WLDfITgfc2B1s+hgb5lrPXQhRM1XPy//qYz
H69Yfo0oJjUvOTowSPEYHVyJayOm/gRvu1fDfIikw9Y56i2Y/7olXNI9KvT2srhw
pKyb0bqkIFG4aONTdsBiCNGuLIzK4Ghd2Kn+RI90hYkFg+Xql3syQNUO+6ff605H
Fai2HeMpA6FmMWyBAXbKbGoq04ipSdigFtoDwJr5/RbmPquImXRNuZinUQ2maCBH
Wq9NswOuh8+nA0lUZg59odJ/UmIvE6RBcORF9LmELNQka+L4mrdLJUa9r6BBqaOk
0xy0zyNcPC3T9kPmDyj1sjV7iHcFEBSgvulj/swCVhbdwZm12vHkBtaUw6jK1FGC
ikruBD14KBxqE1fS/MDPhe4L3Qzs0d6+O4o76X40P0R1nson7VnwEaJztkeMVHp6
QMeEux9INIbDTHl4NBs8gIGa8haCZonBtloW3gXThJNCJjXNhomg0DoZ/XHyYOnU
W7wQV8umhqJhLYujx51RNXTO076mjwyGDJGVfDZIp8Ei2t9D98Ce/S/O3Dlxfzp7
EBtL0HO9SP/XkWH+uOUy
=IOz4
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
