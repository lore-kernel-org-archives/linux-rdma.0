From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Add tunnel support
Date: Sun, 3 Dec 2017 18:45:55 +0200
Message-ID: <3b1a36fb-8c9c-1c28-539b-57fd4050d8e2@dev.mellanox.co.il>
References: <1511445206-18951-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511445206-18951-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This series from Maor is the supplementary part of the kernel series that was > merged into 4.15.> > It introduces the following support for 
tunneling packets:> 1) RSS on the tunneled packet.> 2) Tunneling 
offloads support for mlx5 devices via the DV API.> > PR was sent:> 
https://github.com/linux-rdma/rdma-core/pull/265
PR was updated according to some notes given in GITHUB, V1 was sent as 
well. (Still don't see it in the ML ..)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
