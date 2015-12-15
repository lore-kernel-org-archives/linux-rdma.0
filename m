From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 00/11] Add RoCE v2 support
Date: Tue, 15 Dec 2015 16:45:21 -0500
Message-ID: <567089F1.30004@redhat.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eU8eR71QFdAG4u5fsO9EhPnL7OTu4m2eb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKM7j6w+Gk4PXXO+0mHpFeVaBdeNmr-z9V9fPR562o+kmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eU8eR71QFdAG4u5fsO9EhPnL7OTu4m2eb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/15/2015 02:15 AM, Moni Shoua wrote:
> On Thu, Dec 3, 2015 at 3:47 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
>> Hi Doug,
>>
>> This series adds the support for RoCE v2. In order to support RoCE v2,=

>> we add gid_type attribute to every GID. When the RoCE GID management
>> populates the GID table, it duplicates each GID with all supported typ=
es.
>> This gives the user the ability to communicate over each supported
>> type.
>>
>> Patch 0001, 0002 and 0003 add support for multiple GID types to the
>> cache and related APIs. The third patch exposes the GID attributes
>> information is sysfs.
>>
>> Patch 0004 adds the RoCE v2 GID type and the capabilities required
>> from the vendor in order to implement RoCE v2. These capabilities
>> are grouped together as RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP.
>>
>> RoCE v2 could work at IPv4 and IPv6 networks. When receiving ib_wc, th=
is
>> information should come from the vendor's driver. In case the vendor
>> doesn't supply this information, we parse the packet headers and resol=
ve
>> its network type. Patch 0005 adds this information and required utilit=
ies.
>>
>> Patches 0006 and 0007 adds route validation. This is mandatory to ensu=
re
>> that we send packets using GIDS which corresponds to a net-device that=

>> can be routed to the destination.
>>
>> Patches 0008 and 0009 add configfs support (and the required
>> infrastructure) for CMA. The administrator should be able to set the
>> default RoCE type. This is done through a new per-port
>> default_roce_mode configfs file.
>>
>> Patch 0010 formats a QP1 packet in order to support RoCE v2 CM
>> packets. This is required for vendors which implement their
>> QP1 as a Raw QP.
>>
>> Patch 0011 adds support for IPv4 multicast as an IPv4 network
>> requires IGMP to be sent in order to join multicast groups.
>>
>> Vendors code aren't part of this patch-set. Soft-Roce will be
>> sent soon and depends on these patches. Other vendors, like
>> mlx4, ocrdma and mlx5 will follow.
>>
>> This patch is applied on "Change per-entry locks in GID cache to table=
 lock"
>> which was sent to the mailing list.
>>
>> Thanks,
>> Matan
>>
>> Changed from V1:
>>  - Rebased against Linux 4.4-rc2 master branch.
>>  - Add route validation
>>  - ConfigFS - avoid compiling INFINIBAND=3Dy and CONFIGFS_FS=3Dm
>>  - Add documentation for configfs and sysfs ABI
>>  - Remove ifindex and gid_type from mcmember
>>
>> Changes from V0:
>>  - Rebased patches against Doug's latest k.o/for-4.4 tree.
>>  - Fixed a bug in configfs (rmdir caused an incorrect free).
>>
>> Matan Barak (8):
>>   IB/core: Add gid_type to gid attribute
>>   IB/cm: Use the source GID index type
>>   IB/core: Add gid attributes to sysfs
>>   IB/core: Add ROCE_UDP_ENCAP (RoCE V2) type
>>   IB/core: Move rdma_is_upper_dev_rcu to header file
>>   IB/core: Validate route in ib_init_ah_from_wc and ib_init_ah_from_pa=
th
>>   IB/rdma_cm: Add wrapper for cma reference count
>>   IB/cma: Add configfs for rdma_cm
>>
>> Moni Shoua (2):
>>   IB/core: Initialize UD header structure with IP and UDP headers
>>   IB/cma: Join and leave multicast groups with IGMP
>>
>> Somnath Kotur (1):
>>   IB/core: Add rdma_network_type to wc
>>
>>  Documentation/ABI/testing/configfs-rdma_cm       |  22 ++
>>  Documentation/ABI/testing/sysfs-class-infiniband |  16 ++
>>  drivers/infiniband/Kconfig                       |   9 +
>>  drivers/infiniband/core/Makefile                 |   2 +
>>  drivers/infiniband/core/addr.c                   | 185 +++++++++----
>>  drivers/infiniband/core/cache.c                  | 169 ++++++++----
>>  drivers/infiniband/core/cm.c                     |  31 ++-
>>  drivers/infiniband/core/cma.c                    | 261 ++++++++++++++=
++--
>>  drivers/infiniband/core/cma_configfs.c           | 321 ++++++++++++++=
+++++++++
>>  drivers/infiniband/core/core_priv.h              |  45 ++++
>>  drivers/infiniband/core/device.c                 |  10 +-
>>  drivers/infiniband/core/multicast.c              |  17 +-
>>  drivers/infiniband/core/roce_gid_mgmt.c          |  81 ++++--
>>  drivers/infiniband/core/sa_query.c               |  76 +++++-
>>  drivers/infiniband/core/sysfs.c                  | 184 ++++++++++++-
>>  drivers/infiniband/core/ud_header.c              | 155 ++++++++++-
>>  drivers/infiniband/core/uverbs_marshall.c        |   1 +
>>  drivers/infiniband/core/verbs.c                  | 170 ++++++++++--
>>  drivers/infiniband/hw/mlx4/qp.c                  |   7 +-
>>  drivers/infiniband/hw/mthca/mthca_qp.c           |   2 +-
>>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c         |   2 +-
>>  include/rdma/ib_addr.h                           |  11 +-
>>  include/rdma/ib_cache.h                          |   4 +
>>  include/rdma/ib_pack.h                           |  45 +++-
>>  include/rdma/ib_sa.h                             |   3 +
>>  include/rdma/ib_verbs.h                          |  78 +++++-
>>  26 files changed, 1704 insertions(+), 203 deletions(-)
>>  create mode 100644 Documentation/ABI/testing/configfs-rdma_cm
>>  create mode 100644 Documentation/ABI/testing/sysfs-class-infiniband
>>  create mode 100644 drivers/infiniband/core/cma_configfs.c
> Doug
> What's your stand here?
> Besides the disagreement on patch #5 in the series there seems to be
> no major comments
> And regarding patch #5 I still claim that the implementation fits the
> spec and therefore is how it should be.
> How can we move on?

I had hoped that you and Jason would converge on an agreement.  Absent
that, I need time to do a detailed review of the code, and how this code
interacts with the existing namespace patches, to see who's right.

In particular, Liran piped up with this comment:

"Also, I don't want to do any route resolution on the Rx path. A UD QP
completion just reports the details of the packet it received.

Conceptually, an incoming packet may not even match an SGID index at
all.  Maybe, responses should be sent from another device. This should
not be decided that the point that a packet was received."

The part that bothers me about this is that this statement makes sense
when just thinking about the spec, as you say.  However, once you
consider namespaces, security implications make this statement spec
compliant, but still unacceptable.  The spec itself is silent on
namespaces.  But, you guys wanted, and you got, namespace support.
Since that's beyond spec, and carries security requirements, I think
it's fair to say that from now on, the Linux kernel RDMA stack can no
longer *just* be spec compliant.  There are additional concerns that
must always be addressed with new changes, and those are the namespace
constraint preservation concerns.

Since you and Jason did not reach a consensus, I have to dig in and see
if these patches make it possible to break namespace confinement, either
accidentally or with intentionally tricky behavior.  That's going to
take me some time.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--eU8eR71QFdAG4u5fsO9EhPnL7OTu4m2eb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWcInxAAoJELgmozMOVy/dsTEP/RouMUpNGaBwje0qKuAnyBfx
G3BgpoIByX2mebHZ+in00mw7GurCEkSaIVIXF6L0io9hF8AJ9Muxsz0CwEa3qhu5
ovg6wlmyNTA5Yp1zGhktLybl8gOeRz/n6hX81+5Ov0285ebq6djpZEufmcKT7OE1
wgzwtXMTb3422/cVtMf0gkL0gQgWoqzT1Q/+B/vVxUrFuR1x25o47Ew2g8ALUyzT
mSumnQ/SYzx2K1gVUf+2+26lFHnJYVBPR+YOSyZrAfvXM1xdMiiffoGuYx+Se5CB
odVYQrpDqHBeRR+tvR9T5xfxoMApDfFqe7ZmdKl2QwpQP9q2wEVd/MC6oNIIpWcl
V2Sg2jrmPPrPSugz0Sls/Yg6g0/GcJqVNxAs0Sjiu7eIL6B8E5p9XtrvQjSz5irP
55cNop8ZGuO0WJEwJZ/2AUbcX0dCYn2UbebkVWzMoafxXAG3UPvbF/qKja5y4mc/
qL6d/z5daw/OiSqelF9K8XOcPhCEtxb8XIaqhcZWJjbMoM0r/jSdIngo70MJoF7D
NOKITsGySjB4oqjfGMhbI26PVOsteTdZHXsFKCu8rOmrEpcsDAK9ElMwUujdogMY
cFeM+6IbsTLxtjtSNcTspWyB08+uz7gjmg/i91NMkODAM+e5xZk/FnjzQw9l3eUa
NFDVymmWmFqLF3BHv2mx
=PxRi
-----END PGP SIGNATURE-----

--eU8eR71QFdAG4u5fsO9EhPnL7OTu4m2eb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
