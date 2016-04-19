From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Tue, 19 Apr 2016 20:27:15 +0200
Message-ID: <20160419182715.GB989@lst.de>
References: <1461010463-6603-1-git-send-email-hch@lst.de> <1461010463-6603-12-git-send-email-hch@lst.de> <57163E99.8090301@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57163E99.8090301-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 05:20:09PM +0300, Sagi Grimberg wrote:
> In isert if the we have a single sg entry, we use the local_dma_lkey
> just so we can skip a registration (also for protection sg), perhaps
> rdma_rw_init_one_mr can do this optimization too?

rdma_rw_init_one_mr can't bl=D1=96ndly do it as we can't use the local =
lkey
for iWARP RDMA READs.  But I could add it in the caller, although
that increases the testing matrix once again.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
