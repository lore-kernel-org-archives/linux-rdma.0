From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Tue, 24 May 2016 10:03:36 +0300
Message-ID: <CAAk-MO-M6heX7bXi53gbDe89AnUQQ0fA2d_uiKHPyF+S_G4qhA@mail.gmail.com>
References: <1463991263-13084-1-git-send-email-erezsh@mellanox.com>
	<1463991263-13084-2-git-send-email-erezsh@mellanox.com>
	<ead67cbd-ca28-322b-0435-ab01c1f04be5@dev.mellanox.co.il>
	<CAAk-MO-2JQpmb8xR4gqQQEfpEpQCgMbxgbOLXhLPW991FhvJWQ@mail.gmail.com>
	<f576c725-b78f-6432-5991-bf82fd0d9a8c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f576c725-b78f-6432-5991-bf82fd0d9a8c-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 6:26 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 05/23/2016 04:49 AM, Erez Shitrit wrote:
>>
>> On Mon, May 23, 2016 at 2:33 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> wrote:
>>>
>>> On 5/23/2016 4:14 AM, Erez Shitrit wrote:
>>>>
>>>> diff --git a/drivers/infiniband/hw/qib/qib_mad.c
>>>> b/drivers/infiniband/hw/qib/qib_mad.c
>>>> index 0bd1837..a872865 100644
>>>> --- a/drivers/infiniband/hw/qib/qib_mad.c
>>>> +++ b/drivers/infiniband/hw/qib/qib_mad.c
>>>> @@ -1172,11 +1172,11 @@ static int pma_get_classportinfo(struct
>>>> ib_pma_mad *pmp,
>>>>        * Set the most significant bit of CM2 to indicate support for
>>>>        * congestion statistics
>>>>        */
>>>> -     p->reserved[0] = dd->psxmitwait_supported << 7;
>>>> +     ib_set_cpi_capmask2(p, dd->psxmitwait_supported << 7);
>>>
>>>
>>> Is this really equivalent to what it's replacing ?
>>
>>
>> Yes. the previous code sets the msb bit in the first byte of the
>> capmask2 (where it was with 3 bytes), no other setting for capmask2
>> in that flow, so it is the same.
>
>
> Hello Erez,
>
> I think you need the following to set the highest bit of
> cap_mask2_resp_time:
>
> ib_set_cpi_capmask2(p, dd->psxmitwait_supported << (31 - 5))
>
> Bart.

Thanks Bart, I will check. and update.

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
