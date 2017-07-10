From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 10 Jul 2017 14:05:22 -0600
Message-ID: <20170710200522.GA19293@obsidianresearch.com>
References: <52ad3547-efcf-f428-6b39-117efda3379f@grimberg.me>
 <9990B5CB-E0FF-481E-9F34-21EACF0E796E@oracle.com>
 <f1f1a68c-90db-e6bf-e35e-55c4b469c339@grimberg.me>
 <7D1C540B-FEA0-4101-8B58-87BCB7DB5492@oracle.com>
 <66b1b8be-e506-50b8-c01f-fa0e3cea98a4@grimberg.me>
 <9D8C7BC8-7E18-405A-9017-9DB23A6B5C15@oracle.com>
 <11aa1a24-9f0b-dbb8-18eb-ad357c7727b2@grimberg.me>
 <9E30754F-464A-4B62-ADE7-F6B2F6D95763@oracle.com>
 <20170709164755.GB3058@obsidianresearch.com>
 <A7C8C159-E916-4060-9FD1-8726D816B3C0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A7C8C159-E916-4060-9FD1-8726D816B3C0-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 10, 2017 at 03:03:18PM -0400, Chuck Lever wrote:

> One option is to somehow split the Send-related data structures from
> rpcrdma_req, and manage them independently. I've already done that for
> MRs: MR state is now located in rpcrdma_mw.

Yes, this is is what I was implying.. Track the SQE related stuff
seperately in memory allocated during SQ setup - MR, dma maps, etc.

No need for an atomic/lock then, right? The required memory is bounded
since the inline send depth is bounded.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
