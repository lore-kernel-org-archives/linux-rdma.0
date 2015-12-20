From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 09/10] IB: remove the struct ib_phys_buf definition
Date: Sun, 20 Dec 2015 18:54:14 +0200
Message-ID: <5676DD36.4020305@mellanox.com>
References: <1450446906-10336-1-git-send-email-hch@lst.de>
 <1450446906-10336-10-git-send-email-hch@lst.de>
 <56765AC2.2010104@mellanox.com> <20151220154137.GA10351@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151220154137.GA10351-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/20/2015 5:41 PM, Christoph Hellwig wrote:

> I can't see a useful explanation for removing an unused structure.  But if you
> really want one and come up with a coherent sentence or two I can add it.

patch title - IB/core: Remove struct ib_phys_buf

change log:

Remove struct ib_phys_buf since YYY

where you need to fill few words for YYY, e.g not used anywhere ever, 
not used after you did
cleanup ZZZ, something that can serve someone reading your patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
