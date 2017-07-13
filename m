From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc 2/3] RDMA/core: expose cpu affinity based completion
 vector lookup
Date: Thu, 13 Jul 2017 19:30:31 +0300
Message-ID: <0126c38f-c6e1-3496-9c08-dcf043986923@grimberg.me>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
 <1499007694-7231-3-git-send-email-sagi@grimberg.me>
 <20170713155000.GA2577@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713155000.GA2577-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> A ULP might want to lookup an optimal completion vector based on
>> a given cpu core affinity. Expose a lookup routine for it iterating
>> on the device completion vectors searching a vector with affinity
>> matching the given cpu.
> 
> Shouldn't this return the mask of cpus with the matching affinity
> instead of always the first one?

Its the opposite, I'm looking for the vector matching a given cpu.

In case there are multiple vectors with the same cpu assignment,
it doesn't really matter which one is it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
