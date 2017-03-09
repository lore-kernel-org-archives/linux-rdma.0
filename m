From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Need some pointers to debug a KASAN splat in NVMe over Fabrics
 with rdma-rxe
Date: Thu, 9 Mar 2017 12:59:31 +0200
Message-ID: <CAG9sBKNXwHFkmQYsOPPu40822h6Z7J3+63CaZ844juZp5hfHfg@mail.gmail.com>
References: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de> <CAG9sBKPwEryc7U+hV=XJvRrFFhNvoktDOtwwS6piUw=cQ=bZhA@mail.gmail.com>
 <38a12b22-7bad-c069-4c96-39fc93d20d79@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <38a12b22-7bad-c069-4c96-39fc93d20d79-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> 2. You can take a look at librxe implementation of init_send_wqe() (it
>> looks slightly different from kernel's implementation) and see what
>> happens if you change implementation accordingly.
>
> OK I'll have a look and hopefully come back with a (RFC) patch (fingers
> crossed).

Thanks. Waiting to see what you found and in the meantime I'll try to
reproduce in my setup
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
