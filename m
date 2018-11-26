From: Anshuman Khandual <anshuman.khandual-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] mm: Replace all open encodings for NUMA_NO_NODE
Date: Mon, 26 Nov 2018 12:15:04 +0530
Message-ID: <5228bcdb-b140-a86a-6c9c-488f1a723353@arm.com>
References: <1542966856-12619-1-git-send-email-anshuman.khandual@arm.com>
	<20181124140554.GG3175@vkoul-mobl.Dlink>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20181124140554.GG3175-bQVUxfxUtC3xKnQ2JfU4AA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Vinod Koul <vkoul-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, intel-wired-lan-qjLDD68F18P21nG7glBr7A@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 11/24/2018 07:35 PM, Vinod Koul wrote:
> On 23-11-18, 15:24, Anshuman Khandual wrote:
> 
>> --- a/drivers/dma/dmaengine.c
>> +++ b/drivers/dma/dmaengine.c
>> @@ -386,7 +386,8 @@ EXPORT_SYMBOL(dma_issue_pending_all);
>>  static bool dma_chan_is_local(struct dma_chan *chan, int cpu)
>>  {
>>  	int node = dev_to_node(chan->device->dev);
>> -	return node == -1 || cpumask_test_cpu(cpu, cpumask_of_node(node));
>> +	return node == NUMA_NO_NODE ||
>> +		cpumask_test_cpu(cpu, cpumask_of_node(node));
>>  }
> 
> I do not see dev_to_node being updated first, that returns -1 so I would
> prefer to check for -1 unless it return NUMA_NO_NODE

Sure will update dev_to_node() to return NUMA_NO_NODE as well.
