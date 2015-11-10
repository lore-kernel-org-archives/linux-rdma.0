From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/4] IB/core: Add ib_is_udata_cleared
Date: Tue, 10 Nov 2015 10:38:34 +0200
Message-ID: <CAAKD3BAJLu4NG+X8WjVD9b5ixiACmmwFW6owyZY1FHWuCCQ8Dw@mail.gmail.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
	<1447086657-15358-3-git-send-email-matanb@mellanox.com>
	<20151109191817.GE4023@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109191817.GE4023-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 9, 2015 at 9:18 PM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> On Mon, Nov 09, 2015 at 06:30:55PM +0200, Matan Barak wrote:
>>
>> +static inline bool ib_is_udata_cleared(struct ib_udata *udata,
>> +                                    char cleared_char,
>> +                                    size_t offset,
>> +                                    size_t len)
>> +{
>> +     short i;
>> +
>> +     for (i = 0; i < len; i++) {
> You are comparing "len" which is declared as size_t which is "unsigned" int and "i" which is "short".

Thanks, I'll change i to be unsigned.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
