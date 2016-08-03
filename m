From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC 7/7] NVMe: CMB on DMA-BUF
Date: Wed, 3 Aug 2016 13:02:07 +0300
Message-ID: <0c87a1be-96e0-6aa2-920c-53203b5ad9dc@grimberg.me>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
 <1470034653-9097-8-git-send-email-haggaie@mellanox.com>
 <20160801155206.GA23224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801155206.GA23224-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Bates <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Christoph, Haggai,

>> Allocate a CMB region to user-space as a DMA-BUF object.
>
> NACK.  Absolutely no way we're going to export a low-level device
> specific feature to userspace like that.  If you want to DMA to
> the CMB do it from the kernel, and for that we'll need a proper
> block device level API.

I think that in this patch, Haggai was aiming to demonstrate the use
of dma_buf for peer2peer transactions with an RDMA device. I agree
that the CMB example can/should be exposed in the block device level,
but I also think we'd like to generalize the way we expose a bar space
of any peer device to another peer device.

How would you suggest we do that? I think Haggai's proposal is pretty
solid (considering the fact that the vast majority of RDMA applications
live in user-space).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
