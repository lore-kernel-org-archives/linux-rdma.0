From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_reg_mr call failed
Date: Sun, 9 Jun 2013 10:33:38 +0300
Message-ID: <51B42FD2.2030507@mellanox.com>
References: <B78BFEBC60BCD84AABFE4C6AE4239F303631433D@BY2PRD0412MB622.namprd04.prod.outlook.com> <51A20FC0.8070906@mellanox.com> <2AB4BFEB-D0E5-47E5-9E99-024BA7BB16AA@grassvalley.com> <CAJZOPZ+ESd4bq2dG4yYJG4qumaBWfd+4t_bTn4cHmFgCg8AYgw@mail.gmail.com> <B78BFEBC60BCD84AABFE4C6AE4239F303633B73E@BY2PRD0412MB622.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B78BFEBC60BCD84AABFE4C6AE4239F303633B73E-PabevnM9DETuy2SDsQ9Xi/nBZW37Ciw+nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liu Ginhann <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/06/2013 19:42, Liu Ginhann wrote:
>> does this works if you use get_free_pages in the kernel instead of
>> kmem_cache?
>>
> I tried get_free_pages, kmalloc, kmem_cache_alloc. None of them work, it failed with the same error - EFAULT bad pointer.
>
> After code walk through, I believe it failed in ib_umem_get routine get_user_pages call. Below is the code snippet and it seems like the address point to is expect to be user space memory. If the comment is true, then that may be able to explain why ibv_reg_mr is not happy with remap address from kernel allocated memory but perfectly fine with malloc from user space.

Guys,  do you agree, will ib_umem_get always fail when provided memory 
which wasn't allocated @ user-space? why?

Or.

>
> If this is true. Do you think there is another way to accomplish this? It got to have some way to do this.
>
> You help is appreciated.
>
> Hank
>
> /**
>   * ib_umem_get - Pin and DMA map userspace memory.
>   * @context: userspace context to pin memory for
>   * @addr: userspace virtual address to start at
>   * @size: length of region to pin
>   * @access: IB_ACCESS_xxx flags for memory being pinned
>   * @dmasync: flush in-flight DMA when the memory region is written
>   */
> struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> 			    size_t size, int access, int dmasync)
> {
> 	ret = 0;
> 	while (npages) {
> 		ret = get_user_pages(current, current->mm, cur_base,
> 				     min_t(unsigned long, npages,
> 					   PAGE_SIZE / sizeof (struct page *)),
> 				     1, !umem->writable, page_list, vma_list);
>
> 		if (ret < 0)
> 			goto out;
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
