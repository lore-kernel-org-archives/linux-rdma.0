From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Thu, 24 Aug 2017 15:11:19 +0300
Message-ID: <cbc43d35-27c9-331d-b345-b09530477d74@mellanox.com>
References: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
 <97bb90ec-4337-62f7-f08d-a673975a5637@grimberg.me>
 <20170425180630.GU14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425180630.GU14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/25/2017 9:06 PM, Leon Romanovsky wrote:
> On Thu, Apr 20, 2017 at 07:21:29PM +0300, Sagi Grimberg wrote:
>>
>>> [1]
>>> [ 5968.515237] DMAR: DRHD: handling fault status reg 2
>>> [ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
>>> [ 5968.519450] 00000000 00000000 00000000 00000000
>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>> [ 5968.519451] 00000000 00000000 00000000 00000000
>>> [ 5968.519452] 00000000 02005104 00000316 a71710e3
>>
>> Max, Can you decode this for us?
>
> I'm not Max and maybe he will shed more light on it. I didn't find such
> error in our documentation.


Sorry for the late response.

Yi Zhang,
Is it still repro ?

-Max.

>
> Thanks
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
