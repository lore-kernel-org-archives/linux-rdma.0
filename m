From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Need some pointers to debug a KASAN splat in NVMe over Fabrics
 with rdma-rxe
Date: Thu, 9 Mar 2017 08:57:46 +0100
Message-ID: <38a12b22-7bad-c069-4c96-39fc93d20d79@suse.de>
References: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de>
 <CAG9sBKPwEryc7U+hV=XJvRrFFhNvoktDOtwwS6piUw=cQ=bZhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPwEryc7U+hV=XJvRrFFhNvoktDOtwwS6piUw=cQ=bZhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Moni,

On 03/08/2017 05:33 PM, Moni Shoua wrote:
> Your report and analysis seem to be accurate (regarding value of wqe->iova)
> Unfortunately we didn't have a chance yet to run kernel application
> tests but I will try to add them soon and be able to debug it myself.
> In the meantime

OK, thanks. This is highly appreciated as I think Soft RoCE is the
coolest thing since sliced bread for quick NVMf/iSER and SRP tests.

> 1. DId the test fail completely or is it just the KASAN error that
> made you look at init_send_wqe()?

No it fails completely. I can see both hosts talk RDMA/NVMf to each
other but the initiator side can't establish a connection. Without KASAN
I couldn't find a reason for it other than the following log message:
rdma_rxe: qp#17 moved to error state

I must admit I haven't looked up it's source yet, as my first test had
KASAN enabled.

> 2. You can take a look at librxe implementation of init_send_wqe() (it
> looks slightly different from kernel's implementation) and see what
> happens if you change implementation accordingly.

OK I'll have a look and hopefully come back with a (RFC) patch (fingers
crossed).

Thanks,
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
