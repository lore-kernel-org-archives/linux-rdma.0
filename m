From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Thu, 26 May 2016 15:10:37 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605261508370.8857@east.gentwo.org>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com> <57238F8C.70505@sandisk.com> <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com> <57277B63.8030506@sandisk.com> <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com> <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com>
 <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il> <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aaa67d51-663a-0aba-fc54-a5ab5d947a55-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 May 2016, Bart Van Assche wrote:

> On 05/26/2016 09:24 AM, Yishai Hadas wrote:
> > On 5/25/2016 6:58 PM, Chuck Lever wrote:
> > > When debugging is disabled, kzalloc returns page-aligned
> > > addresses:
> >
> > Is it defined some where that regular kzalloc/kmalloc guaranties to
> > return a page-aligned address as you see in your testing ? if so the
> > debug mode should behave the same. Otherwise we can consider using any
> > flag allocation that can force that if such exists.
> > Let's get other people's input here.
>
> My understanding is that the fact that k[mz]alloc() returns a page-aligned
> buffer if the allocation size is > PAGE_SIZE / 2 is a side effect of the
> implementation and not something callers of that function should rely on. I
> think the only assumption k[mz]alloc() callers should rely on is that the
> allocated memory respects ARCH_KMALLOC_MINALIGN.

The alignment of slab objects is specified at slab creation with
kmem_cache_create(). For kmalloc these are aligned to cache line
boundaries unless the cache object size is less than that.

Allocators may happen to align objects arbitrary in the absense of a
alignment specfication. SLUB happens to align objects of multiple page
size to page boundaries. But that only works if no extra storage is
required (like f.e. for debugging features). It cannot be relied upon.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
