From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/2]: Powerpc: Fix EHCA driver on relocatable kernel
Date: Mon, 20 Sep 2010 16:41:37 +0200
Message-ID: <20100920164137.2c86faef@alex-laptop>
References: <20100820040809.GS16505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100820040809.GS16505-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Hoang-Nam Nguyen <HNGUYEN-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Aug 2010 23:08:09 -0500
Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:

> Some modules (like eHCA) want to map all of kernel memory, for this to
> work with a relocated kernel, we need to export kernstart_addr so
> modules can use PHYSICAL_START and memstart_addr so they could use
> MEMORY_START.  Note that the 32bit code already exports these symbols.
> 
> Signed-off-By: Sonny Rao <sonnyrao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Acked-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> Index: common/arch/powerpc/mm/init_64.c
> ===================================================================
> --- common.orig/arch/powerpc/mm/init_64.c	2010-08-16 02:38:33.000000000 -0500
> +++ common/arch/powerpc/mm/init_64.c	2010-08-16 02:39:25.000000000 -0500
> @@ -79,7 +79,9 @@
>  #endif /* CONFIG_PPC_STD_MMU_64 */
> 
>  phys_addr_t memstart_addr = ~0;
> +EXPORT_SYMBOL(memstart_addr);
>  phys_addr_t kernstart_addr;
> +EXPORT_SYMBOL(kernstart_addr);
> 
>  void free_initmem(void)
>  {
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
