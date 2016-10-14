From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus)
Date: Fri, 14 Oct 2016 16:37:19 -0400
Message-ID: <7c0a013c-6b5a-4031-9fd7-b511b1799528@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Iu4TiUSW93oQRsu3PrkhW92en1vKmccQ0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Iu4TiUSW93oQRsu3PrkhW92en1vKmccQ0
Content-Type: multipart/mixed; boundary="11iQiDi6FE9ilpabBcsQbDbFDBDNSicdP";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <7c0a013c-6b5a-4031-9fd7-b511b1799528-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git (tag for-linus)

--11iQiDi6FE9ilpabBcsQbDbFDBDNSicdP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Early on in the merge window I mentioned I had a backlog of new drivers
waiting to be reviewed and that, in addition to the hns-roce driver, I
wanted to get possible a couple more reviewed.  I ended up only having
the time to complete one of the additional drivers.  During Dave
Miller's pull request this go around, there were a series of 9 patches
to the QLogic qed net driver that add basic support for a paired RoCE
driver.  That support is currently not functional because it is missing
the matching RoCE driver in the RDMA subsystem.  I managed to finish
that review.  However, because it goes against part of Dave's net pull,
and a part that was accepted a day or two after the merge window opened,
to apply cleanly it has to be applied to either the tip of Dave's net
branch, or as I did in this case, I just applied it to your master after
you had taken Dave's pull request.  I know this is large for the end of
the merge window, my apologies for that.  I have a considerable backlog
of new drivers awaiting review and final approval (still three more even
after the hns-roce and qedr), so I would appreciate it if we could take
this so I can check it off of my list.

Here's the boilerplate:

The following changes since commit e9f8f48bcac6f6dd37ad89ad63d1d1a4973323=
13:

  Merge tag 'metag-for-v4.9-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag (2016-10-14
11:11:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 993d1b52615e1a549e55875c3b74308391672d9f:

  qedr: Add events support and register IB device (2016-10-14 15:00:10
-0400)

----------------------------------------------------------------
Merge of the qedr RoCE driver

----------------------------------------------------------------
Ram Amrani (10):
      qedr: Add RoCE driver framework
      qedr: Add support for RoCE HW init
      qedr: Add support for user context verbs
      qedr: Add support for PD,PKEY and CQ verbs
      qedr: Add support for QP verbs
      qedr: Add support for memory registeration verbs
      qedr: Add support for data path
      qedr: Add LL2 RoCE interface
      qedr: Add GSI support
      qedr: Add events support and register IB device

 drivers/infiniband/Kconfig                 |    2 +
 drivers/infiniband/hw/Makefile             |    1 +
 drivers/infiniband/hw/qedr/Kconfig         |    7 +
 drivers/infiniband/hw/qedr/Makefile        |    3 +
 drivers/infiniband/hw/qedr/main.c          |  914 +++++++
 drivers/infiniband/hw/qedr/qedr.h          |  495 ++++
 drivers/infiniband/hw/qedr/qedr_cm.c       |  622 +++++
 drivers/infiniband/hw/qedr/qedr_cm.h       |   61 +
 drivers/infiniband/hw/qedr/qedr_hsi.h      |   56 +
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h |  748 ++++++
 drivers/infiniband/hw/qedr/verbs.c         | 3547
++++++++++++++++++++++++++++
 drivers/infiniband/hw/qedr/verbs.h         |  101 +
 drivers/net/ethernet/qlogic/Kconfig        |   11 -
 include/uapi/linux/pci_regs.h              |    3 +
 include/uapi/rdma/qedr-abi.h               |  106 +
 15 files changed, 6666 insertions(+), 11 deletions(-)
 create mode 100644 drivers/infiniband/hw/qedr/Kconfig
 create mode 100644 drivers/infiniband/hw/qedr/Makefile
 create mode 100644 drivers/infiniband/hw/qedr/main.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_cm.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr_cm.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_hsi.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h
 create mode 100644 drivers/infiniband/hw/qedr/verbs.c
 create mode 100644 drivers/infiniband/hw/qedr/verbs.h
 create mode 100644 include/uapi/rdma/qedr-abi.h

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--11iQiDi6FE9ilpabBcsQbDbFDBDNSicdP--

--Iu4TiUSW93oQRsu3PrkhW92en1vKmccQ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYAUH/AAoJELgmozMOVy/dEEEP/RC2KKa+mx8lFBedvVmFlmLC
2Tjplax29d3GJxYHSuA4x5XeM8d0YXGz+HehsOzctfza2xrdgDhjUjUyE1L24Ttp
vI1CTjhde+h6xaif9RQPqrprDDTCyIL5r4EtEr0c+CuQtRWjkj78cTms2qO0z/5r
1tX8JB52BXRjM5U9CAFdyXEHJrWb/bgyF+NEIcSQrrWXY9Y8vVYGQmDm6LdBjySP
ZCOvrrcglsFQQpZ9xppLnJS7KcSRsj2U7599ebSOXkFO6XyGjCaOUuflAZj3q5q3
s7aPv2YYs2R0n88mz+IPO26x61O3f0XJZW0BJ1Kt696PD5tqORkYV0PHVuWHVSEH
MbC5/U8u+gOvELzVL+Gg//R/9+/94xA2Ms3YU3WwOj3w4FODWKzfx44xE4AGv8DC
cLeN/zTP/bXUSKQi32pc8bS+I5elxo4hx4v4GA8Bc9VyB/lSWU2VJXUyowc5cqDL
FtK/k4uW0wdjyD4j+aYXv1Ve6e6oNjwauPDh4o4mtepc2906htflSMDVan0aTrbg
UH3d7LioGBaPjFnEc3jlrnvVCWMNjVVjKijgUkrWuvuISAUcpFK3w131/G1Zqi8w
I6gU9RrORrvyktXLs4S/RARdpd29MdUNT7dCn+hQDlI71hrObIBdQPz/LoMVhnV7
EVqyex4oWYmA+zHIeTGA
=vcuX
-----END PGP SIGNATURE-----

--Iu4TiUSW93oQRsu3PrkhW92en1vKmccQ0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
