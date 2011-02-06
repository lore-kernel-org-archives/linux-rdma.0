From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_listen() backlog maximum
Date: Sun, 6 Feb 2011 10:51:30 +0200
Message-ID: <4D4E6112.4060008@voltaire.com>
References: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikqiahK1qNc6_wS6X445oUoVUJsE-nd3uC-sPWs-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Mundy <mmundy42-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike Mundy wrote:
> I'm prototyping a server that needs to accept a large number of
> simultaneous incoming RDMA CM connections. I noticed that
> drivers/infiniband/core/ucma.c limits the backlog to 128. Is there a
> reason why the limit is 128? Or to put it another way, what breaks if
> the limit is increased to a larger value (say 256)?

My understanding is that with the current cma/cm code, under IB/IBoE
the backlog has no impact, in that environment, you're practically 
limited by the mad layer ability to receive the REQ mads. Sean, am I 
correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
