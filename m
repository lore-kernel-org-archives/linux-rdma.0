From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC 0/5] Hardware tag matching
Date: Mon, 12 Jun 2017 04:05:07 -0700
Message-ID: <20170612110507.GA14990@infradead.org>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <20170612074055.GA24879@infradead.org>
 <628acd1f-7502-be87-df2e-48475f34fdd8@mellanox.com>
 <20170612104600.GA2576@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612104600.GA2576-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 01:46:00PM +0300, Leon Romanovsky wrote:
> On Mon, Jun 12, 2017 at 12:41:12PM +0300, Artemy Kovalyov wrote:
> > On 12/06/2017 10:40, Christoph Hellwig wrote:
> > > Artem, what firmware version / what specific hardware do I need for
> > > this?  I've been working on prototyping a simpler subset of this
> > > (1:1 tag matching) for use in NVMe or NFS over RDMA, so I'd like to
> > > play around with your code to see if it matches my use case as well.
> >
> > Christoph, here is Contect-X5 firmware with Tag matching support:
> >  http://www.mellanox.com/page/firmware_table_ConnectX5IB
> 
> Latest available FW for ConnectX-5 supports Tag Matching.

Is there support for ConnectX-4 as well?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
