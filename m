From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/4] RDMA/hns: Add IOMMU enable support in hip08
Date: Thu, 9 Nov 2017 09:26:27 +0800
Message-ID: <5A03AEC3.10109@huawei.com>
References: <1506763741-81429-1-git-send-email-xavier.huwei@huawei.com>
 <1506763741-81429-3-git-send-email-xavier.huwei@huawei.com>
 <20170930161023.GI2965@mtr-leonro.local> <59DF60A3.7080803@huawei.com>
 <5fe5f9b9-2c2b-ab3c-dafa-3e2add051bbb@arm.com> <59F97BBE.5070207@huawei.com>
 <fc7433af-4fa7-6b78-6bec-26941a427002@arm.com> <5A011E49.6060407@huawei.com>
 <20171107154838.GC21466@ziepe.ca> <20171107155805.GA24082@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107155805.GA24082-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, shaobo.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, xavier.huwei-WVlzvzqoTvw@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shaoboxu-WVlzvzqoTvw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/11/7 23:58, Christoph Hellwig wrote:
> On Tue, Nov 07, 2017 at 08:48:38AM -0700, Jason Gunthorpe wrote:
>> Can't you just use vmalloc and dma_map that? Other drivers follow that
>> approach..
> You can't easily due to the flushing requirements.  We used to do that
> in XFS and it led to problems.  You need the page allocator + vmap +
> invalidate_kernel_vmap_range + flush_kernel_vmap_range to get the
> cache flushing right.
>
> .
Hi, Christoph Hellwig
    Thanks for your suggestion.
    Regards
Wei Hu


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
