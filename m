From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] iser-target: Fix error return code in
 isert_alloc_login_buf()
Date: Sun, 7 Aug 2016 12:17:48 +0300
Message-ID: <e645ab00-7a1b-5a23-83a1-b6a6cd2346c2@grimberg.me>
References: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
 <20160805143609.GM27667@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160805143609.GM27667-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Fix to return error code -ENOMEM from the alloc error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/ulp/isert/ib_isert.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>> index ba6be06..65af523 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -449,6 +449,7 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
>>  	isert_conn->login_rsp_buf = kzalloc(ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
>>  	if (!isert_conn->login_rsp_buf) {
>>  		isert_err("Unable to allocate isert_conn->login_rspbuf\n");
>
> Please remove the line above too.
> There is no chance to miss kzalloc allocation failure.

With Leon's comment you can add my:

Acked-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
