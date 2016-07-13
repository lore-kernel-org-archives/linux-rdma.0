From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: crash on device removal
Date: Wed, 13 Jul 2016 11:17:36 -0500
Message-ID: <008d01d1dd22$11e19cc0$35a4d640$@opengridcomputing.com>
References: <00cb01d1dc5b$51c05970$f5410c50$@opengridcomputing.com> <578611AA.4000103@grimberg.me> <005a01d1dd17$f008a620$d019f260$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005a01d1dd17$f008a620$d019f260$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Hey Steve,
> >
> > I never got this error (but didn't test with cxgb4, did this happen
> > with mlx4/5?).
> 
> Hey Sagi, I don't see this with mlx4.
> 

Correction, I ran the mlx4_ib rmmod test again and hit it.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
