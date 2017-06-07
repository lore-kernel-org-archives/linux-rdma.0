From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3 for-4.13 1/6] mlx5: convert to generic
 pci_alloc_irq_vectors
Date: Wed, 7 Jun 2017 08:46:18 +0300
Message-ID: <88e732d0-2c99-5317-318d-15c491f07518@grimberg.me>
References: <1496644560-28923-1-git-send-email-sagi@grimberg.me>
 <1496644560-28923-2-git-send-email-sagi@grimberg.me>
 <CALzJLG97HkMQ8AULoTS+P5FLXhh+2DhjVfVHRYEemea90tXJAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALzJLG97HkMQ8AULoTS+P5FLXhh+2DhjVfVHRYEemea90tXJAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Saeed,

> Hey Sagi, i am sorry for the late review, had some old mail role that
> made me lose some rdma mails.
> Anyway i have one small comment here, But if the reset of the series
> is ok, i don't want to bother you with another V.
> so you can just ignore it if you wish to.
> 

...

>> @@ -350,9 +344,8 @@ static void mlx5_disable_msix(struct mlx5_core_dev *dev)
>>   {
> 
> rename to mlx5_free_irq_vectors to keep a symmetric function naming

Yea I should have done that,

I'll fix and send v4.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
