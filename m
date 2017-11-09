From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] bnxt_re/lib: increament psn in case of 0
 length packets
Date: Thu, 9 Nov 2017 16:35:21 +0530
Message-ID: <CANjDDBg46Xvdh9AfAv-6B4TQy5j+91LU9iz6J1zhqPuO0p_6eA@mail.gmail.com>
References: <1510218658-16710-1-git-send-email-devesh.sharma@broadcom.com>
 <1510218658-16710-3-git-send-email-devesh.sharma@broadcom.com> <20171109095138.GE18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109095138.GE18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes, sending a rev, sent out wrong version.

On Thu, Nov 9, 2017 at 3:21 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Nov 09, 2017 at 04:10:58AM -0500, Devesh Sharma wrote:
>> If application posts a 0 length packte, post send routine
>> is skipping to increament the psn number. This will cause
>> PSN number to go out of sync and evantually connection would
>> terminate due to sequence error.
>>
>> post_send routine must increament the psn number by 1 even
>> for zero length packets.
>
> s/increament/increment in all places.
>
> Thanks
>
>>
>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  providers/bnxt_re/verbs.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
>> index 4d9b044..9d4e02b 100644
>> --- a/providers/bnxt_re/verbs.c
>> +++ b/providers/bnxt_re/verbs.c
>> @@ -1048,6 +1048,8 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
>>               pkt_cnt = (len / qp->mtu);
>>               if (len % qp->mtu)
>>                       pkt_cnt++;
>> +             if (len == 0)
>> +                     pkt_cnt = 1;
>>               nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
>>               psns->flg_npsn = htole32(nxt_psn);
>>               qp->sq_psn = nxt_psn;
>> --
>> 1.8.3.1
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
