From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [v3,1/9] RDMA/core: Add implicit per-device completion queue
 pools
Date: Wed, 3 Jan 2018 10:47:55 -0700
Message-ID: <20180103174755.GH11348@ziepe.ca>
References: <20171108095742.25365-2-sagi@grimberg.me>
 <20171211235044.GA32331@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171211235044.GA32331-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 04:50:44PM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 08, 2017 at 11:57:34AM +0200, Sagi Grimberg wrote:
> > Allow a ULP to ask the core to implicitly assign a completion
> > queue to a queue-pair based on a least-used search on a per-device
> > cq pools. The device CQ pools grow in a lazy fashion with every
> > QP creation.
> > 
> > In addition, expose an affinity hint for a queue pair creation.
> > If passed, the core will attempt to attach a CQ with a completion
> > vector that is directed to the cpu core as the affinity hint
> > provided.
> > 
> > Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> 
> Sagi, Bart,
> 
> Did we reach a conclusion on this? Is v3 the series to take, and
> should it all go through the RDMA tree? It looks like there are some
> missing acks for that??
> 
> I think there was also an unapplied comment from bart in the
> patchworks notes...
> 
> Could you please add some commit messages when you resend it? Not sure
> I should be accepting such large commits with empty messages???

Hearing nothing, I've dropped this series off patchworks. Please
resend it when you are ready.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
