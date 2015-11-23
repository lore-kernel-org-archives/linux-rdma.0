From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: memory registration updates
Date: Mon, 23 Nov 2015 09:06:00 -0600
Message-ID: <56532B58.4060905@opengridcomputing.com>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/22/2015 11:46 AM, Christoph Hellwig wrote:
> This series removes huge chunks of code related to old memory
> registration methods that we don't use anymore, and then simplifies the
> current memory registration API
>
> This expects my "IB: merge struct ib_device_attr into struct ib_device"
> patch to be already applied.
>
> Also available as a git tree:
>
> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-mr
> 	git://git.infradead.org/users/hch/rdma.git rdma-mr
>
>

Series looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
