From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Wed, 5 Aug 2015 22:40:08 -0600
Message-ID: <20150806044008.GB14153@obsidianresearch.com>
References: <20150804143447.GA22172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150804143447.GA22172-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 07:34:47AM -0700, Christoph Hellwig wrote:
> Hi all,
> 
> please take a look at my RFC patch here:
> 
> 	http://git.infradead.org/users/hch/scsi.git/commitdiff/751774250b71da83a26ba8584cff70f5e7bb7b1e
> 
> the commit contains my explanation, but apparently the patch is too
> large for the list limit and didn't make it through.

This looks really interesting, I'll try to take a closer look after I
return from some vaction next week..

Any numbers on the struct size reduction?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
