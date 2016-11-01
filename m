From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Tue, 1 Nov 2016 19:41:15 +0200
Message-ID: <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com>
 <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me>
 <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com>
 <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me>
 <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com>
 <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me>
 <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This looks good.  But you mentioned the 2 rapid-fire keep alive timeout logs for
> the same controller as being seriously broken. Perhaps that is another problem?
> Maybe keep alives aren't getting stopped correctly or something...
>
> But:  I'll try this patch and run for a few hours and see what happens.  I
> believe regardless of a keep alive issue, the above patch is still needed.

In your tests, can you enable dynamic debug on:
nvmet_start_keep_alive_timer
nvmet_stop_keep_alive_timer
nvmet_execute_keep_alive

Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
