From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] xprtrdma Send completion batching
Date: Tue, 5 Sep 2017 21:28:52 -0400
Message-ID: <bdc2a166-d5d9-2919-9abb-fa05f7ea9f84@talpey.com>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
 <20170905200608.GA4055@obsidianresearch.com>
 <0D960F54-0BC7-4A5A-8001-0391673892DF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0D960F54-0BC7-4A5A-8001-0391673892DF-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/5/2017 5:22 PM, Chuck Lever wrote:
> I think it does bear mentioning that, given this diagnosis, it is
> still safe to remove the ib_post_send counting mechanism in 5/5,
> which has been in xprtrdma for as long as I can recall, and has

2007. :-)

> been effective (with a few minor adjustments) at preventing SQ
> overflow.
> 
> I'm not able to test this change with every HCA the Linux kernel
> currently supports, unfortunately. The best I can do is offer a
> "proof of correctness" and hope that vendors will jump on this
> and try it out.

Someday, a proper set of verbs test cases? Alas.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
