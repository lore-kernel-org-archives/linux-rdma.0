From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/isert: Remove ISER_RECV_DATA_SEG_LEN
Date: Mon, 22 Feb 2016 17:41:12 +0200
Message-ID: <56CB2C18.3030007@dev.mellanox.co.il>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-2-git-send-email-hch@lst.de>
 <CAJ3xEMiGhnsZMdPkqCo25cjdOE8pqZ3A=TfiEvMHsU8Sj3PM8Q@mail.gmail.com>
 <CAJ3xEMgN+j=_zaUfqYQ1yQzUG3fXnKgnJLWU17AeP-51WRcrNw@mail.gmail.com>
 <20160222150558.GA29553@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160222150558.GA29553-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> @@ -92,7 +90,7 @@ enum iser_conn_state {
>>>>   struct iser_rx_desc {
>>>>          struct iser_ctrl iser_header;
>>>>          struct iscsi_hdr iscsi_header;
>>>> -       char            data[ISER_RECV_DATA_SEG_LEN];
>>>> +       char            data[ISCSI_DEF_MAX_RECV_SEG_LEN];
>>>>          u64             dma_addr;
>>>>          struct ib_sge   rx_sg;
>>>>          char            pad[ISER_RX_PAD_SIZE];
>>
>> BTW that pad is probably just c&p from the initiator, has nothing to do here
>
> The way the RX descriptors work is rather odd in many ways. It's on
> my todo list to investigate and rework them.

Hey Christoph and Or,

Indeed the way RX descriptors are handled in isert has a lot of room
for cleanups (among other things...), its on my todo list as well. I
didn't have a lot of time to spend on isert lately but I do plan to
to resume the work there soon enough.

Christoph,
I took your patches for testing and evaluation (on top of some fixes
from Jenny I have in the pipe), basic functionality seems to work just
fine, I'll make sure to run some more tests and review the code.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
