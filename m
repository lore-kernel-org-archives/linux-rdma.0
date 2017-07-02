From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc 0/3] Expose cpu mapping hints to a nvme target port
Date: Sun, 2 Jul 2017 20:41:15 +0300
Message-ID: <e33f16a7-4e1d-7fd6-6d2c-5a5bac450c73@grimberg.me>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
 <b77be367-6cbc-c12c-8135-eddff0aec90e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b77be367-6cbc-c12c-8135-eddff0aec90e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi,
> Very interesting patchset. You give a lot of power to the user here, we 
> need to hope that he will use it right :).

I don't think so, its equivalent to running an application with a given
taskset, nothing fancy here...

The straight forward configuration this is targeting is a dual-socket system
where on each node you have one (or more) HCA and some NVMe devices
(say 4). All this is doing is allowing the user to contain nvme target 
port cpu cores
to its own numa socket so if on that port only expose the local NVMe devices
DMA traffic won't cross QPI.

While a subsystem is the collection of devices, the port is where I/O 
threads
really live as they feed of the device IRQ affinity. Especially with SRQ 
which I'll
be touching soon. The user does indeed need to be aware of all this, but 
if he
isn't, then he shouldn't touch this setting.

> Do you have some fio numbers to compare w/w.o this series ? also cpu 
> utilization measures are interesting too..

Not really, this is an RFC level code, lightly tested on my VM...

If this is interesting to you I can use some testing if you volunteer ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
