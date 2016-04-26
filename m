From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 22:07:22 +0300
Message-ID: <571FBC6A.6050806@grimberg.me>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F841D.3010909@opengridcomputing.com>
 <CAB5WxwfAGL2qCe7w6A=mKQ65mwjbKKbp_8qFJFRF6Aj7tE+tLQ@mail.gmail.com>
 <20160426154328.GA12398@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160426154328.GA12398-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

> Just curious: what takes care of draining SRQs when we unregister them
> after all queues are gone?

So unlike QPs, we can (and probably should) destroy SRQs after
destroying the CQs and that's a sufficient barrier to destroy the SRQs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
