From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Tue, 5 Jul 2016 15:44:04 +0300
Message-ID: <CAJ3xEMgSMK+xkRmr-MQCBdnFuQT_BKRCjNA+vj7f6wXojHPzrA@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org>
 <1467550074-24061-3-git-send-email-leon@kernel.org> <CAJ3xEMjqkn09zFXZ5Fj3wvtM3GSa=vzgTuuVoAFENToa4Zh4uw@mail.gmail.com>
 <20160704045111.GA5289@leon.nu> <CAJ3xEMgErk9Gu8g98dxkdjRP6aiq6hdkAOPj-a2zKLSTwaGZ0w@mail.gmail.com>
 <20160705104525.GC15009@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160705104525.GC15009-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 5, 2016 at 1:45 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Jul 04, 2016 at 03:40:10PM +0300, Or Gerlitz wrote:

>> +++ b/include/uapi/rdma/rdma_user_cm.h
>> @@ -244,12 +244,19 @@ struct rdma_ucm_join_ip_mcast {
>>   __u32 id;
>>  };
>>
>>  struct rdma_ucm_join_mcast {
>>   __u64 response; /* rdma_ucma_create_id_resp */
>>   __u64 uid;
>>   __u32 id;
>>   __u16 addr_size;
>> - __u16 reserved;
>> + __u16 join_flags;
>>   struct sockaddr_storage addr;
>>  };

> The main issue here that new code is using this struct and new field while the old
> code uses reserved field.

If per your judgment, in this case we can't break things for UAPI vs
non-UAPI, let have an exception and move on :)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
