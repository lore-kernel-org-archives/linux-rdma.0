From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH rfc 3/3] nvmet-rdma: assign cq completion vector based
        on the port allowed cpus
Date: Thu, 13 Jul 2017 19:16:45 +0200
Message-ID: <20170713171645.GA5107@lst.de>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me> <1499007694-7231-4-git-send-email-sagi@grimberg.me> <20170713155003.GB2577@lst.de> <da6a9e33-163e-4964-8305-614b7b830c17@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <da6a9e33-163e-4964-8305-614b7b830c17-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 07:37:13PM +0300, Sagi Grimberg wrote:
>
>> We really shouldn't be doing any of this in NVMe I think.  We'll need
>> to go back to the cq pool API first.  The last version I had was here:
>>
>> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq
>
> Not against the idea, though the ULP will need to pass a desired cpu
> affinity.

Yes.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
