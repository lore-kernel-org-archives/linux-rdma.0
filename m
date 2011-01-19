From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 18 Jan 2011 23:27:14 -0500
Message-ID: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A persistent thorn in our side has been getting large (1 MB+) requests
from SRP on a system that has been up for any period of time. As we're
using RAID6 8+2 LUNs, we need to generate a full 1 MB IO to avoid a R/M/W
cycle on some hardware, and other hardware just likes the larger requests,
even without the penalty of an R/M/W cycle. The existing code wouldn't 
reliably generate the requests because its sg_tablesize was limited to
255, or less, due to the number of descriptors we could describe in the
SRP_CMD message.

Now that at least one vendor is implementing full support for the SRP
indirect memory descriptor tables, we can safely expand the sg_tablesize,
and realize some performance gains, in many cases quite large. I don't
have vendor code that implements the full support needed for safety, but
the rareness of FMR mapping failures allows the mapping code to function,
at a risk, with existing targets.

I've done some quick testing against an older generation of hardware RAID6
for these numbers.  They are streaming writes using a queue depth of 64.
The SATA numbers are against a LUN built with 8+2 1 TB SATA drives; the SAS
numbers are against a LUN built with two volumes of 8+2 1 TB SAS drives in
a RAID 0 config.  In all cases, the write cache is disabled, and
dma_boundary on the SRP initiator is set such that no coalescing occurs on
the SG list. The IOMMU has been disabled, and max_sectors_kb has been set
to the IO size under test, which matches the IO request size from the
application. For the baseline testing, the IO request is broken into
multiple pieces before being sent due to the sg_tablesize being capped at
255. For the patched numbers, the request was sent intact. These numbers
are for SRP_FMR_SIZE == 256, but I expect the 512 numbers to be similar.


Device	Size	Baseline	Patched
SAS	1M	524 MB/s	1004 MB/s
SAS	2M	520 MB/s	861 MB/s
SAS	4M	529 MB/s	921 MB/s
SAS	8M	600 MB/s	951 MB/s

SATA	1M	385 MB/s	515 MB/s
SATA	2M	394 MB/s	591 MB/s
SATA	4M	377 MB/s	565 MB/s
SATA	8M	419 MB/s	616 MB/s


Similar gains are found at other queue depths, but I've not done a full
parameter search.

Testing the lock scaling capability with fio indicates an increase in
command throughput except in the single threaded case. This is an
unexpected improvement and needs further examination.

I've only played with performance testing; I need to test data integrity
as well.



David Dillow (8):
  IB/srp: always avoid non-zero offsets into an FMR
  IB/srp: move IB CM setup completion into its own function
  IB/srp: allow sg_tablesize to be set for each target
  IB/srp: rework mapping engine to use multiple FMR entries
  IB/srp: add safety valve for large SG tables without HW support
  IB/srp: add support for indirect tables that don't fit in SRP_CMD
  IB/srp: try to use larger FMR sizes to cover our mappings
  IB/srp and direct IO: patches for testing large indirect tables

 drivers/infiniband/ulp/srp/ib_srp.c |  736 +++++++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |   38 ++-
 fs/direct-io.c                      |    1 +
 3 files changed, 525 insertions(+), 250 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
