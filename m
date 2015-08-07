From: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 23:36:19 -0700
Message-ID: <20150807063619.GD31458@infradead.org>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
 <55C393A0.6000002@opengridcomputing.com>
 <20150806173143.GA25497@infradead.org>
 <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <003601d0d06f$93107160$b9315420$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 06, 2015 at 12:44:42PM -0500, Steve Wise wrote:
> > Driver/staging isn't considered in tree for global API change
> > perspective, so I didn't bother with all these staging drivers.
> 
> The kbuild test bot will probably catch this. 

It already did catch it for my tree, which is expected.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
