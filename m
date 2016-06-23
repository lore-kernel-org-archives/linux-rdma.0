From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 0/1] Fix for nvme-rdma host crash in nvmf-all.3
Date: Thu, 23 Jun 2016 10:28:55 +0300
Message-ID: <576B8FB7.5000305@grimberg.me>
References: <cover.1466626499.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1466626499.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This patch fixes a touch-after-free bug I discovered.  It is against
> nvmf-all.3 branch of git://git.infradead.org/nvme-fabrics.git.  The patch
> is kind of ugly, so any ideas on a cleaner solution are welcome.

Hey Steve, I don't see how this bug fixes the root-cause. Not exactly
sure we understand the root-cause. Is it possible that this is a chelsio
specific issue with send completion signaling (like we saw before)? Did
this happen with a non-chelsio device?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
