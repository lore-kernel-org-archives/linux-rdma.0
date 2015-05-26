From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/16] NFS/RDMA patches proposed for 4.2
Date: Tue, 26 May 2015 11:28:26 -0400
Message-ID: <1432654106.28905.111.camel@redhat.com>
References: <20150511174401.31263.79596.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-bsyTL6haL3JG5s96nwMX"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511174401.31263.79596.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-bsyTL6haL3JG5s96nwMX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-11 at 14:02 -0400, Chuck Lever wrote:
> I'd like these patches to be considered for merging upstream. This
> patch series includes:
>=20
>   - JIT allocation of rpcrdma_mw structures
>   - Break-up of rb_lock
>   - Reduction of how many rpcrdma_mw structs are needed per transport
>=20
> These are pre-requisites for increasing the RPC slot count and
> r/wsize on RPC/RDMA transports, and provide scalability benefits
> even on their own. And:
>=20
>   - A generic transport fault injector
>=20
> This is useful to discover regressions in logic that handles
> transport reconnection.
>=20
> You can find these in my git repo in the "nfs-rdma-for-4.2" topic
> branch. See:
>=20
>   git://git.linux-nfs.org/projects/cel/cel-2.6.git

I assume you are planning on this going in through the nfs tree.  As
such, I'm planning on removing this patchset from the linux-rdma
patchworks site.

However, I'll add this for the series:

Reviewed-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-bsyTL6haL3JG5s96nwMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZJEaAAoJELgmozMOVy/dTbUP/RC2ayWg3ab7VGxdj91G7s2i
kq1pfQjwFv+9AiqTjnRhqfiAnRgc5Pv29MsZXlYj/c9gk9I7EKCYl/L4mKHjObMQ
aLH6495PxEeaEwZHsl2/ix5tjbqT+08/NTTrdE3Ei2SdhzpeAf0CPOcAXiTG3TRC
WzsK/WaPHZXmORapzrUJFNIU4F6FvhGv6W4mpH0vGFX6rg82ui1840cCXla1rWfQ
GZpB5c1s/J6PNyBlUQZIFhaD5+jG+em0C0zDHV0dyJROp0KiFI7ru6kh13V8tMV9
e0uH6ePLZXk5OL60QhznvABPNjXmf1ItkBp3SnvN4x02YZOeYzZDXICVpoF9Gveg
MQos9fIYUDRtT+BUQmUpQuKZ5lutce/MMj5kIqGAs2A4n3Tie8grN1Ah40Z2Ae4L
zvX4HB9Mw1K+p1xoNzwy/TrGKN4A7JS6+PEpHnpT4r7oL/VBP4aYzvmq0+tbomO7
UC10I3nUEl69201cHWuuqYXwt+Om9RJzS1VD1frtvGXbKAv+mUBjVXmPHASJWOYn
sZkFZp6egc46a78B1wXvNtmJqgRttHv2L95tkUM+CekL0A1bS+mCRJIaie0qSUV2
Y1CYmZR5zYQlFk+g9LPVr1BknxFV8w5HW1z5v9I1mFtOgE4a7IrehOC/wUDWlCyU
bqQQHA8p31LnLouElCXy
=KvaD
-----END PGP SIGNATURE-----

--=-bsyTL6haL3JG5s96nwMX--

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
