From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Deadlock on device removal event for NVMeF target
Date: Thu, 29 Jun 2017 17:32:36 +0300
Message-ID: <3e559faf-9ea4-081e-c9cd-cb1c36b4673f@grimberg.me>
References: <20170626225920.GA11700@ssaleem-MOBL4.amr.corp.intel.com>
 <56030fcd-b8a0-fc0e-18e5-985ebf16a82e@grimberg.me>
 <20170627193157.GA29768@ssaleem-MOBL4.amr.corp.intel.com>
 <61858a46-ebf1-a5bd-5213-65dadaadb84d@grimberg.me>
 <CAANLjFr++5daZ6Vn8TYxcM0oMyU4PuMztcM5KKM6mOy7HEs7KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFr++5daZ6Vn8TYxcM0oMyU4PuMztcM5KKM6mOy7HEs7KA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Robert,

> Could something like this be causing the D state problem I was seeing
> in iSER almost a year ago?

No, that is a bug in the mlx5 device as far as I'm concerned (although I
couldn't prove it). I've tried to track it down but without access to
the FW tools I can't understand what is going on. I've seen this same
phenomenon with nvmet-rdma before as well.

It looks like when we perform QP draining in the presence of rdma
operations it may not complete, meaning that the zero-length rdma write
never generates a completion. Maybe it has something to do with the qp
moving to error state when some rdma operations have not completed.

> I tried writing a patch for iSER based on
> this, but it didn't help. Either the bug is not being triggered in
> device removal,

It's 100% not related to device removal.

> or I didn't line up the statuses correctly. But it
> seems that things are getting stuck in the work queue and some sort of
> deadlock is happening so I was hopeful that something similar may be
> in iSER.

The hang is the ULP code waiting for QP drain.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
