From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Need some pointers to debug a KASAN splat in NVMe over Fabrics
 with rdma-rxe
Date: Thu, 9 Mar 2017 12:04:21 +0100
Message-ID: <2f03bad8-02a2-067a-2d3c-20cd3c974519@suse.de>
References: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de>
 <CAG9sBKPwEryc7U+hV=XJvRrFFhNvoktDOtwwS6piUw=cQ=bZhA@mail.gmail.com>
 <38a12b22-7bad-c069-4c96-39fc93d20d79@suse.de>
 <CAG9sBKNXwHFkmQYsOPPu40822h6Z7J3+63CaZ844juZp5hfHfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNXwHFkmQYsOPPu40822h6Z7J3+63CaZ844juZp5hfHfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/09/2017 11:59 AM, Moni Shoua wrote:
>>> 2. You can take a look at librxe implementation of init_send_wqe() (it
>>> looks slightly different from kernel's implementation) and see what
>>> happens if you change implementation accordingly.
>>
>> OK I'll have a look and hopefully come back with a (RFC) patch (fingers
>> crossed).
> 
> Thanks. Waiting to see what you found and in the meantime I'll try to
> reproduce in my setup

>From what I can see librxe will have the same problem. The affected
code's more or less a copy of the kernel version.

I'm currently skimming through mlx5/qp.c trying to understand the known
good code path.

Byte,
	Johannes


-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
