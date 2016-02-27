From: Christoph Hellwig <hch@lst.de>
Subject: RFC: a first draft of a generic RDMA READ/WRITE API
Date: Sat, 27 Feb 2016 19:10:18 +0100
Message-ID: <1456596631-19418-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
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

This series contains a RFC conversion of the iSER target, although that
has hacky and probably not working signature MR support, otherwise I
would have actually proposed it for inclusion.  The iSER conversion
also contains my conversion to the CQ API, which now landed =D1=96n the
target tree in an updated version.  It is only included for conveniance=
=2E

One thing that I could not wrap my head around is support for the
current SRP target - SRP allows for multiple rkeys in a single request,
and the SRP target driver wants to map those to a single struct
scatterlist.  If anyone has ideas how to support that nicely: ideas
are welcome.

I also have a git tree available at:

	git://git.infradead.org/users/hch/rdma.git rdma-rw-api

Gitweb:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-r=
w-api
