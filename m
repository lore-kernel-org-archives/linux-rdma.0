From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 11:17:54 +0200
Message-ID: <56791542.6020604@dev.mellanox.co.il>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-11-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

> While IB supports the notion of returning separate local and remote keys
> from a memory registration, the iWarp spec doesn't and neither does any
> of our in-tree HCA drivers [1] nor consumers.  Consolidate the in-kernel
> API to provide only a single key and make everyones life easier.

What makes me worried here is that the IB/RoCE specification really
defines different keys for local and remote access. I'm less concerned
about our consumers but more about our providers. We keep seeing new
providers come along and its not impossible that a specific HW will
*rely* on this distinction. In such a case we'd need to revert this
patch altogether in that very moment.

I think we're better off working on proper abstractions to help ULPs
get it right (and simple!), without risking future devices support.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
