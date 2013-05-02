From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: decent performance drop for SCSI LLD / SAN initiator when iommu
 is turned on
Date: Thu, 2 May 2013 14:13:15 +0000
Message-ID: <0EE9A1CDC8D6434DB00095CD7DB873462CF9D73E@MTLDAG01.mtl.com>
References: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com>
 <20130502015603.GC26105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130502015603.GC26105-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Thursday, May 02, 2013 04:56
> To: Or Gerlitz
> Cc: Roland Dreier; iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org; Yan Burman; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: decent performance drop for SCSI LLD / SAN initiator when
> iommu is turned on
> 
> On Thu, May 02, 2013 at 02:11:15AM +0300, Or Gerlitz wrote:
> > Hi Roland, IOMMU folks,
> >
> > So we've noted that when configuring the kernel && booting with intel
> > iommu set to on on a physical node (non VM, and without enabling SRIOV
> > by the HW device driver) raw performance of the iSER (iSCSI RDMA) SAN
> > initiator is reduced notably, e.g in the testbed we looked today we
> > had ~260K 1KB random IOPS and 5.5GBs BW for 128KB IOs with iommu
> > turned off for single LUN, and ~150K IOPS and 4GBs BW with iommu
> > turned on. No change on the target node between runs.
> 
> That's why we have iommu=pt.
> See definition of iommu_pass_through in arch/x86/kernel/pci-dma.c.

I tried passing "intel_iommu=on iommu=pt" to 3.8.11 kernel and I still get performance degradation.
I get the same numbers with iommu=pt as without it.

I wanted to send perf output, but currently I seem to have some problem with its output.
Will try to get perf differences next week.

Yan


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
