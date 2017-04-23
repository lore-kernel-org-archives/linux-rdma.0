From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Sun, 23 Apr 2017 16:35:52 +0300
Message-ID: <9a9668fa-87a7-e730-27e2-8a2b3e7fbc36@mellanox.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492101079.5176.9.camel@sandisk.com>
 <c52b5ce7-5346-419d-26f2-0d4d45d20471@grimberg.me>
 <20170423103439.GC14088@mtr-leonro.local>
 <d697d360-99ca-c3ed-08e2-b89cc50a15b0@grimberg.me>
 <20170423121254.GD14088@mtr-leonro.local>
 <a3264968-2d9e-bda5-1f23-74da248cf4d5@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a3264968-2d9e-bda5-1f23-74da248cf4d5-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/23/2017 3:28 PM, Sagi Grimberg wrote:
>
>> i asked and didn't get answer too.
>> https://www.spinics.net/lists/linux-rdma/msg46407.html
>
> OK, I suppose that the question was to Laurence, but I'll try
> to answer.
>
> We can't really say, this reproduced for 4M transfers, which iSER
> does not support without a applying higher max_sectors modparam.
> But even with that, its a different code path as SRP unlike iSER
> can use multiple MRs for a single transaction.
>
> So short answer, can't say...

I actually answered here:
https://www.spinics.net/lists/linux-rdma/msg46412.html

Sagi,
As you mentioned the IO path is different in SRP and iSER so IMO we 
should start with SRP debugging. NVMf is similar to iSER (and not SRP) 
and that's why I think we can apply this patchset.
If you want to wait till we debug SRP issue it's fine, but I can't repro 
it in my lab so it can take longer.

Lourance,
maybe you can update your FW to the latest CX4 from our site and try to 
repro this issue ?

thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
