From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 11:01:56 -0700
Message-ID: <20151110180156.GE12667@obsidianresearch.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447152255-28231-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 12:44:13PM +0200, Sagi Grimberg wrote:
> Different devices may require different access permissions
> for rdma reads e.g. for Infiniband devices, local write access
> suffices while iWARP devices require remote write permissions as
> well.
> 
> This situation generates extra logic for ULPs that need to be aware
> of the underlying device to determine rdma read access. Instead,
> add a device attribute for ULPs to use without being aware of the
> underlying device.
> 
> Also, set rdma_read_access_flags in the relevant device drivers:
> mlx4, mlx5, qib, ocrdma, nes: IB_ACCESS_LOCAL_WRITE
> cxgb3, cxgb4, hfi: IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE

IB devices *should* be using a local_dma_lkey instead of a memory
registration for the RDMA READ target memory.

iWarp devices *must* use a memory registration instead.

Having an API that encourages ULPs to do useless MR work on IB does
not seem like a great idea, but if the ULP needs to create a MR anyhow
(SG limits or whatever), then it makes some sense.. But not in absence
of the 'need a mr' general check..

Finally, please don't add rdma_read_access_flags - we went to a lot of
trouble to add the cap stuff, and this stuff is already covered by it.
No need to change every driver.

I'd suggest something like

  unsigned int rdma_cap_rdma_read_mr_flags(const struct ib_pd *pd)
  {
     if (rdma_protocol_iwarp(pd->device, rdma_start_port(pd->device)))
           return IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
     return IB_ACCESS_LOCAL_WRITE;
  }

  bool rdma_cap_need_rdma_read_mr(const struct ib_pd *pd) ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
