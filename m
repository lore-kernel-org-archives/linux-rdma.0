From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Tue, 17 May 2016 13:34:34 -0400
Message-ID: <bc83cc75-aa2e-6fc6-e1c6-a0190b972013@redhat.com>
References: <20160315155455.173645653@linux.com>
 <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
 <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
 <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
 <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org>
 <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com>
 <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org>
 <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com>
 <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org>
 <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com>
 <20160517170027.GC19976@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bOvrIlCahIp94kMObhcpKEiXBgwe31TMI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160517170027.GC19976-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bOvrIlCahIp94kMObhcpKEiXBgwe31TMI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/17/2016 01:00 PM, Jason Gunthorpe wrote:
> On Tue, May 17, 2016 at 12:00:39PM -0400, Doug Ledford wrote:
>=20
>> operation O(n^2).  Since we can't break out mailbox commands to only
>> provide part of the data, I think we need to consider using a cached
>> struct for each device.  If the cached data is less than a certain age=

>> on subsequent reads, we use the cached data.  If it's too old, we
>> discard it and get new data.
>=20
> I noticed this too, but for sysfs reading I just felt it doesn't
> matter.

I prefer not to have O(n^2), even for sysfs.  You say it doesn't matter,
but if someone creates a script to check all of their stats via sysfs
once per second, and we start talking about mlx4 or mlx5 where they are
going to export a lot more variables, it eventually gets bad.

> Ultimately a followup patch should export the entire stats block
> through netlink as one operation

That's perfectly fine.

> and nothing should use sysfs except
> debugging.

Nobody manually checking on numbers themselves will use netlink.  And if
the stats are there, people will check them.  You can't depend on this
being used for debug access only.  If I recall correctly, ibstatus uses
all sysfs entries, and people would easily think that using it uses the
"preferred" method.  So, like I said, if it's there, it *will* get used,
and not just for debug,

> Keeping the driver interface simple seems valuable.

If you cache it in the core, the driver interface is simple.  And given
that the core is where the stats block is allocated and deallocated,
that's where the caching would need to be.  And it's not really that
hard.  I'll whip something up here in a bit...

> Caching is going to detrimental to apps that sync stats with external
> time. (which is almost every real-world app)

That's problematic with or without caching as the stats don't have a
timestamp, so scheduling delays could easily make the stats that you get
have a significant variance in time between the time they were retrieved
and when you actually processed them.  Are you suggesting we should go
ahead and add a timestamp to the stats output?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bOvrIlCahIp94kMObhcpKEiXBgwe31TMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXO1YqAAoJELgmozMOVy/dW/UQAJunRsKFWs4ITlAGzvtDZ8Bt
kDh7ksDWLB5RDTnCtp2HN3gJh5CZw3xGrj3TBkfVduw1aMqHqPJK7eyO4lhYgAxX
bl8+xUeajxRm+hudoWgvWX6pBkC2WWILIXcygkD2MrYr61icbUSQP2n5UiiGuNgl
HJG/0O1lXkgN/3+/twLJ50hOz6qIFujtk+RfvGMvSfqx3+i3n9MkiqZVYKpaE3/y
pssgLZ/JRJjOZOrXTzz8GaxasoLCeGIec+egk/EPlFc/Q72mh4yds3/4KNmCVvdZ
hENSLyW31HOVEbkNSVTgOVZrMgu21jrLezUhq4pHR90U2KDsbHRKNh1gp4docL6I
Nai+u8o3q4/yID0Ei05pK9kkOC6kfGNneWDysv4+pNsjOXOtqeTLXlz5tuAJCXtN
MZUAj7PNrbZ2ptoFeLiQTO3PMD77a9h4ysoSwPApU+5X+opVaPVRS5j5bqyG7MRC
nAcmuyXrWSTFFd+/Hld1LoEmzmY8EV81Xu8Udl8kIgdzYSI7XbPdyGw5buQDSAKt
bLObpsSwv/gE0Ek4NihQsMVZ/xXI4ebVyjL+/jHFW6YiypuhQulvX6IpXV+Apvv1
f4YC8rLxoH1EgEs8P/EkftpKnK4N/3vAzUeULVFf7Vd5htYoubC5R1EQYQKv2yYJ
P5wgxFjVg+WeCNMIORxt
=1rif
-----END PGP SIGNATURE-----

--bOvrIlCahIp94kMObhcpKEiXBgwe31TMI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
