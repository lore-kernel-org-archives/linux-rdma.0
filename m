From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 18:58:14 +0200
Message-ID: <56798126.9000003@dev.mellanox.co.il>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-11-git-send-email-hch@lst.de>
 <56791542.6020604@dev.mellanox.co.il> <20151222131326.GA25267@lst.de>
 <56795514.9090704@dev.mellanox.co.il> <20151222135927.GA26311@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151222135927.GA26311-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> The ULP decides if this MR is going to be used as a lkey or rkey
> by passing IB_REG_LKEY or IB_REG_RKEY.  The HCA driver will then
> fill mr->key by the lkey or rkey based on that and everything will
> work fine.

But the ULP *can* register a memory buffer with local and remote
access permissions. One example is ImmediateData or a FirstBurst
implementation where an initiator sends the first burst of data and
the target reads the rest of it. My concern is that a device that
uses different keys would not be able to support that (or we make
the ULP perform two registrations).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
