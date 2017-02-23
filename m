From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 14/14] Remove the old barrier macros
Date: Thu, 23 Feb 2017 13:33:33 +0000
Message-ID: <SN1PR07MB22070A48ACD50848267A5AD8F8530@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-15-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-15-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  /* Ensure that the device's view of memory matches the CPU's view of mem=
ory.
> @@ -163,7 +78,25 @@
>     memory types or non-temporal stores are required to use SFENCE in the=
ir own
>     code prior to calling verbs to start a DMA.
>  */
> -#define udma_to_device_barrier() wmb()
> +#if defined(__i386__)
> +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> +#elif defined(__x86_64__)
> +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> +#elif defined(__PPC64__)
> +#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
> +#elif defined(__PPC__)
> +#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
> +#elif defined(__ia64__)
> +#define udma_to_device_barrier() asm volatile("mf" ::: "memory")
> +#elif defined(__sparc_v9__)
> +#define udma_to_device_barrier() asm volatile("membar #StoreStore" ::: "=
memory")
> +#elif defined(__aarch64__)
> +#define wmb() asm volatile("dsb st" ::: "memory");
> +#elif defined(__sparc__) || defined(__s390x__)
> +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> +#else
> +#error No architecture specific memory barrier defines found!
> +#endif

In the kernel wmb() translates, for x86_64, into 'sfence'.
In user-space, however wmb, and now its "successor", udma_to_device_barrier=
,
translate to volatile("" ::: "memory")

What is the reasoning behind this?
Why aren't the kernel and user space implementations the same?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
