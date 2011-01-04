From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv10 1/4] libibverbs: Add link layer field to ibv_port_attr
Date: Tue, 4 Jan 2011 09:54:35 +0200
Message-ID: <4D22D23B.9070504@Voltaire.com>
References: <20100826141930.GN8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141930.GN8795@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> This field can have one of the values - IBV_LINK_LAYER_UNSPECIFIED,
> IBV_LINK_LAYER_INFINIBAND, IBV_LINK_LAYER_ETHERNET. It can be used by
> applications to know the link layer used by the port, which can be either
> Infiniband or Ethernet. The addition of the new field does not change the size
> of struct ibv_port_attr due to alignment of the preceding field [...]
> Solution suggested by:
>                Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>                Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Roland,

Are you planning to look into completing the IBoE support for user space any time soon? with v10 of the patch Eli posted four patches to libibverbs and two patch to libmlx4

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
