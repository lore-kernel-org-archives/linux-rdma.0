From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 08/28] bnxt_re: Add bnxt_re RoCE driver files
Date: Tue, 6 Dec 2016 11:26:36 +0530
Message-ID: <CA+sbYW0MyF4ESEL7U7+TXOUR4cciuuoTB+RJS1N0b_0CURHD+g@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <1480919912-1079-9-git-send-email-selvin.xavier@broadcom.com> <09068db2-1a14-9fbb-074b-4cf000fbddfb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <09068db2-1a14-9fbb-074b-4cf000fbddfb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

 Please find my response inline.

On Mon, Dec 5, 2016 at 8:46 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/5/2016 1:38 AM, Selvin Xavier wrote:
>
...
>> +++ b/drivers/infiniband/hw/bnxtre/Makefile
>> @@ -0,0 +1,5 @@
>> +
>> +obj-$(CONFIG_INFINIBAND_BNXTRE) += bnxt_re.o
>> +bnxt_re-y := bnxt_re_main.o bnxt_re_ib_verbs.o \
>> +          bnxt_qplib_res.o bnxt_qplib_rcfw.o \
>> +          bnxt_qplib_sp.o bnxt_qplib_fp.o
>
> A lot of times I prefer these files to be the final patch in the series.
>  It's completely not possible to break bisectability if these are last.
> Then again, if I squash this down to one commit it doesn't really matter....
>
[Selvin Xavier] While splitting the patch series, we made sure that
the compilation works after applying each patch.
But i am ok to push these changes to last patch. This can be included
in v2 patch set.
....
>
> This copyright, repeated many times in the various skeleton files...
>
>> diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
>> new file mode 100644
>> index 0000000..4c377dc
>> --- /dev/null
>> +++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
>> @@ -0,0 +1,96 @@
>> +/* Broadcom NetXtreme-C/E RoCE driver.
>> + *
>> + * Copyright (c) 2016 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +/*
>> + * Description: Main component of the bnxt_re driver
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/mutex.h>
>> +#include <linux/list.h>
>> +#include <linux/rculist.h>
>> +#include "bnxt_re.h"
>> +static char version[] =
>> +             BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
>> +
>> +
>> +MODULE_AUTHOR("Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>");
>> +MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
>> +MODULE_LICENSE("Dual BSD/GPL");
>
> and this module license description do not agree.  Please make
> everything consistent.  I don't care if it's GPLv2 or Dual licensed, it
> simply needs to be consistent.
>

[Selvin Xavier] i will post v2 with this change. We need Dual license.
Will edit the license text
accordingly.

>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>

Thanks,
Selvin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
