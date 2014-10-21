From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory Registration
 Feature
Date: Tue, 21 Oct 2014 12:32:50 +0300
Message-ID: <54462842.8080701@dev.mellanox.co.il>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-3-git-send-email-sagig@mellanox.com> <543CB79B.6050400@acm.org> <5444122C.6070804@dev.mellanox.co.il> <5444BDDC.1060507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5444BDDC.1060507-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/20/2014 10:46 AM, Bart Van Assche wrote:
> On 10/19/14 21:34, Sagi Grimberg wrote:
>> On 10/14/2014 8:41 AM, Bart Van Assche wrote:
>>>  > +struct ib_indir_reg_list *
>>>  > +mlx5_ib_alloc_indir_reg_list(struct ib_device *device,
>>>  > +                 unsigned int max_indir_list_len)
>>>
>>> There are three k[zc]alloc() calls in this function. Can these be
>>> combined into one without increasing the chance too much that this will
>>> increase the order of the allocation ?
>>
>> Well, I have 3 allocations:
>> 1. mlx5_indir_reg_list container
>> 2. sg_list: buffer of sg elements for the user to pass
>> 3. mapped_ilist: buffer for HW representation of sg elements.
>>
>> mapped_ilist buffer has some constraints on it (see below) so I can't
>> combine it with the other two. I assume I can rearrange the structure to
>> combine the fist 2 allocations together, but it can trigger a higher
>> order allocation (unless I use vzalloc, but I'm not sure what is the
>> benefit here...).
>
> Since vmalloc() is about 1000 times slower than kmalloc() I think we
> should try to avoid vmalloc() and its variants. Combining multiple
> kmalloc() calls into a single kmalloc() call helps performance and
> reduces the number of error paths. But since the time needed for a
> single kmalloc() call is only a few microseconds combining multiple
> kmalloc() calls reduces performance if combining kmalloc() calls
> increases the allocation order from one page to multiple pages.

Right, so I think keeping these separated is OK agreed?

>
>>>  > +    dsize = sizeof(*mirl->klms) * max_indir_list_len;
>>>  > +    mirl->mapped_ilist = kzalloc(dsize + MLX5_UMR_ALIGN - 1,
>>>  > +                      GFP_KERNEL);
>>>
>>> The value of the constant MLX5_UMR_ALIGN is 2048. Does that mean this
>>> code will always allocate 2 KB more than needed ? Is this really the
>>> minimum alignment required for this data structure ? How likely is it
>>> that this code will trigger a higher order allocation ?
>>
>> Well, here I need a variable size physically contiguous allocation with
>> a start address aligned to 2K (HW requirement). So yes, with this code
>> given the user allocate more than PAGE_SIZE-2K ib_sges, a higher order
>> allocation will be triggered.
>>
>> I allocate 2K more to ensure I can align to 2K, then I set mirl->klms to
>> point at the aligned address. Any idea on how can I do this without
>> allocating 2K more?
>
> Specifying a minimum memory alignment requirement is possible with
> kmem_cache_create(). However, kmem_caches only support allocation of
> fixed size objects.
>
> In mm/slab_common.c one can see that for SLAB and SLUB allocations of >=
> 256 bytes are guaranteed to be aligned on a boundary equal to the
> smallest power of two that is larger than or equal to the allocation
> size. Unfortunately this does not hold for the SLOB allocator. So I
> think the only change that can be made in this code without complicating
> it too much is changing the "MLX5_UMR_ALIGN - 1" into
> "max(MLX5_UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0)".

I can give that a go...

Thanks!

P.S.
Since you didn't give any comments on the API itself should I conclude
that you find it clear and you agree with it?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
