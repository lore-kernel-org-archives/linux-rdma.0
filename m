From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] nvme-rdma: support devices with queue size < 32
Date: Mon, 22 May 2017 11:51:27 -0700
Message-ID: <20170522185127.GA27542@infradead.org>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1519881025.363156294.1491837154312.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've hand applies this once with a few formatting tweaks now that
I got the ACK from Sagi.  І'd love to see if someone could figure
out how we could move the improved atomic + ilog version into the
rdma core somehow.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
