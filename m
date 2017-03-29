From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Wed, 29 Mar 2017 16:19:32 -0600
Message-ID: <20170329221932.GA29457@obsidianresearch.com>
References: <4951fac6-662f-29a6-5ba5-38d37a2c2dca@grimberg.me>
 <1180136633.325075447.1490700022740.JavaMail.zimbra@kalray.eu>
 <8dc0414f-be90-ee30-0f66-8cee26c4c2aa@grimberg.me>
 <20170329132918.GA32072@obsidianresearch.com>
 <406682b9-d7ca-4718-5830-7940d2822bc0@grimberg.me>
 <20170329162751.GA7113@obsidianresearch.com>
 <80770042-743e-a271-c636-f72099f9ac56@grimberg.me>
 <9eb08168-18a6-a176-01df-b68b6a225963@redhat.com>
 <3505b835-d0ba-70cb-dfe8-1265fc2bbb83@redhat.com>
 <2ba93b5b-ad36-5533-36e2-9db2e3198c19@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2ba93b5b-ad36-5533-36e2-9db2e3198c19-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 29, 2017 at 07:59:13PM +0300, Sagi Grimberg wrote:
> Yea, you're right, and not only I got it wrong, I even contradicted my
> own suggestion that was exactly what you and Jason suggested (where is
> the nearest rat-hole...)
> 
> So I suggested to signal every X/2 and Marta reported SQ overflows for
> high queue-dpeth. Marta, at what queue-depth have you seen this?

I just want to clarify my comment about RQ - because you are talking
about a queue depth concept.

It is tempting to rely on a queue depth of X == SQ depth of X (or 2*
in this case) and then try to re-use the flow control on the queue to
protect the SQ from overflow.

Generally this does not work because the main queue can retire work
from either the CQ or the RQ. If the retire workload is mainly RQ
based then you can submit to the SQ without a CQ poll and overflow
it.

Generally I expect to see direct measurement of SQ capacity and plug
the main queue when the SQ goes full.

To check this use a simple assertion, decrement a counter on every
post, increment it appropriately on every polled CQ, init to the SQ
depth, and assert the counter never goes negative.

Triggering the assertion is an unconditional ULP bug, and is the most
likely cause of a posting no space failure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
