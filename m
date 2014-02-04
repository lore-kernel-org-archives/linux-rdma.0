From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: Refactor umem to use linear SG table
Date: Tue, 4 Feb 2014 01:30:29 +0000
Message-ID: <CFF1BD75-565E-4A29-A643-0AD704BAD864@cisco.com>
References: <1390909215-5331-1-git-send-email-ogerlitz@mellanox.com>
 <52E7AA22.8020700@mellanox.com>
 <1F4FC384-349B-4F37-B06E-214A0B8570DE@cisco.com>
 <6B2A6E60C06CCC42AE31809BF572352B8CF3AC3B@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B8CF3AC3B-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Content-Language: en-US
Content-ID: <7BA49EADE308EF4CB58B9A659A612C98-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Feb 2, 2014, at 11:30 PM, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
Hi Scachar,

> Can you provide some additional detail regarding the confusion - what causes it?
> Is the issue with the same page being mapped more than once in general?
> Does the double mapping need to address the same device?
> 
> You can probably offer a patch to ib_umem_get, passing a flag to it identifying if
> it should also do the DMA mapping, and use the same code base as the rest of the
> IB drivers.
> 
> A better solution would be to fix Intel's IOMMU code such that it works properly if
> the page is mapped using both dma_map_sg and the IOMMU API.
There is no reason, whatsoever, to call dma_map_sg if iommu_map has already been called on a page.  The IOMMU API is the superset of the dma_map_sg API's.  I didn't explore why cache coherency stopped working after we behaved badly and called both APIs.
I did think about passing a flag to ib_umem_get, but  the call to dma_map_sg was deeply nested within two loops, hence it wasn't clean.  But with the port to the sg table, those loops have disappeared and that solution is feasible now.
> 
> 
>> 
>> Any particular reason that the code in usNIC that walks the chunk sg's isn't
>> ported to the linear SG table?
> 
> As your code didn't use the API which we changed, we preferred avoiding changing
> it, to avoid introducing issues into the code, especially when we don't have the
> needed hardware to test your code on.
> 
> You are more than welcome to implement a similar change in your code, or port
> your code to use the ib_umem_get API.
Ack.   --
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
