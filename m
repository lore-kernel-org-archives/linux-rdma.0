From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: decent performance drop for SCSI LLD / SAN initiator when iommu is
 turned on
Date: Thu, 2 May 2013 02:11:15 +0300
Message-ID: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, IOMMU folks,

So we've noted that when configuring the kernel && booting with intel
iommu set to on on a physical node (non VM, and without enabling SRIOV
by the HW device driver) raw performance of the iSER (iSCSI RDMA) SAN
initiator is reduced notably, e.g in the testbed we looked today we
had ~260K 1KB random IOPS and 5.5GBs BW for 128KB IOs with iommu
turned off for single LUN, and ~150K IOPS and 4GBs BW with iommu
turned on. No change on the target node between runs.

This was done over kernel 3.5.x, I will re-run tomorrow with latest
upstream and send the top perf hits for both cases, but does this
rings some bells? basically it makes sense for some extra latency, but
I didn't expect the IOPS and BW drop to be so notable. Is it possible
that at these rates the IOMMU is so much trashed that it can't keep
the perf we have without it being on?

We're a SCSI LLD which is called through the queuecommand API by the
SCSI midlayer, get a scatter-gather list pointing to set of pages,
issue dma_map_sg on the SG list, and then conduct some registration
with the HCA of this set of DMA addresses which produced a token
(rkey) we send to the target node with the request. The target node
does RDMA using that token, without the CPU of the initiator being
involved (the two HCAs talk) later the target sends respose which
means the transaction is done, after we get the response we undo the
registration at the HCA and do dma_unmap_sg.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
