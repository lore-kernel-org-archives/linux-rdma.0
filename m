From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Tue, 10 May 2016 18:45:02 +0300
Message-ID: <CAAk-MO-CUCyfdK+QwBya7sFcFWrLWL=-9Cs+4Vo5BJ4XoqTvRQ@mail.gmail.com>
References: <1462892208-6140-1-git-send-email-erezsh@mellanox.com>
	<1462892208-6140-2-git-send-email-erezsh@mellanox.com>
	<57320078.9060608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57320078.9060608-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 6:38 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 05/10/2016 07:56 AM, Erez Shitrit wrote:
>>   drivers/infiniband/hw/qib/qib_mad.c   | 6 ++++--
>>   drivers/infiniband/ulp/srpt/ib_srpt.c | 5 ++++-
>>   include/rdma/ib_mad.h                 | 4 ++--
>>   3 files changed, 10 insertions(+), 5 deletions(-)
>
> This patch modifies ib_srpt but I'm not on the CC-list for this patch
> series?

my bad. will fix that next time.

>
>> diff --git a/drivers/infiniband/hw/qib/qib_mad.c
>> b/drivers/infiniband/hw/qib/qib_mad.c
>> index 0bd1837..c5d029d 100644
>> --- a/drivers/infiniband/hw/qib/qib_mad.c
>> +++ b/drivers/infiniband/hw/qib/qib_mad.c
>> @@ -1158,6 +1158,7 @@ static int pma_get_classportinfo(struct ib_pma_mad
>> *pmp,
>>         struct ib_class_port_info *p =
>>                 (struct ib_class_port_info *)pmp->data;
>>         struct qib_devdata *dd = dd_from_ibdev(ibdev);
>> +       char *p_cap_mask2;
>>
>>         memset(pmp->data, 0, sizeof(pmp->data));
>>
>> @@ -1172,11 +1173,12 @@ static int pma_get_classportinfo(struct ib_pma_mad
>> *pmp,
>>          * Set the most significant bit of CM2 to indicate support for
>>          * congestion statistics
>>          */
>> -       p->reserved[0] = dd->psxmitwait_supported << 7;
>> +       p_cap_mask2 = (char *)&p->cap_mask2_resp_time;
>> +       p_cap_mask2[0] = dd->psxmitwait_supported << 7;
>
>
> Casting __be32 * into char * will make the sparse endianness checks go
> crazy. Please introduce (inline) functions that allow to extract and set the
> cap_mask2 and resp_time fields. Please also verify whether the modified code
> builds cleanly with make C=2 CF=-D__CHECK_ENDIAN__.

OK, will do.

>
> Bart.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
