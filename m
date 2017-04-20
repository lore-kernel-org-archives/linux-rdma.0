From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Thu, 20 Apr 2017 19:21:29 +0300
Message-ID: <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413097100.14743757.1492668219336.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> [1]
> [ 5968.515237] DMAR: DRHD: handling fault status reg 2
> [ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
> [ 5968.519450] 00000000 00000000 00000000 00000000
> [ 5968.519451] 00000000 00000000 00000000 00000000
> [ 5968.519451] 00000000 00000000 00000000 00000000
> [ 5968.519452] 00000000 02005104 00000316 a71710e3

Max, Can you decode this for us?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
