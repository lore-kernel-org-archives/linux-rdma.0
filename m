From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Tue, 10 Dec 2013 22:30:04 +0000
Message-ID: <54FD86FE-FBA2-49FC-A342-12D7B5E392F0@cisco.com>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF35A@xmb-rcd-x09.cisco.com>
 <CAL1RGDXh1yUk1p9gXC9DztpF4X8XbvHAxqZudwCSLa1xtBvr8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXh1yUk1p9gXC9DztpF4X8XbvHAxqZudwCSLa1xtBvr8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <7FB6A5716926ED4C84DF9B526D52B6A1-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ack.  That's a bug.  Will fix.

Upinder

On Dec 10, 2013, at 1:14 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> On Mon, Sep 9, 2013 at 8:38 PM, Upinder Malhi (umalhi) <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> +/*TODO: Future - usnic_modify_qp needs to pass in generic filters */
>> +struct usnic_ib_create_qp_resp {
>> +       u32                             vfid;
>> +       u32                             qp_grp_id;
>> +       u64                             bar_bus_addr;
>> +       u32                             bar_len;
>> +/*
>> + * WQ, RQ, CQ are explicity specified bc exposing a generic resources inteface
>> + * expands the scope of ABI to many files.
>> + */
>> +       u32                             wq_cnt;
>> +       u32                             rq_cnt;
>> +       u32                             cq_cnt;
>> +       u32                             wq_idx[USNIC_QP_GRP_MAX_WQS];
>> +       u32                             rq_idx[USNIC_QP_GRP_MAX_RQS];
>> +       u32                             cq_idx[USNIC_QP_GRP_MAX_CQS];
>> +       u32                             transport;
> 
> Unless I'm misreading this, the u64 reserved field will have different
> alignment on platforms that align u64 to 4 bytes (eg 32-bit x86) and
> to 8 bytes (eg 64-bit x86) which means you'll have problems running
> 32-bit userspace on a 64-bit kernel.
> 
>> +       u64                             reserved;
>> +};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
