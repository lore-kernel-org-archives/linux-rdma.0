From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data structures
Date: Fri, 13 Jan 2017 21:42:43 +0200
Message-ID: <1f8d3db6-03b7-6c8f-8010-4ab964a87f3c@grimberg.me>
References: <1484261109-3316-1-git-send-email-parav@mellanox.com>
 <20170113074420.GA25814@lst.de>
 <VI1PR0502MB30086F641A07262801C02A28D1780@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB30086F641A07262801C02A28D1780-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Doug needs to rebase to above git tree.
> Followed by Bart's patches, followed by my changes in his tree.
> Without that, Linux-next will get compile error because ib_dma_xx won't be defined.
> Let me know, I have 4.10-rc patch also tested.

No need, we'll jest keep the patch as is, no compile error
will generate.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
