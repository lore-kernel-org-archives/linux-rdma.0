From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Mon, 6 Mar 2017 13:23:33 +0200
Message-ID: <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2013049462.31187009.1488542111040.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hi experts
>
> I reproduced this issue during stress test on reset_controller, could you help check it, thanks.
>
> Reproduce steps on initiator side:
> num=0
> while [ 1 ]
> do
> 	echo "-------------------------------$num"
> 	echo 1 >/sys/block/nvme0n1/device/reset_controller || exit 1
> 	((num++))
> done
>
> Here is the full log:
> http://pastebin.com/mek9fb0b

I'm using CX5-LX device and have not seen any issues with it.

Would it be possible to retest with kmemleak?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
