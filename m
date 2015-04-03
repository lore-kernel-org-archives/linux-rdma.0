From: Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>
Subject: Re: [oss-security] RE: CVE-2014-8159 kernel: infiniband: uverbs:
 unprotected physical memory access
Date: Fri, 3 Apr 2015 14:43:56 +0200
Message-ID: <20150403124356.GA3141@u-blusson>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
 <1427969085.17020.5.camel@opteya.com>
 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
 <1427981431.22575.21.camel@opteya.com> <551D5DC8.6070909@mellanox.com>
 <1427992506.22575.80.camel@opteya.com>
 <AM2PR05MB0929FB71C5A4DE92A7709F92DCF20@AM2PR05MB0929.eurprd05.prod.outlook.com>
 <20150402174401.GA24285@nautica>
 <AM3PR05MB0935F9F1011E30F11C2A08BDDCF10@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM3PR05MB0935F9F1011E30F11C2A08BDDCF10-LOZWmgKjnYgQouBfZGh8ttqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Shachar Raindel wrote on Fri, Apr 03, 2015 at 11:49:13AM +0000:
> > couldn't get it to work - ibv_reg_mr would return EINVAL on an address
> > obtained by mmap.
> 
> Were you mmaping a normal disk file, or was the mmap targeting an MMIO of
> another hardware device? mmap of a normal disk file should work also with
> normal memory registration, assuming you are providing the proper length.

On a proper file.
It was a year or two ago, I actually tried again now and it does seem
to work alright even on older kernels... I wonder what I did wrong back
then!

> mmap of the MMIO area of another hardware device (i.e. interfacing an FPGA,
> NVRAM, or similar things) requires some code changes on both sides. The
> current kernel code in the infiniband side is using get_user_pages, which
> does not support MMIO pages. The proposed PeerDirect patches [1] allows peer
> device to declare ownership of virtual address ranges, and enable such
> registration. However, these patches are have not yet been merged upstream.

Interesting, I don't need this right now but it's good to know.

> > Conceptually as well I'm not sure how it's supposed to work, mmap should
> > only actually issue reads when memory access issues page faults (give or
> > take suitable readahead logic), but I don't think direct memory access
> > from the IB/RDMA adapter would issue such page faults ?
> 
> You are correct. RDMA adapters without ODP support do not issue page faults.
> Instead, during memory registration, the ib_umem code calls get_user_pages,
> which ensures all relevant pages are in memory, and pins them as needed.
> 
> > Likewise on writes, would need the kernel to notice memory has been
> > written and pages are dirty/needs flushing.
> > 
> 
> Similarly, when deregistering a writable memory region, the kernel driver
> marks all pages as dirty before unpinning them. You can see the code doing
> this in [2].

Ok this makes sense, thanks for clearing it up.

> Liran Liss gave a presentation about ODP at OFA [3]. The technology is
> available for ConnectIB devices using the most recent firmware and kernel
> versions above 3.19.

I don't have any recent kernel around, but I'll give it a shot next
week.
(I'm working on a userspace file server, nfs-ganesha, so being able to
mmap a file and use it directly for I/O is very promising for me!)


> [1] http://www.spinics.net/lists/linux-rdma/msg21770.html
> [2] http://lxr.free-electrons.com/source/drivers/infiniband/core/umem.c#L62
> [3] https://www.openfabrics.org/images/Workshops_2014/DevWorkshop/presos/Tuesday/pdf/09.30_2014_OFA_Workshop_ODP_update_final.pdf and https://www.youtube.com/watch?v=KbrlsXQbHCw


Thanks for the detailed reply, I'll dig a bit further and come back
straight to the list if need to.

-- 
Dominique Martinet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
