From: Christoph Hellwig <hch@lst.de>
Subject: generic RDMA READ/WRITE API V5
Date: Fri, 11 Mar 2016 19:53:10 +0100
Message-ID: <1457722399-25811-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com, bart.vanassche@sandisk.com
Cc: swise@opengridcomputing.com, sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
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

This series contains a conversion of the SRP target, and the git tree
below also has a RFC conversion of the iSER target (a little hacky
due to the signature MR support which I can't test)

I think it's basically ready to merge now.

I also have a git tree available at:

	git://git.infradead.org/users/hch/rdma.git rdma-rw-api

Gitweb:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-r=
w-api

These two also include the RFC iSER target conversion.

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
