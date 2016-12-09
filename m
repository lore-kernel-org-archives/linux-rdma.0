From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/5] Move dma_ops from archdata into struct device
Date: Fri, 9 Dec 2016 11:46:30 -0800
Message-ID: <cbfac346-3b71-fffb-65f6-3566a00366a4@sandisk.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com>
	<58a325aa-8df7-6a2e-fadb-5d9031d8a1a0@sandisk.com>
	<20161209182230.GC16622@lst.de>
	<1481310814.98151.11.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1481310814.98151.11.camel@infradead.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-arch@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On 12/09/2016 11:13 AM, David Woodhouse wrote:
> On Fri, 2016-12-09 at 19:22 +0100, Christoph Hellwig wrote:
>> We'll need a bit of a wieder audience for this I think..
>>
>> On Wed, Dec 07, 2016 at 05:11:28PM -0800, Bart Van Assche wrote:
>>> Additionally, introduce set_dma_ops(). A later patch will introduce a
>>> call to that function in the RDMA drivers that will be modified to use
>>> dma_noop_ops.
>>
>> This looks good to me, and we had a lot of talk about this for other
>> purposes for a while.
>
> Hm, I'm not convinced we want per-device dma_ops. What we want is per-
> device IOMMU ops, and any dma_ops are just a generic or platform-
> specific (in some cases) wrapper around those. We shouldn't normally
> need per-device DMA ops at all.

Hello David,

Can you recommend an approach for e.g. the qib driver 
(drivers/infiniband/hw/qib)? That driver uses the CPU (PIO) instead of 
DMA to transfer data to a PCIe device. Sorry but I don't see how 
per-device IOMMU ops would allow to avoid that e.g. a cache flush is 
triggered before PIO starts.

Bart.
