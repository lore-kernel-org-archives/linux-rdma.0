From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Mon, 7 Nov 2016 19:51:02 +0100
Message-ID: <20161107185102.GA4820@lst.de>
References: <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com> <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me> <024e01d23476$6668b890$333a29b0$@opengridcomputing.com> <3512b8bb-4d29-b90a-49e1-ebf1085c47d7@grimberg.me> <004601d2351a$d9db85b0$8d929110$@opengridcomputing.com> <20161102151540.GB14825@lst.de> <bd82c206-668a-0794-2d51-3c48058350d3@grimberg.me> <1478543378.3350.17.camel@linux.intel.com> <20161107184126.GA4400@lst.de> <1478544616.3350.29.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478544616.3350.29.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: J Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Minturn, Dave B" <dave.b.minturn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 07, 2016 at 10:50:16AM -0800, J Freyensee wrote:
> OK, so basically the nvmet change would be to make sure unique cntlids
> are used across all NVM subsystems within the NVMe Target then?

Yes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
