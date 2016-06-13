From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/29] IB/rxe: Shared objects between user and kernel
Date: Mon, 13 Jun 2016 10:22:56 +0300
Message-ID: <CAG9sBKP8-VEnyjQkgu88cfb0zDuj_kyeKsjUY0hztm2hWasnzA@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <1464886657-14258-29-git-send-email-monis@mellanox.com> <20160609060931.GM3663@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609060931.GM3663-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> +header-y += ib_rxe.h
>
Right. I'll rename
> IMHO, it needs to be called ib_user_rxe.h and not ib_rxe.h
> It looks like rdma_netlink.h is exclusion from that convention.
>
>> diff --git a/include/uapi/rdma/ib_rxe.h b/include/uapi/rdma/ib_rxe.h
>> new file mode 100644
>> index 0000000..eb8ff8c
>> --- /dev/null
>> +++ b/include/uapi/rdma/ib_rxe.h
>> @@ -0,0 +1,139 @@
>> +/*
>> + * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
>
> Small nitpick - need to update Copyright.
>
Done
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
