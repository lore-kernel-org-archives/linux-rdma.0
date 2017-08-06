From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sun, 6 Aug 2017 10:47:51 +0300
Message-ID: <20170806074751.GA3636@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <1501696661.109555.6.camel@redhat.com>
 <20170802185405.GE13672@mtr-leonro.local>
 <1501719575.117042.4.camel@redhat.com>
 <20170803051032.GF13672@mtr-leonro.local>
 <1501762973.117042.7.camel@redhat.com>
 <1501764159.117042.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501764159.117042.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 03, 2017 at 08:42:39AM -0400, Doug Ledford wrote:
> On Thu, 2017-08-03 at 08:22 -0400, Doug Ledford wrote:
> > On Thu, 2017-08-03 at 08:10 +0300, Leon Romanovsky wrote:
> > >
> > > Because, I truly believe that they proposed the nasty hack, which
> > > doesn't fix the real problem - inability to deal with losses of
> > > netlink
> > > messages.
> >
> > In so much as the iwpmd needs to be modified to do a resync, I agree
> > with you.  But, the fix they made caused the system to be "reliable
> > enough" that the problem more or less disappeared.  It is true that,
> > given enough load, the problem could resurface, but that hasn't
> > happened yet in the real world.
> >
> > However, iwpmd is part of rdma-core now, so *anyone* can fix it to do
> > the resyncs as needed (and I don't know, maybe it does, I just did a
> > quick grep for ENOBUFS to see if they capture that error and do a
> > resync on it, and saw no hits for that with grep).
>
> And in case this didn't sink in from the above statement, allow me to
> make it explicit:
>
> Does it not strike you how much of a failure it was on your part to
> submit a kernel patch that breaks iwpmd, code that is now part of rdma-
> core, FOR WHICH YOU ARE COMAINTAINER, without the corresponding patches
> to rdma-core to fix the real issue?  You don't get to tell Chien to "go
> fix his software" because his software is part of rdma-core for which
> you are co-maintainer and ultimately you bear responsibility for rdma-
> core as a whole whether Chien fixes his stuff or not!  Your job is to
> make sure that rdma-core is never broken in the way you were going to
> break it.  You had a conflict of interest here between your kernel work
> and your user space responsibilities and you did not choose well how to
> resolve that conflict.

Ohh, my god.

Doug,
There is no ANY breakage of UAPI and this was used as an argument
without ANY supportive claim behind of it. Just for the fun, I used the
same claim, but it looks like I was supposed to cut it once it was
claimed and not silently skip.

The iwpmd in rdma-core didn't get ANY patches BEFORE the patch in question
and AFTER.

So yes, I do responsible for the rdma-core and I'm enforcing the same policy
as we are using kernel - push companies to fix the root cause
and invest in the common infrastructure.

Chien is supported by huge corporation with many developers working on iWARP stack
and it seems very natural to demand from them the right solution.

Publicly, I tried it twice for the rdma-core:
1. One company stepped extra mile and improved the infrastructure.
2. Another company vanished into the dark and their supper important
feature wasn't so important at the end.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmGyacACgkQ5GN7iDZy
WKdfwxAAh8nCA2Xz+ugO2O7wEF2Yk0BhKVUMwjkkuHAW7PgLhIyFpJlv16bBqwyd
Kz48X5ezJC2aJYNuAfFs8jYXzw1S3fmhzj9HCL08zf0IeWJEVFDXf8pLdnnC7ZzT
4hAyL9UGJjNKUHKQHw0EjhXM+59RruY7HWjO7qhHTb/d0a4k7BcIVeuK11EO2kHn
QlBK6oDhtOyIxit62fsOoNWZvjJc6Po9CkJ3umV0dUBtCetPyomlpriByBTp9XZ5
chWwgmG2ShB0sZcmHvxlwmq37ddXW+wKW0Shs3eM6KPocTE0JqnG1PWT7fatWmB8
ViaAyy6pM17987X9nW9JHyXfhCcCF5vD+PzvJMhlfJPw9r2vFr09aTI67tYf7L1x
M4UUwLHpaFIhZ3e8dLQ5ybzYYB2OftHoNEhHJWjgd0BSCUcmq1nxt2iM8//UOWHY
s3oDE2YBXejjxz2/m7+inOKGKQbx2tF+cgUQR2HrIxGc4UmG5z0d5b7Zr6pXkdh7
UDTtr2eGYDxLvkLzRsr1hr5JE3gydPXTMGnv2eZ4ZsKO1OGGLGTYK69Ft/P8bHmk
UDbvlPXoTM4iVHqg1ECM3DFCE/4Iiv0Ig4bkd2Ot6kf/3bkrKKm+8Nvz6jAyBLEm
4YpILLiGSQkHM/zc67a1swQ+xXt/kMqC7qlu76N7l41tfAC6rqU=
=i/w4
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
