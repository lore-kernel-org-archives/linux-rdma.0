From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 0/4] Fix returning correct GIDs for RoCE
Date: Thu, 18 Jan 2018 10:11:15 +0200
Message-ID: <20180118081119.30024-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
 v0 -> v1:
  * Returned zeros when device is not yet bound to cm_id.
  * Reordered patches.
  * Moved checks of being not-NULL for the sgid, dgid into rdma_read_gids()
    and made that function ugly like hell.

--------------------------------------------------------------------
>From Parav:

Currently there are few issues with rdma_addr_get_dgid() and
rdma_addr_get_sgid() APIs. They are described below.

1. rdma_addr_get_dgid() returns MAC address for RoCE connections.
2. rdma_addr_get_sgid() returns SGID based on IPv4 address regardless
of connection of AF_INET or AF_INET6 type; resulting into returning
incorrect SGID.
3. rdma_addr_get_sgid() returns SGID based on the first IP address of
the netdevice interface. netdevice can have multiple IP adresses. When
connection is established by non first IP address, this results into
returning incorrect SGID.
4. rdma_addr_get_sgid() is not actually used in connection establishment
APIs such as rdma_resolve_addr(), rdma_resolve_route(), rdma_accept()
for RoCE transport.
RoCE specific rdma cm APIs have used ip2gid() API to derive SGID.

Additionally, ULP module such as net/rds accesses some of the internal
data structures of the rdma_cm_id, such as rdma_route and rdma_addr
structure which might not be the best way to access GIDs.

rdma_ucm module provides GIDs to user space via ucma_query_gid() API.
In certain above conditions it returns incorrect GIDs.

Therefore, this patchset introduces a transport agnostic API for
existing ULP such as rds and rdma_ucm to query GIDs for a given
connection referred by rdma_cm_id.

Since rdma_addr_get_sgid() is not used for RoCE transport during
connection establishment phase, iboe_addr_get_sgid() is removed.
rdma_addr_get_sgid() is refactored for such simplicity.

rdma_read_gids() new API is introduced that allows to read the SGID
and/or DGID of the rdma_cm_id for client and server side connections.

Therefore, this patchset introduces a transport agnostic API for
existing ULP such as rds and rdma_ucm to query GIDs for a given
connection referred by rdma_cm_id.

Since RoCE support was incrementally added, there is no specific commit
id that can be qualified as breaking rdma_addr_get_sgid() API.
rdma_addr_get_dgid() was written initially without RoCE transport in
consideration. When RoCE support was added incrementally, this API
remained broken.

Thanks

Parav Pandit (4):
  RDMA/cma: Introduce API to read GIDs for multiple transports
  RDMA/ucma: Use rdma cm API to query GID
  net/rds: Use rdma_read_gids to read connection GIDs
  RDMA/core: Simplify rdma_addr_get_sgid() to not support RoCE

 drivers/infiniband/core/cma.c  | 27 +++++++++++++++++++++++++++
 drivers/infiniband/core/ucma.c |  8 ++++----
 include/rdma/ib_addr.h         | 33 +++++++--------------------------
 include/rdma/rdma_cm.h         | 19 +++++++++++++++++++
 net/rds/ib.c                   |  6 ++----
 5 files changed, 59 insertions(+), 34 deletions(-)

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
