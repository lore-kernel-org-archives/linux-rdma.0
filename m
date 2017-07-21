From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC net-next 05/10] net/smc: register RMB-related memory region
Date: Fri, 21 Jul 2017 09:47:36 +0200
Message-ID: <287e9962-0a05-df51-40ec-e4f46fc2cade@linux.vnet.ibm.com>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
 <20170720120946.67234-6-ubraun@linux.vnet.ibm.com>
 <8df0459f-b2be-53f1-a7c3-388ca22a128c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8df0459f-b2be-53f1-a7c3-388ca22a128c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 07/20/2017 05:17 PM, Sagi Grimberg wrote:
>> A memory region created for a new RMB must be registered explicitly,
>> before the peer can make use of it for remote DMA transfer.
> 
> OK, Now I understand the sgl construction in the previous patch.
> 
> We got rid of the synchronous memory registration API in the kernel
> in the absence of users, but now with smc we might want to restore
> it because looking at the patchset, the fast memory registration
> scheme is obviously not a good fit.
> 
> For the simple smc use case the API should be as simple as:
> 
> ib_reg_contig_mr(struct ib_pd *pd, void *addr, size_t length);
> 
> Do you have a use-case for scattered buffers memory registration?
> 

>From my smc perspective I would like to finally allocate the RMB memory as 
scattered pages mapped to contiguous DMA-memory. When creating a new connection
the smc protocol exchanges some information, among them the dma-address to
enable the peer for RDMA WRITEs. According to the smc protocol just one dma-address
can be exchanged; thus contiguous DMA-memory describable by one address only is
required here.
I have prepared already such an smc patch, and it worked for s390, but on my
x-system the scattered pages mapped to scattered DMA-memory after calling
ib_dma_map_sg() and ib_map_mr_sg(). Have I missed something? Is there a way
to explicitly ask for mapping to contiguous memory? 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
