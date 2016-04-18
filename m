From: Christoph Hellwig <hch@lst.de>
Subject: generic RDMA READ/WRITE API V7
Date: Mon, 18 Apr 2016 16:14:11 -0400
Message-ID: <1461010463-6603-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This series contains patches that implement a first version of a generi=
c
API to handle RDMA READ/WRITE operations as commonly used on the target
(or server) side for storage protocols.

This has been developed for the upcoming NVMe over Fabrics target, and
extensively te=D1=95ted as part of that, although this upstream version=
 has
additional updates over the one we're currently using.

It hides details such as the use of MRs for iWarp devices, and will all=
ow
looking at other HCA specifics easily in the future.

This series contains also conversion the SRP and iSER targets to the ne=
w
API.

I think it's basically ready to merge now.

I also have a git tree available at:

	git://git.infradead.org/users/hch/rdma.git rdma-rw-api

gitweb:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-r=
w-api

Changes since V6:
 - rebase to 4.6-rc4
 - addressed review comments from Bart on core comments and the srpt
   wait_list handling
 - added Reviewed-by: tags from Sagi

Changes since V5:
 - rebase to 4.6-rc3
 - now includes signature MR support
 - now contains the iSER target conversion
 - new module option for force MR usage for debugging purposes
 - fixes a bug with the non-merged SG count passes to the MR map
   routine, causing lockups when using SRP with MRs.
 - includes the mlx5 max_sg_rd fix (should probably go into 4.6-rc
   and -stable)

Changes since V4:
 - fix SG iteration in rdma_rw_init_mr_wrs
 - address various misc review feedback items from Bart and Leon

Changes since V3:
 - really fold the list_del in mr_pool_get into the right patch

Changes since V2:
 - fold the list_del in mr_pool_get into the right patch
 - clamp the max FR page size length
 - minor srpt style fix
 - spelling fixes
 - renamed rdma_has_read_invalidate to rdma_cap_read_inv

Changes since V1:
 - fixed offset handling in ib_sg_to_pages
 - uses proper SG iterators to handle larger than PAGE_SIZE segments
 - adjusted parameters for some functions to reduce size of the context
 - SRP target support

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
