From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 01/15] RDMA/bnxt_re: Fixing the Control path
 command and response handling
Date: Thu, 18 May 2017 16:47:59 +0530
Message-ID: <CA+sbYW0WwxQkPJ_KAdth25p-s320yonO8vKTUa_V43e3ofdAOw@mail.gmail.com>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
 <1495012791-5053-2-git-send-email-selvin.xavier@broadcom.com> <20170518105311.GB3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518105311.GB3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 18, 2017 at 4:23 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> -int bnxt_qplib_rcfw_block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
>> +static int __block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
>>  {
>> -     u32 count = -1;
>> +     u32 count = RCFW_BLOCKED_CMD_WAIT_COUNT;
>>       u16 cbit;
>>
>> -     cookie &= RCFW_MAX_COOKIE_VALUE;
>>       cbit = cookie % RCFW_MAX_OUTSTANDING_CMD;
>>       if (!test_bit(cbit, rcfw->cmdq_bitmap))
>>               goto done;
>>       do {
>> +             mdelay(1); /* 1m sec */
>
> It doesn't work as you may expect. msleep below 20 ms is not reliable.
> See my queued for this cycle commit
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=topic/msleep-to-usleep_range
>
>>               bnxt_qplib_service_creq((unsigned long)rcfw);
>>       } while (test_bit(cbit, rcfw->cmdq_bitmap) && --count);
>>  done:

__block_for_resp is called from functions where it is not expected to
sleep (say from create_ah). That is the reason for
using the mdelay instead of sleep. So we may not be able to use
usleep_range here. Both instances of
mdelay are in the atomic contexts.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
