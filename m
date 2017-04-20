From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v3] nvme-rdma: support devices with queue size < 32
Date: Thu, 20 Apr 2017 14:43:27 +0300
Message-ID: <dc34a67f-a650-311d-f9ae-7e854c9d7067@grimberg.me>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu>
 <1491838338.4199.5.camel@sandisk.com>
 <1807354347.364485979.1491900728245.JavaMail.zimbra@kalray.eu>
 <1491923426.2654.1.camel@sandisk.com>
 <1677617891.385461828.1492681414720.JavaMail.zimbra@kalray.eu>
 <391faec7-924d-7af2-eb1b-b3106bd4193c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <391faec7-924d-7af2-eb1b-b3106bd4193c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Looks good,
>
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> BTW, did you test with deeper queue depths (say 512)?

Wait, taking it back...

Can you make nvme_rdma_queue_sig_limit() return a bool instead?

Also, Looking at this closer, I'm pretty convinced that this
should convert to atomic. For iSER its fine as is because
we are under the iscsi connection lock, but here we need to
handle mutual exclusion.

This would be an incremental change though.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
