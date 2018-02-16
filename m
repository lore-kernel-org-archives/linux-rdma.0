From: Christoph Lameter <cl@linux.com>
Subject: [RFC 0/2] Larger Order Protection V1
Date: Fri, 16 Feb 2018 10:01:10 -0600
Message-ID: <20180216160110.641666320@linux.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Mel Gorman <mel@skynet.ie>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, akpm@linux-foundation.org, Thomas Schoebel-Theuer <tst@schoebel-theuer.de>, andi@firstfloor.org, Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@kernel.org>, Guy Shattah <sguy@mellanox.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Nazarewicz <mina86@mina86.com>, Vlastimil Babka <vbabka@suse.cz>, David Nellans <dnellans@nvidia.com>, Laura Abbott <labbott@redhat.com>, Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave.hansen@intel.com>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-rdma@vger.kernel.org

We have discussed for years ways to create more reliable ways to allocate large contiguous
memory segments and to avoid fragmentation. This is an ad hoc scheme based on reservation
of higher order pages in the page allocator. It is fully transparent and integrated
into the page allocator.

This approach goes back to the meeting on contiguous memory at the Plumbers conference
in 2017 and the effort by Guy and Mike Kravetz to establish and API to map contiguous
memory segments into user space. Reservations will allow the contiguous memory allocations
to work even after the system has run for a considerable time.

Contiguous memory is also important for general system performance. F.e. slab
allocators can be made to use large frames in order to optimize performance.
See patch 1.

Other use cases are jumbo frames or device driver specific allocations.

For more on this see Mike Kravetz patches in particular 

Mike Kravetz MMAP CONTIG flag support at

https://lkml.org/lkml/2017/10/3/992


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
