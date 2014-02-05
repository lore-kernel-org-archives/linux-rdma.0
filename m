From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: Refactor umem to use linear SG table
Date: Wed, 5 Feb 2014 18:57:53 +0000
Message-ID: <03AE0136-67D9-4259-97FA-0F5727E40625@cisco.com>
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
Content-ID: <C6E63E3C0F600546B509CEC816278850-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Feb 2, 2014, at 11:30 PM, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

Follow up.
> You can probably offer a patch to ib_umem_get, passing a flag to it identifying if
> it should also do the DMA mapping, and use the same code base as the rest of the
> IB drivers.
The usnic memory management stuff is entirely freed of ib objects.  If we were to move to using ib_umem_get, the code would get corrupted with ib objects.  There are also other subtle minor differences.  The overlap with ib_umem_get is minor, so I am not going to port this code over to use ib_umem_get.
> 
> A better solution would be to fix Intel's IOMMU code such that it works properly if
> the page is mapped using both dma_map_sg and the IOMMU API.
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
I will submit a patch for this.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
