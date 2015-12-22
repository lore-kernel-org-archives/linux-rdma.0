From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 14:59:27 +0100
Message-ID: <20151222135927.GA26311@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <1448214409-7729-11-git-send-email-hch@lst.de> <56791542.6020604@dev.mellanox.co.il> <20151222131326.GA25267@lst.de> <56795514.9090704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56795514.9090704-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 22, 2015 at 03:50:12PM +0200, Sagi Grimberg wrote:
> This is why I said that the problem here is not the ULPs. But if a new
> HW comes along with distinction between rkeys and lkeys it will have a
> problem. For example a HW allocates two different keys, rkey and lkey.
> And, it chooses to fail SEND from a rkey, or incoming READ/WRITE to a
> lkey. How can such a device be supported with an API that allows a
> single key per MR?

The ULP decides if this MR is going to be used as a lkey or rkey
by passing IB_REG_LKEY or IB_REG_RKEY.  The HCA driver will then
fill mr->key by the lkey or rkey based on that and everything will
work fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
