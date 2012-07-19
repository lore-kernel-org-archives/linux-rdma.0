From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH net/for-next V1 1/1] IB/ipoib: break linkage to neighbouring
 system
Date: Thu, 19 Jul 2012 16:30:44 +0300
Message-ID: <50080C04.6060909@mellanox.com>
References: <1342703938-29904-1-git-send-email-ogerlitz@mellanox.com> <1342703938-29904-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342703938-29904-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It seems that for some reason the cover-letter wasn't sent properly,
here's listing of the changes:

changes from V0:

- following feedback from Mike and Dave, changed the ipoib_neigh hash table
   to allow for lock-free read side, the model follows the RCU based 
implementation
   in net/core/neighbour.c

- since RCU hash table uses unidirectional collision list, now 
ipoib_neigh_free
   needs to do a linked search in order to find the deleted neighbour 
predecessor
   in order to link it to the neighbour successor.

- different implementation of hash lookup in ipoib_neigh_get (read-side)
   vs ipoib_neigh_alloc and ipoib_neigh_free (write-side)

- path_free and ipoib_mcast_free now make use of the 
ipoib_del_neighs_by_gid helper
   function in order to delete neighbours related to that path or mcast. 
This new helper
   scans the hash table and deletes neighbours with the given GID. It 
had to be done
   this way of as  of the unidrectional nature of the linking which by 
itself
   arises from the lock free requirement made here...

- a completion mechanism was added to prevent freeing the IPoIB 
netdevice priv
   data structure before the RCU based code freed all the neighbours.

Again, the patch was made over net-next as of few IPoIB changes that
took place there and the parallel submission of the eIPoIB driver.

Or.

Shlomo Pongratz (1):
   IB/ipoib: break linkage to neighbouring system

  drivers/infiniband/ulp/ipoib/ipoib.h           |   59 ++-
  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   16 +-
  drivers/infiniband/ulp/ipoib/ipoib_main.c      |  638 
+++++++++++++++++------
  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   57 +--
  4 files changed, 535 insertions(+), 235 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
