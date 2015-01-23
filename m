From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Fri, 23 Jan 2015 11:52:18 -0500
Message-ID: <1422031938.3352.286.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RxFKWNXU27HGz+YVj0gw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-RxFKWNXU27HGz+YVj0gw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-01-22 at 09:31 -0500, Doug Ledford wrote:
> My 8 patch set taken into 3.19 caused some regressions.  This patch
> set resolves those issues.
>=20
> These patches are to resolve issues created by my previous patch set.
> While that set worked fine in my testing, there were problems with
> multicast joins after the initial set of joins had completed.  Since my
> testing relied upon the normal set of multicast joins that happen
> when the interface is first brought up, I missed those problems.
>=20
> Symptoms vary from failure to send packets due to a failed join, to
> loss of connectivity after a subnet manager restart, to failure
> to properly release multicast groups on shutdown resulting in hangs
> when the mlx4 driver attempts to unload itself via its reboot
> notifier handler.
>=20
> This set of patches has passed a number of tests above and beyond my
> original tests.  As suggested by Or Gerlitz I added IPv6 and IPv4
> multicast tests.  I also added both subnet manager restarts and
> manual shutdown/restart of individual ports at the switch in order to
> ensure that the ENETRESET path was properly tested.  I included
> testing, then a subnet manager restart, then a quiescent period for
> caches to expire, then restarting testing to make sure that arp and
> neighbor discovery work after the subnet manager restart.
>=20
> All in all, I have not been able to trip the multicast joins up any
> longer.
>=20
> Additionally, the original impetus for my first 8 patch set was that
> it was simply too easy to break the IPoIB subsystem with this simple
> loop:
>=20
> while true; do
>     ifconfig ib0 up
>     ifconfig ib0 down
> done
>=20
> Just to be safe, I made sure this problem did not resurface.
>=20
> v5: fix an oversight in mcast_restart_task that leaked mcast joins
>     fix a failure to flush the ipoib_workqueue on deregister that
>     meant we could end up running our code after our device had been
>     removed, resulting in an oops
>     remove a debug message that could be trigger so fast that the
>     kernel printk mechanism would starve out the mcast join task thread
>     resulting in what looked like a mcast failure that was really just
>     delayed action
>=20
>=20
> Doug Ledford (10):
>   IB/ipoib: fix IPOIB_MCAST_RUN flag usage
>   IB/ipoib: Add a helper to restart the multicast task
>   IB/ipoib: make delayed tasks not hold up everything
>   IB/ipoib: Handle -ENETRESET properly in our callback
>   IB/ipoib: don't restart our thread on ENETRESET
>   IB/ipoib: remove unneeded locks
>   IB/ipoib: fix race between mcast_dev_flush and mcast_join
>   IB/ipoib: fix ipoib_mcast_restart_task
>   IB/ipoib: flush the ipoib_workqueue on unregister
>   IB/ipoib: cleanup a couple debug messages
>=20
>  drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++-----=
------
>  3 files changed, 131 insertions(+), 106 deletions(-)
>=20

FWIW, a couple different customers have tried a test kernel I built
internally with my patches and I've had multiple reports that all
previously observed issues have been resolved.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-RxFKWNXU27HGz+YVj0gw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwnxCAAoJELgmozMOVy/d3rsQAIJIoJ4RjzGuanZiVIsdVM04
A7vAnBZE+w3qTwJ63gm1oLw9K0P/wX5BDgFamUFwkYcHhLYybTxdeE85B/tKmeKS
q2t6cklO2kbui44zleWqqBRdZXVcguGKL4h04PxcYlMT7hHrd2bUsegadRTqn57w
A3v9E3IHtBMfUxX5GiogarK/mmmdIs7AhN5RLL6A8ZzIOYe4taNUeXhl8E/MnyP6
ex1IvVHJkC3yIReXQJIrQ/g7OA3B1FJNYsUi7aLlz+nvZX7q4IgJ8u0GrlJKJ35r
gXs9h2Cccr8x2TNIPJirEGaj37xQpjCMAhryUTj9SgDpZXt/FxCjMMh51jSNrGRm
cvmnu8IfL/cYyoV9BwbuLh4LcGLXlx2osvHXwBuUBXee1IWVNPHqJRGxiQEWZF2k
s8i5x2L+l7eXCnt954LLN3mrv7huVuVtYmLv7h3E9sEmRm6XrtBiXPlgfjXn5Xmg
Ucy75Fk177VxEh5l+HEeQIPt9Y42JHM+zcVTBx6Ecp1Jsl1Dbo9H43Qs7+nQkKeL
pt/XrlZRiRvpyyksKmbMJA5FUhpnROic2PXJjdCCigtuDW7vAJTObXz23A0+hLCZ
PxkTj8llBCb9TMaMR75Nx7puxaZVr7Xi8m+pU3b1o2kkJQdDa2cnGXW9VFJ2Snn1
AIlAiSuCp26jQOYFxYAV
=+ckY
-----END PGP SIGNATURE-----

--=-RxFKWNXU27HGz+YVj0gw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
