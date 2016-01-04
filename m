From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC contig pages support 1/2] IB: Supports contiguous memory
 operations
Date: Mon, 4 Jan 2016 15:44:43 +0100
Message-ID: <568A855B.7060509@suse.cz>
References: <1449587707-24214-1-git-send-email-yishaih@mellanox.com>
 <1449587707-24214-2-git-send-email-yishaih@mellanox.com>
 <20151208151852.GA6688@infradead.org>
 <20151208171542.GB13549@obsidianresearch.com>
 <AM4PR05MB146005B448BEA876519335CDDCE80@AM4PR05MB1460.eurprd05.prod.outlook.com>
 <20151209183940.GA4522@infradead.org>
 <AM4PR05MB14603FC8169D50AD2A8F5AA3DCEC0@AM4PR05MB1460.eurprd05.prod.outlook.com>
 <56796538.9040906@suse.cz>
 <AM4PR05MB14603CF21CB493086BDEE026DCE60@AM4PR05MB1460.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <AM4PR05MB14603CF21CB493086BDEE026DCE60@AM4PR05MB1460.eurprd05.prod.outlook.com>
Sender: owner-linux-mm@kvack.org
To: Shachar Raindel <raindel@mellanox.com>, Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Yishai Hadas <yishaih@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Tal Alon <talal@mellanox.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>
List-Id: linux-rdma@vger.kernel.org

[Sorry for resending, forgot to CC Minchan]

On 12/23/2015 05:30 PM, Shachar Raindel wrote:
 >>>
 >>> I completely agree, and this RFC was sent in order to start discussion
 >>> on this subject.
 >>>
 >>> Dear MM people, can you please advise on the subject?
 >>>
 >>> Multiple HW vendors, from different fields, ranging between embedded
 >> SoC
 >>> devices (TI) and HPC (Mellanox) are looking for a solution to allocate
 >>> blocks of contiguous memory to user space applications, without using
 >> huge
 >>> pages.
 >>>
 >>> What should be the API to expose such feature?
 >>>
 >>> Should we create a virtual FS that allows the user to create "files"
 >>> representing memory allocations, and define the contiguous level we
 >>> attempt to allocate using folders (similar to hugetlbfs)?
 >>>
 >>> Should we patch hugetlbfs to allow allocation of contiguous memory
 >> chunks,
 >>> without creating larger memory mapping in the CPU page tables?
 >>>
 >>> Should we create a special "allocator" virtual device, that will hand
 >> out
 >>> memory in contiguous chunks via a call to mmap with an FD connected to
 >> the
 >>> device?
 >>
 >> How much memory do you assume to be used like this?
 >
 > Depends on the use case. Most likely several MBs/core, used for 
interfacing
 > with the HW (packet rings, frame buffers, etc.).
 >
 > Some applications might want to perform calculations in such memory, to
 > optimize communication time, especially in the HPC market.

OK.

 >
 >> Is this memory
 >> supposed to be swappable, migratable, etc? I.e. on LRU lists?
 >
 > Most likely not. In many of the relevant applications (embedded, HPC),
 > there is no swap and the application threads are pinned to specific cores
 > and NUMA nodes.
 > The biggest pain here is that these memory pages will not be eligible for
 > compaction, making it harder to handle fragmentations and CMA allocation
 > requests.

There was a patch set to enable compaction on such pages, see 
https://lwn.net/Articles/650917/
Minchan was going to pick this after Gioh left, and then it should be 
possible. But it requires careful driver-specific cooperation, i.e. when 
a page can be isolated for the migration, see 
http://article.gmane.org/gmane.linux.kernel.mm/136457

 >> Allocating a lot of memory (e.g. most of userspace memory) that's not
 >> LRU wouldn't be nice. But LRU operations are not prepared to work witch
 >> such non-standard-sized allocations, regardless of what API you use.  So
 >> I think that's the more fundamental questions here.
 >
 > I agree that there are fundamental questions here.
 >
 > That being said, there is a clear need for an API allowing
 > allocation, to the user space, limited size of memory that
 > is composed of large contiguous blocks.
 >
 > What will be the best way to implement such solution?

Given the likely driver-specific constraints/handling of the page 
migration, I'm not sure if some completely universal API is feasible.
Maybe some reusable parts of the functionality in the patch in this 
thread could be provided by mm.

 > Thanks,
 > --Shachar
 >
 > --
 > To unsubscribe, send a message with 'unsubscribe linux-mm' in
 > the body to majordomo@kvack.org.  For more info on Linux MM,
 > see: http://www.linux-mm.org/ .
 > Don't email: <a href=ilto:"dont@kvack.org"> email@kvack.org </a>
 >

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
