From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 17 May 2017 14:50:58 +0200 (CEST)
Message-ID: <1663889710.35971858.1495025458229.JavaMail.zimbra@kalray.eu>
References: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu> <20170503155316.GA14334@obsidianresearch.com> <1493827096.3901.4.camel@sandisk.com> <77ada146-67eb-9dce-d252-6ac630c9a1e8@grimberg.me> <20170503162708.GO22833@mtr-leonro.local> <1493829456.3901.13.camel@sandisk.com> <310709514.10440651.1493902200194.JavaMail.zimbra@kalray.eu> <20170517090202.GA23880@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170517090202.GA23880-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, keith busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> This looks like a good idea to me. Then the division can change into
>> an AND. I'll come back with another version soon.
> 
> Did you get a chance to look at this?  I'm tempted to just merge v2
> with the division in it and leave any fixing up for the time we move this
> guestimate into the rdma core..

Yes, I've done another iteration but it needs testing. I'd prefer one of
the later versions finally. It seems that we're also seeing the
effect of the race condition on the signalling variable. 

However, we can also go incremental: do a like-v2 fix first, then fix the
races in nvme and then add a more general fix for all rdma.

Marta
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
