From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Wed, 29 Mar 2017 07:29:18 -0600
Message-ID: <20170329132918.GA32072@obsidianresearch.com>
References: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu>
 <20170323140042.GA30536@lst.de>
 <277345557.313693033.1490279818647.JavaMail.zimbra@kalray.eu>
 <4951fac6-662f-29a6-5ba5-38d37a2c2dca@grimberg.me>
 <1180136633.325075447.1490700022740.JavaMail.zimbra@kalray.eu>
 <8dc0414f-be90-ee30-0f66-8cee26c4c2aa@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8dc0414f-be90-ee30-0f66-8cee26c4c2aa-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 28, 2017 at 02:30:14PM +0300, Sagi Grimberg wrote:
> I'm not sure what buffering is needed from the device at all in this
> case, the device is simply expected to avoid signaling completions.
> 
> Mellanox folks, any idea where is this limitation coming from?
> Do we need a device capability for it?

Fundamentally you must drive SQ flow control via CQ completions. For
instance a ULP cannot disable all CQ notifications and keep
stuffing things into the SQ.

An alternative way to state this: A ULP cannot use activity on the
RQ to infer that there is space in the SQ. Only CQ completions can be
used to prove there is more available SQ space. Do not post to the SQ
until a CQ has been polled proving available space.

Ultimately you need a minimum of one CQ notification for every SQ
depth post and the ULP must not post to the SQ once it fills until
it sees the CQ notification. That usually drives the rule of thumb to
notify every 1/2 depth, however any SQWE posting failures indicate a
ULP bug..

There are a bunch of varied reasons for this, and it was discussed to
death for NFS. NFS's bugs and wonkyness in this area went away when
Chuck did strict accounting SQ capicty driven by the CQ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
