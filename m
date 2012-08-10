From: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [trivial] infiniband: Fix typo in infiniband driver
Date: Fri, 10 Aug 2012 09:08:21 +0900
Message-ID: <CALLJCT24Us8r7pY4LQTnciUcFvx+mfLcwqwci7aBVjE7B8vocQ@mail.gmail.com>
References: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237346A7D419@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A7D419-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for the review.
I just posted version 2.

Masanari

On Fri, Aug 10, 2012 at 8:51 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c
>> b/drivers/infiniband/hw/amso1100/c2_rnic.c
>> index 8c81992..b80867e 100644
>> --- a/drivers/infiniband/hw/amso1100/c2_rnic.c
>> +++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
>> @@ -439,7 +439,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
>>
>>  /*
>>   * Called by c2_probe to initialize the RNIC. This principally
>> - * involves initalizing the various limits and resouce pools that
>> + * involves initalizing the various limits and resource pools that
>
> while we're here, can we fix initializing too?  thanks
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
