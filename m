From: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Date: Thu, 21 Mar 2013 08:23:48 -0400
Message-ID: <514AFBD4.2050201@linux.vnet.ibm.com>
References: <20130321061838.GA28319@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321061838.GA28319-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Yes, I'd be happy to try the patch.

Got meetings all day...... but will dive in soon.

On 03/21/2013 02:18 AM, Michael S. Tsirkin wrote:
> core/umem.c seems to get the arguments to get_user_pages
> in the reverse order: it sets writeable flag and
> breaks COW for MAP_SHARED if and only if hardware needs to
> write the page.
>
> This breaks memory overcommit for users such as KVM:
> each time we try to register a page to send it to remote, this
> breaks COW.  It seems that for applications that only have
> REMOTE_READ permission, there is no reason to break COW at all.
>
> If the page that is COW has lots of copies, this makes the user process
> quickly exceed the cgroups memory limit.  This makes RDMA mostly useless
> for virtualization, thus the stable tag.
>
> Reported-by: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> Note: compile-tested only, I don't have RDMA hardware at the moment.
> Michael, could you please try this patch (also fixing your
> usespace code not to request write access) and report?
>
> Note2: grep for get_user_pages in infiniband drivers turns up
> lots of users who set write to 1 unconditionally.
> These might be bugs too, should be checked.
>
>   drivers/infiniband/core/umem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a841123..5929598 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -152,7 +152,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   		ret = get_user_pages(current, current->mm, cur_base,
>   				     min_t(unsigned long, npages,
>   					   PAGE_SIZE / sizeof (struct page *)),
> -				     1, !umem->writable, page_list, vma_list);
> +				     !umem->writable, 1, page_list, vma_list);
>
>   		if (ret < 0)
>   			goto out;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
