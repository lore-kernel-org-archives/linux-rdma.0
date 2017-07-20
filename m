From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC net-next 05/10] net/smc: register RMB-related memory region
Date: Thu, 20 Jul 2017 18:17:48 +0300
Message-ID: <8df0459f-b2be-53f1-a7c3-388ca22a128c@grimberg.me>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
 <20170720120946.67234-6-ubraun@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720120946.67234-6-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> A memory region created for a new RMB must be registered explicitly,
> before the peer can make use of it for remote DMA transfer.

OK, Now I understand the sgl construction in the previous patch.

We got rid of the synchronous memory registration API in the kernel
in the absence of users, but now with smc we might want to restore
it because looking at the patchset, the fast memory registration
scheme is obviously not a good fit.

For the simple smc use case the API should be as simple as:

ib_reg_contig_mr(struct ib_pd *pd, void *addr, size_t length);

Do you have a use-case for scattered buffers memory registration?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
