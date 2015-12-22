From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC contig pages support 1/2] IB: Supports contiguous memory
 operations
Date: Tue, 22 Dec 2015 15:59:04 +0100
Message-ID: <56796538.9040906@suse.cz>
References: <1449587707-24214-1-git-send-email-yishaih@mellanox.com>
 <1449587707-24214-2-git-send-email-yishaih@mellanox.com>
 <20151208151852.GA6688@infradead.org>
 <20151208171542.GB13549@obsidianresearch.com>
 <AM4PR05MB146005B448BEA876519335CDDCE80@AM4PR05MB1460.eurprd05.prod.outlook.com>
 <20151209183940.GA4522@infradead.org>
 <AM4PR05MB14603FC8169D50AD2A8F5AA3DCEC0@AM4PR05MB1460.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR05MB14603FC8169D50AD2A8F5AA3DCEC0-n5Jp0YuYvM1n/kQvjoF5G9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/13/2015 01:48 PM, Shachar Raindel wrote:
>
>
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
>> Sent: Wednesday, December 09, 2015 8:40 PM
>>
>> On Wed, Dec 09, 2015 at 10:00:02AM +0000, Shachar Raindel wrote:
>>> As far as gain is concerned, we are seeing gains in two cases here:
>>> 1. If the system has lots of non-fragmented, free memory, you can
>> create large contig blocks that are above the CPU huge page size.
>>> 2. If the system memory is very fragmented, you cannot allocate huge
>> pages. However, an API that allows you to create small (i.e. 64KB,
>> 128KB, etc.) contig blocks reduces the load on the HW page tables and
>> caches.
>>
>> None of that is a uniqueue requirement for the mlx4 devices.  Again,
>> please work with the memory management folks to address your
>> requirements in a generic way!
>
> I completely agree, and this RFC was sent in order to start discussion
> on this subject.
>
> Dear MM people, can you please advise on the subject?
>
> Multiple HW vendors, from different fields, ranging between embedded SoC
> devices (TI) and HPC (Mellanox) are looking for a solution to allocate
> blocks of contiguous memory to user space applications, without using huge
> pages.
>
> What should be the API to expose such feature?
>
> Should we create a virtual FS that allows the user to create "files"
> representing memory allocations, and define the contiguous level we
> attempt to allocate using folders (similar to hugetlbfs)?
>
> Should we patch hugetlbfs to allow allocation of contiguous memory chunks,
> without creating larger memory mapping in the CPU page tables?
>
> Should we create a special "allocator" virtual device, that will hand out
> memory in contiguous chunks via a call to mmap with an FD connected to the
> device?

How much memory do you assume to be used like this? Is this memory 
supposed to be swappable, migratable, etc? I.e. on LRU lists?
Allocating a lot of memory (e.g. most of userspace memory) that's not 
LRU wouldn't be nice. But LRU operations are not prepared to work witch 
such non-standard-sized allocations, regardless of what API you use.  So 
I think that's the more fundamental questions here.

> Thanks,
> --Shachar
>
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
