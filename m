From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add handling for connecting to IPv6
	targets
Date: Mon, 1 Aug 2016 13:09:56 +0200
Message-ID: <20160801110956.GI16141@lst.de>
References: <1469950060-18098-1-git-send-email-roland@kernel.org> <1469950060-18098-2-git-send-email-roland@kernel.org> <4acdd466-b8f6-8208-7287-e97dfd45bbf1@grimberg.me> <33dfc646-1804-363e-4d83-1ba618303dbb@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <33dfc646-1804-363e-4d83-1ba618303dbb-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Currently the target driver doesn't support ipv6 addresses.
>
> These complementary patches [1,2] makes the it work e2e! So,

I think we should use the same ipv6 addr parsing that Roland used
in the host, and preferably have another module export that as a helper.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
