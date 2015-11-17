From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 11:50:59 +0200
Message-ID: <564AF883.2070307@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADF68.1050408@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564ADF68.1050408-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 10:03, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>>   void iser_rcv_completion(struct iser_rx_desc *rx_desc,
>> -             unsigned long rx_xfer_len,
>> +             struct ib_wc *wc,
>>                struct ib_conn *ib_conn)
>>   {
>>       struct iser_conn *iser_conn = container_of(ib_conn, struct
>> iser_conn,
>> @@ -575,6 +621,7 @@ void iser_rcv_completion(struct iser_rx_desc
>> *rx_desc,
>>       struct iscsi_hdr *hdr;
>>       u64 rx_dma;
>>       int rx_buflen, outstanding, count, err;
>> +    unsigned long rx_xfer_len = wc->byte_len;
>
> unrelated small enhancement which has nothing to do with this patch,
> remove it from here

It is related, we pass wc to check the invalidate stuff down the road...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
