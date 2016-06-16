From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Thu, 16 Jun 2016 17:58:29 -0400
Message-ID: <652EBA09-2978-414C-8606-38A96C63365A@oracle.com>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net> <20160615031525.14794.69066.stgit@manet.1015granger.net> <20160615042849.GR5408@leon.nu> <68F7CD80-0092-4B55-9FAD-4C54D284BCA3@oracle.com> <20160616143518.GX5408@leon.nu> <576315C9.30002@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <576315C9.30002-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jun 16, 2016, at 5:10 PM, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> 
>>>> On Jun 15, 2016, at 12:28 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> 
>>>> On Tue, Jun 14, 2016 at 11:15:25PM -0400, Chuck Lever wrote:
>>>>> From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>>>>> 
>>>>> kmalloc doesn't guarantee the returned memory is all on one page.
>>>> 
>>>> IMHO, the patch posted by Christoph at that thread is best way to go,
>>>> because you changed streaming DMA mappings to be coherent DMA mappings [1].
>>>> 
>>>> "The kernel developers recommend the use of streaming mappings over
>>>> coherent mappings whenever possible" [1].
>>>> 
>>>> [1] http://www.makelinux.net/ldd3/chp-15-sect-4
>>> 
>>> Hi Leon-
>>> 
>>> I'll happily drop this patch from my 4.8 series as soon
>>> as an official mlx4/mlx5 fix is merged.
>>> 
>>> Meanwhile, I notice some unexplained instability (driver
>>> resets, list corruption, and so on) when I test NFS/RDMA
>>> without this patch included. So it is attached to the
>>> series for anyone with mlx4 who wants to pull my topic
>>> branch and try it out.
>> 
>> hi Chuck,
>> 
>> We plan to send attached patch during our second round of fixes for
>> mlx4/mlx5 and would be grateful to you if you could provide your
>> Tested-by tag before.

Fwiw, Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


> First of all, IIRC the patch author was Christoph wasn't he.
> 
> Plus, you do realize that this patch makes the pages allocation
> in granularity of pages. In systems with a large page size this
> is completely redundant, it might even be harmful as the storage
> ULPs need lots of MRs.

I agree that the official fix should take a conservative
approach to allocating this resource; there will be lots
of MRs in an active system. This fix doesn't seem too
careful.


> Also, I don't see how that solves the issue, I'm not sure I even
> understand the issue. Do you? Were you able to reproduce it?

The issue is that dma_map_single() does not seem to DMA map
portions of a memory region that are past the end of the first
page of that region. Maybe that's a bug?

This patch works around that behavior by guaranteeing that

a) the memory region starts at the beginning of a page, and
b) the memory region is never larger than a page

This patch is not sufficient to repair mlx5, because b)
cannot be satisfied in that case; the array of __be64's can
be larger than 512 entries.


> IFF the pages buffer end not being aligned to a cacheline is problematic
> then why not extent it to end in a cacheline? Why in the next full page?

I think the patch description justifies the choice of
solution, but does not describe the original issue at
all. The original issue had nothing to do with cacheline
alignment.

Lastly, this patch should remove the definition of
MLX4_MR_PAGES_ALIGN.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
