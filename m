From: Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: decent performance drop for SCSI LLD / SAN initiator when iommu
 is turned on
Date: Mon, 06 May 2013 15:35:58 -0700
Message-ID: <5188304E.9050603@intel.com>
References: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com> <20130502015603.GC26105@redhat.com> <CAJZOPZLWgXNCEpZjzuizVGPEVPg1G+cHh373ZCoumMx9eAabvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLWgXNCEpZjzuizVGPEVPg1G+cHh373ZCoumMx9eAabvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Asias He <asias-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/2013 02:39 PM, Or Gerlitz wrote:
> On Thu, May 2, 2013 at 4:56 AM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Thu, May 02, 2013 at 02:11:15AM +0300, Or Gerlitz wrote:
>>> So we've noted that when configuring the kernel && booting with intel
>>> iommu set to on on a physical node (non VM, and without enabling SRIOV
>>> by the HW device driver) raw performance of the iSER (iSCSI RDMA) SAN
>>> initiator is reduced notably, e.g in the testbed we looked today we
>>> had ~260K 1KB random IOPS and 5.5GBs BW for 128KB IOs with iommu
>>> turned off for single LUN, and ~150K IOPS and 4GBs BW with iommu
>>> turned on. No change on the target node between runs.
>> That's why we have iommu=pt.
>> See definition of iommu_pass_through in arch/x86/kernel/pci-dma.c.
>
>
> Hi Michael (hope you feel better),
>
> We did some runs with the pt approach you suggested and still didn't
> get the promised gain -- in parallel we came across this 2012 commit
> f800326dc "ixgbe: Replace standard receive path with a page based
> receive" where they say "[...] we are able to see a considerable
> performance gain when an IOMMU is enabled because we are no longer
> unmapping every buffer on receive [...] instead we can simply call
> sync_single_range [...]"  looking on the commit you can see that they
> allocate a page/skb dma_map it initially and later of the life cycle
> of that buffer use dma_sync_for_device/cpu and avoid dma_map/unmap on
> the fast path.
>
> Well few questions which I'd love to hear people's opinion -- 1st this
> approach seems cool for network device RX path, but what about the TX
> path, any idea how to avoid dma_map for it? or why on the TX path
> calling dma_map/unmap for every buffer doesn't involve a notable perf
> hit? 2nd I don't see how to apply the method on block device since
> these devices don't allocate buffers, but rather get a scatter-gather
> list of pages from upper layers, issue dma_map_sg on them and submit
> the IO, later when done call dma_unmap_sg
>
> Or.

The Tx path ends up taking a performance hit if IOMMU is enabled.  It
just isn't as severe due to things like TSO.

One way to work around the performance penalty is to allocate bounce
buffers and just leave them static mapped.  Then you can simply memcpy
the data to the buffers and avoid the locking overhead of
allocating/freeing IOMMU resources.  It consumes more memory but works
around the IOMMU limitations.

Thanks,

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
