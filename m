From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 04/11] xprtrdma: Move struct ib_send_wr off the stack
Date: Wed, 16 Dec 2015 07:11:15 -0800
Message-ID: <20151216151115.GA16905@infradead.org>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net>
 <20151214211811.16295.47695.stgit@manet.1015granger.net>
 <56716E6C.4020604@dev.mellanox.co.il>
 <F2E992ED-2698-43DE-B7C5-4F02DA75AE42@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F2E992ED-2698-43DE-B7C5-4F02DA75AE42-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 10:06:33AM -0500, Chuck Lever wrote:
> > Would it make sense to unionize these as they are guaranteed not to
> > execute together? Some people don't like this sort of savings.
> 
> I dislike unions because they make the code that uses
> them less readable. I can define macros to help that,
> but sigh! OK.

Shouldn't be an issue with transparent unions these days:

	union {
		struct ib_reg_wr                fr_regwr;
		struct ib_send_wr               fr_invwr;
	};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
