From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 0/5] iSER support for iWARP
Date: Tue, 30 Jun 2015 12:33:28 +0300
Message-ID: <55926268.5060705@dev.mellanox.co.il>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150629213332.4188.87551.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/30/2015 12:36 AM, Steve Wise wrote:
> The following series implements support for iWARP transports in the iSER
> initiator and target.  This is based on Doug's k.o/for-4.2 branch.
>
> I've tested this on cxgb4 and mlx4 hardware.
>
> Changes since V1:
>
> Introduce and use transport-independent RDMA core services for allocating
> DMA MRs and computing fast register access flags.
>
> Correctly set the device max_sge_rd capability in several rdma device
> drivers.
>
> isert: use device capability max_sge_rd for the read sge depth.
>
> isert: change max_sge to max_write_sge in struct isert_conn.
>

Steve,

iser-target related code is usually posted/reviewed on the target-devel
mailing list and merged via target-pending tree.

Please CC target-devel in future patches that involve iser-target.

Thanks,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
