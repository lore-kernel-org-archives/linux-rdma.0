From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done()
Date: Thu, 29 Jun 2017 08:36:51 +0300
Message-ID: <ac404f71-3f34-af4c-b7b2-2b19ae768f47@grimberg.me>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
 <20170622223757.GC28955@Dell>
 <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
 <20170628175354.GB1769@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628175354.GB1769@Dell>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Sean Jenkins <sean-v0B6Y9onFlloq1w47eu9iAC/G2K4zDHf@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Just tested this patch, I wasn't able to reproduce the NULL pointer
> dereference or any other bugs, so this fix seems safe enough to me.
> 
> Tested-by: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Can you test just the one liner fix below?

>> @@ -1452,7 +1452,7 @@
>>   isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>>   {
>>   	struct isert_conn *isert_conn = wc->qp->qp_context;
>> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
>> +	struct ib_device *ib_dev = isert_conn->device->ib_device;
>>   
>>   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>>   		isert_print_wc(wc, "login recv");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
