From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Sat, 16 Dec 2017 10:12:17 -0700
Message-ID: <20171216171217.GA16500@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

More fixes from testing done on the rc kernel, including more SELinux testing.
Looking forward, lockdep found regression today in ipoib which is still
being fixed.

The following changes since commit 315d160c5a4e034a576a13aa21e7235d5c9ec609:

  IB/core: Only enforce security for InfiniBand (2017-12-01 12:21:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 9d98e19ba08f6aa33a4a1414f3dfe8440e67530c:

  IB/ipoib: Restore MM behavior in case of tx_ring allocation failure (2017-12-13 10:31:57 -0700)

----------------------------------------------------------------
Second pull request for 4.15-rc

- Fix for SELinux on the umad SMI path. Some old hardware
  does not fill the PKey properly exposing another bug in the newer
  SELinux code.
- Check the input port as we can exceed array bounds from this
  user supplied value
- Users are unable to use the hash field support as they want due to
  incorrect checks on the field restrictions, correct that so the
  feature works as intended
- User triggerable oops in the NETLINK_RDMA handler
- cxgb4 driver fix for a bad interaction with CQ flushing in iser
  caused by patches in this merge window, and bad CQ flushing during
  normal close.
- Unbalanced memalloc_noio in ipoib in an error path.

----------------------------------------------------------------
Daniel Jurgens (2):
      IB/core: Bound check alternate path port number
      IB/core: Don't enforce PKey security on SMI MADs

Guy Levi (1):
      IB/mlx4: Fix RSS hash fields restrictions

Leon Romanovsky (1):
      RDMA/netlink: Fix general protection fault

Steve Wise (2):
      iw_cxgb4: only clear the ARMED bit if a notification is needed
      iw_cxgb4: only insert drain cqes if wq is flushed

Yuval Shaia (1):
      IB/ipoib: Restore MM behavior in case of tx_ring allocation failure

 drivers/infiniband/core/cma.c           |  2 +-
 drivers/infiniband/core/device.c        |  2 +-
 drivers/infiniband/core/iwcm.c          |  2 +-
 drivers/infiniband/core/nldev.c         |  2 +-
 drivers/infiniband/core/security.c      |  7 +++++--
 drivers/infiniband/core/uverbs_cmd.c    |  6 ++++++
 drivers/infiniband/hw/cxgb4/cq.c        |  5 +++++
 drivers/infiniband/hw/cxgb4/qp.c        | 22 ++++++++++++++++------
 drivers/infiniband/hw/mlx4/qp.c         | 26 +++++++++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |  1 +
 10 files changed, 56 insertions(+), 19 deletions(-)

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJaNVPuAAoJEDht9xV+IJsa2zIP/2/eQ57uEhig3AQWuEc2LmPd
Rk8FNAlMHo/CEDOYHXeDNcEOq3PVIJDzgokVNBq36jWc0OoO6Ktdaaq46IKxeFyh
hb58kU0JdFHfeXUpXg2/0ZUjo7u4ZWMLjOm87k62My/OXZKqqaomV+w3qyJ5SpzB
ur+iSxgMICs7rwWmhlkyqSTEAUANhjQ5iRb72VMDuPixu0VFlqBX6iyLy248sgts
3PCmPJIEDrY2JoVwTLdg2YdEz0WEPz9xNdtBUZ++M7Es1IT50MWAA2u/5WrbWcAU
cEIOpDdYNMYd88vhV9LKDJLksvl/FOoOhpddlToXT9D0JPuTtRSrjiDqjvvnswDF
/XDxScsdz+FW/GRn23i2kq81EzURgLe46yOqilYodheoqwaE2FzxVL+JK8V5Quwo
lESEaPdiCA3ZqFRnUxwT4QuDXmBKU+9IfDyBBSeLBEtLX6l8v8N6mIXpWbz6P2db
2muqcPDe3Xf0iuKDn8YK67QzqIM9QYL0N4xnACJFP4lZFACmljIJoVVwqD9tH306
PhiI5Y3SWnnaA+3s3Dvl4c6txYyfo0BD1GPZgHJGKp5ICL7kcgW5uEIRSJLBxxhx
4pXwESmjplUZObe1nzNWfaCaNDA+bmQ5VuooIMj+ywpmIo5WPDuJpN0ykZXoZ+Mq
m/LWq+r1xjfRRhVzGeTP
=hsoH
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
