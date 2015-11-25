From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 08/10] iser-target: Support the remote invalidation
 exception
Date: Wed, 25 Nov 2015 09:55:54 +0200
Message-ID: <5655698A.4020306@dev.mellanox.co.il>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
 <1448382234-24806-9-git-send-email-sagig@mellanox.com>
 <CAJ3xEMjPwD3X-B+56-+sZ9RqMrcNgr_Y060nR3wLMhi_O0MgqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjPwD3X-B+56-+sZ9RqMrcNgr_Y060nR3wLMhi_O0MgqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 24/11/2015 19:42, Or Gerlitz wrote:
> On Tue, Nov 24, 2015 at 6:23 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> @@ -1100,7 +1122,14 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
>>
>>          isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
>>          send_wr->wr_id = (uintptr_t)&isert_cmd->tx_desc;
>> -       send_wr->opcode = IB_WR_SEND;
>> +
>> +       if (isert_conn->snd_w_inv && isert_cmd->inv_rkey) {
>> +               send_wr->opcode  = IB_WR_SEND_WITH_INV;
>> +               send_wr->ex.invalidate_rkey = isert_cmd->inv_rkey;
>> +       } else {
>> +               send_wr->opcode = IB_WR_SEND;
>> +       }
>> +
>
>> @@ -1489,6 +1518,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
>>                  isert_cmd->read_va = read_va;
>>                  isert_cmd->write_stag = write_stag;
>>                  isert_cmd->write_va = write_va;
>> +               isert_cmd->inv_rkey = read_stag ? read_stag : write_stag;
>
> bug
>
> what happens for commands for which we don't register any memory, TUR and such?

Hi Or,

For NO_DATA commands the iser specification explicitly states that
read_stag and write_stag should be 0 which means that inv_rkey is 0
too. We don't do remote invalidate in case inv_rkey is 0.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
