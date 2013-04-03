From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Wed, 3 Apr 2013 10:04:54 +0300
Message-ID: <515BD496.7030005@mellanox.com>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org> <1363996536-30644-11-git-send-email-nab@linux-iscsi.org> <515A7843.1030804@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515A7843.1030804-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/04/2013 09:18, Or Gerlitz wrote:
> On 23/03/2013 01:55, Nicholas A. Bellinger wrote:
>> +++ b/drivers/infiniband/ulp/isert/isert_verbs.h
>> @@ -0,0 +1,5 @@
>> +extern void isert_connect_release(struct isert_conn *);
>> +extern void isert_put_conn(struct isert_conn *);
>> +extern int isert_cma_handler(struct rdma_cm_id *, struct 
>> rdma_cm_event *);
>> +extern int isert_post_recv(struct isert_conn *, u32);
>> +extern int isert_post_send(struct isert_conn *, struct iser_tx_desc *);
>
> why use extern here? maybe a left over from V1?

Nic, are you picking this comment one and its sister comment asking to 
remove externs and use less header files?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
