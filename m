From: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Sun, 19 Jun 2016 12:58:59 +0300
Message-ID: <57666CE3.3070803@gmail.com>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
 <20160615031525.14794.69066.stgit@manet.1015granger.net>
 <20160615042849.GR5408@leon.nu>
 <68F7CD80-0092-4B55-9FAD-4C54D284BCA3@oracle.com>
 <20160616143518.GX5408@leon.nu> <576315C9.30002@gmail.com>
 <652EBA09-2978-414C-8606-38A96C63365A@oracle.com>
 <20160617092018.GZ5408@leon.nu>
 <4D23496A-FE01-4693-B125-82CD03B8F2D4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D23496A-FE01-4693-B125-82CD03B8F2D4-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> In mlx5 system, we always added 2048 bytes to such allocations, for
>> reasons unknown to me. And it doesn't seem as a conservative approach
>> either.
>
> The mlx5 approach is much better than allocating a whole
> page, when you consider platforms with 64KB pages.
>
> A 1MB payload (for NFS) on such a platform comprises just
> 16 pages. So xprtrdma will allocate MRs with support for
> 16 pages. That's a priv pages array of 128 bytes, and you
> just put it in a 64KB page all by itself.
>
> So maybe adding 2048 bytes is not optimal either. But I
> think sticking with kmalloc here is a more optimal choice.

Again, the 2K constraint is not coming from any sort of dma mapping
alignment consideration, it comes from the _device_ limitation requiring
the translation vector to be aligned to 2K.

>>>> Also, I don't see how that solves the issue, I'm not sure I even
>>>> understand the issue. Do you? Were you able to reproduce it?
>>>
>>> The issue is that dma_map_single() does not seem to DMA map
>>> portions of a memory region that are past the end of the first
>>> page of that region. Maybe that's a bug?
>>
>> No, I didn't find support for that. Function dma_map_single expects
>> contiguous memory aligned to cache line, there is no limitation to be
>> page bounded.
>
> There certainly isn't, but that doesn't mean there can't
> be a bug somewhere ;-) and maybe not in dma_map_single.
> It could be that the "array on one page only" limitation
> is somewhere else in the mlx4 driver, or even in the HCA
> firmware.

I'm starting to think this is the case. Leon, I think it's time
to get the FW/HW guys involved...

>> I disagree, kmalloc with supplied flags will return contiguous memory
>> which is enough for dma_map_single. It is cache line alignment.
>
> The reason I find this hard to believe is that there is
> no end alignment guarantee at all in this code, but it
> works without issue when SLUB debugging is not enabled.
>
> xprtrdma allocates 256 elements in this array on x86.
> The code makes the array start on an 0x40 byte boundary.
> I'm pretty sure that means the end of that array will
> also be on at least an 0x40 byte boundary, and thus
> aligned to the DMA cacheline, whether or not SLUB
> debugging is enabled.
>
> Notice that in the current code, if the consumer requests
> an odd number of SGs, that array can't possibly end on
> an alignment boundary. But we've never had a complaint.
>
> SLUB debugging changes the alignment of lots of things,
> but mlx4_alloc_priv_pages is the only breakage that has
> been reported.

I tend to agree, I even have a feeling that this won't happen
on mlx5.

> DMA-API.txt says:
>
>> [T]he mapped region must begin exactly on a cache line
>> boundary and end exactly on one (to prevent two separately
>> mapped regions from sharing a single cache line)
>
> The way I read this, cacheline alignment shouldn't be
> an issue at all, as long as DMA cachelines aren't
> shared between mappings.
>
> If I simply increase the memory allocation size a little
> and ensure the end of the mapping is aligned, that should
> be enough to prevent DMA cacheline sharing with another
> memory allocation on the same page. But I still see Local
> Protection Errors when SLUB debugging is enabled, on my
> system (with patches to allocate more pages per MR).
>
> I'm not convinced this has anything to do with DMA
> cacheline alignment. The reason your patch fixes this
> issue is because it keeps the entire array on one page.

I share this feeling, I wrote several times that I don't understand
how this patch solves the issue and I would appreciate if someone
can explain it to me (preferably with evidence).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
