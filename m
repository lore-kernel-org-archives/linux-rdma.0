From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Thu, 29 Sep 2016 16:26:52 -0500
Message-ID: <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com> <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-9-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For a long time now endian.h has defined sane fixed with conversion
> macros, so lets just use them instead of rolling our own.
> 
> Also, htonll is defined in this source tree under infiniband/arch.h,
> so all users of that macro can just use the header.
> 
> Someday we should also get rid of all the endless wrappers..
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/linux/osd.h                    |  8 +-------
>  libcxgb3/src/cxio_wr.h               | 10 +++-------
>  libcxgb4/src/t4.h                    | 11 ++++-------
>  libi40iw/src/i40iw_umain.h           | 18 ++----------------
>  libibumad/src/sysfs.c                |  8 +-------
>  libibverbs/include/infiniband/arch.h | 15 ++++++---------
>  libnes/src/nes_umain.h               | 17 ++---------------
>  libocrdma/src/ocrdma_verbs.c         | 32 ++++----------------------------
>  librdmacm/examples/common.h          | 11 +++--------
>  librdmacm/src/cma.h                  |  9 +--------
>  srp_daemon/srp_daemon/srp_daemon.h   | 17 +----------------
>  11 files changed, 28 insertions(+), 128 deletions(-)
> 

<snip>

> diff --git a/libcxgb3/src/cxio_wr.h b/libcxgb3/src/cxio_wr.h
> index ece06bd0568c..e24c7fed7d76 100644
> --- a/libcxgb3/src/cxio_wr.h
> +++ b/libcxgb3/src/cxio_wr.h
> @@ -50,13 +50,9 @@
>  #define Q_COUNT(rptr,wptr) ((wptr)-(rptr))
>  #define Q_PTR2IDX(ptr,size_log2) (ptr & ((1UL<<size_log2)-1))
> 
> -#if __BYTE_ORDER == __LITTLE_ENDIAN
> -#  define cpu_to_pci32(val) ((val))
> -#elif __BYTE_ORDER == __BIG_ENDIAN
> -#  define cpu_to_pci32(val) (__bswap_32((val)))
> -#else
> -#  error __BYTE_ORDER not defined
> -#endif
> +/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
> +   probably wrong */
> +#define cpu_to_pci32(val) htole32(val)
> 

If this was wrong, then nothing would work.  So I think you should remove the
comment.

>  #define RING_DOORBELL(doorbell, QPID) { \
>  	*doorbell = cpu_to_pci32(QPID); \

See RING_DOORBELL() is used in the .c files

> diff --git a/libcxgb4/src/t4.h b/libcxgb4/src/t4.h
> index e8c5cf66cb14..e519cc4087e6 100644
> --- a/libcxgb4/src/t4.h
> +++ b/libcxgb4/src/t4.h
> @@ -62,13 +62,10 @@
>  #define unlikely
>  #define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> -#if __BYTE_ORDER == __LITTLE_ENDIAN
> -#  define cpu_to_pci32(val) ((val))
> -#elif __BYTE_ORDER == __BIG_ENDIAN
> -#  define cpu_to_pci32(val) (__bswap_32((val)))
> -#else
> -#  error __BYTE_ORDER not defined
> -#endif
> +
> +/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
> +   probably wrong */
> +#define cpu_to_pci32(val) htole32(val)
> 

Ditto.

>  #define writel(v, a) do { *((volatile u32 *)(a)) = cpu_to_pci32(v); } while
(0)
>

Ditto.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
