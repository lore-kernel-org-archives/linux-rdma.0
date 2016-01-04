From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC contig pages support 1/2] IB: Supports contiguous memory
 operations
Date: Mon, 4 Jan 2016 15:43:59 +0100
Message-ID: <568A852F.6080806@suse.cz>
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
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR05MB14603CF21CB493086BDEE026DCE60-n5Jp0YuYvM1n/kQvjoF5G9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
 > the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
 > see: http://www.linux-mm.org/ .
 > Don't email: <a href=ilto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
 >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
