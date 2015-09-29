From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 01/24] IB/core: Introduce new fast registration API
Date: Mon, 28 Sep 2015 22:59:07 -0700
Message-ID: <20150929055907.GA29758@infradead.org>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-2-git-send-email-sagig@mellanox.com>
 <5601C65F.8060403@sandisk.com>
 <5603A841.70509@dev.mellanox.co.il>
 <5609A9D0.8030607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5609A9D0.8030607-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 01:57:52PM -0700, Bart Van Assche wrote:
> >Actually I think it doesn't since it is only relevant for the else
> >statement where we are passing the page_size boundary.
> 
> Hello Sagi,
> 
> Suppose that the following sg-list is passed to this function as { offset,
> length } pairs and that this list has not been coalesced by the DMA mapping
> code: [ { 0, page_size / 4 }, { page_size / 4, page_size / 4 }, { 2 *
> page_size / 4, page_size / 2 } ]. I think the algorithm in patch 01/24 will
> map the above sample sg-list onto two pages. Shouldn't that sg-list be
> mapped onto one page instead ?

Shouldn't higher layers take care of this?  Trying to implement the same
coalescing algorithm at various layers isn't very optimal, although we
need to decide and document which one is responsible.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
