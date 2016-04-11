From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: generic RDMA READ/WRITE API V6
Date: Mon, 11 Apr 2016 14:32:28 -0700
Message-ID: <1460410360-13104-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
