From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Sun, 22 Nov 2015 11:05:34 +0200
Message-ID: <CAAKD3BAOq+26vV1k5LKOXgOfdr2J92fBta31Pv9XHhEcFc3v6g@mail.gmail.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
	<1447086657-15358-2-git-send-email-matanb@mellanox.com>
	<20151119145457.GA1104@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151119145457.GA1104-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 19, 2015 at 4:54 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> +enum {
>> +     CQ_CREATE_FLAGS_SUPPORTED = IB_CQ_FLAGS_TIMESTAMP_COMPLETION
>> +};
>
>
> How does userspace know the value of IB_CQ_FLAGS_TIMESTAMP_COMPLETION?
>
> It's not defined in any UAPI header.

Currently, a lot of flags are defined both in rdma/ib_verbs.h and are
redefined as part of libibverbs.
For example, IB_ODP_SUPPORT is defined in rdma/ib_verbs.h and
redefined in libibverbs. We took the same approach here.

We could put all of these flags in uverbs, but I think we should be
consistent. So either only uapi exclusive structures should be placed
in
uapi or all uapi related data should be placed there.

Regards,
Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
