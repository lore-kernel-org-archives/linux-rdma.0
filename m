From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 00/10] Verbs RSS
Date: Sun, 29 May 2016 14:27:57 +0300
Message-ID: <20160529112755.GB7074@yuval-lap.uk.oracle.com>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464006056-19653-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 03:20:46PM +0300, Yishai Hadas wrote:
> 
> RSS (Receive Side Scaling) technology allows to spread incoming traffic
> between different receive descriptor queues.
> Assigning each queue to different CPU cores allows to better load
> balance the incoming traffic and improve performance.
> 
> This patch-set introduces some new objects and verbs in order to allow
> verbs based solutions to utilize the RSS offload capability which is
> widely supported today by many modern NICs. It extends the IB and uverbs
> layers to support the above functionality and supplies a specific
> implementation for the mlx5_ib driver.
Any plans for mlx4_ib driver?
> 
> The implementation is based on an RFC that was sent to the list some
> months ago and describes the expected verbs and objects.
> RFC: http://www.spinics.net/lists/linux-rdma/msg25012.html
> 
> In addition, below URL can be used as a reference to the motivation and
> the justification to add the new objects that are described below.
> http://lxr.free-electrons.com/source/Documentation/networking/scaling.txt
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
