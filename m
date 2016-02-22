From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/isert: Remove ISER_RECV_DATA_SEG_LEN
Date: Mon, 22 Feb 2016 16:57:50 +0200
Message-ID: <CAJ3xEMgN+j=_zaUfqYQ1yQzUG3fXnKgnJLWU17AeP-51WRcrNw@mail.gmail.com>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
	<1456148958-27973-2-git-send-email-hch@lst.de>
	<CAJ3xEMiGhnsZMdPkqCo25cjdOE8pqZ3A=TfiEvMHsU8Sj3PM8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiGhnsZMdPkqCo25cjdOE8pqZ3A=TfiEvMHsU8Sj3PM8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 22, 2016 at 4:55 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Feb 22, 2016 at 3:49 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
>> @@ -36,9 +36,7 @@
>> -#define ISER_RECV_DATA_SEG_LEN 8192
>
> Sagi,
>
> Can you please explain WW (When & Why) we changed this from 128 bytes
> to 8192 bytes?!! do we use 8000++ bytes for every RX descriptor or
> this is nowadays only for the login phase? what's the trick?

Oh, I see now that this is isert and not iser... if this descriptor is
used for every IO and set is such hard-coded way, that is terribly
inefficient, NM for now I guess, as this patchset doesn't introduce
this,

>> @@ -92,7 +90,7 @@ enum iser_conn_state {
>>  struct iser_rx_desc {
>>         struct iser_ctrl iser_header;
>>         struct iscsi_hdr iscsi_header;
>> -       char            data[ISER_RECV_DATA_SEG_LEN];
>> +       char            data[ISCSI_DEF_MAX_RECV_SEG_LEN];
>>         u64             dma_addr;
>>         struct ib_sge   rx_sg;
>>         char            pad[ISER_RX_PAD_SIZE];

BTW that pad is probably just c&p from the initiator, has nothing to do here
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
