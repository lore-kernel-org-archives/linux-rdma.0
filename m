From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 06/22] IB/hns: Add initial cmd operation
Date: Wed, 22 Jun 2016 15:33:29 +0800
Message-ID: <576A3F49.6040305@huawei.com>
References: <1466087730-54856-1-git-send-email-oulijun@huawei.com>
 <1466087730-54856-7-git-send-email-oulijun@huawei.com>
 <20160620133310.GB4526@leon.nu> <57691C0B.8090509@huawei.com>
 <20160621112808.GA9762@leon.nu> <57693AC4.1070306@huawei.com>
 <20160622045450.GC9762@leon.nu> <576A352F.8000700@huawei.com>
 <20160622072845.GE9762@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160622072845.GE9762-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gongyangming-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xiaokun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tangchaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yankejian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2016/6/22 15:28, Leon Romanovsky wrote:
> On Wed, Jun 22, 2016 at 02:50:23PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2016/6/22 12:54, Leon Romanovsky wrote:
>>> On Tue, Jun 21, 2016 at 09:01:57PM +0800, Wei Hu (Xavier) wrote:
>>>> On 2016/6/21 19:28, Leon Romanovsky wrote:
>>>>> On Tue, Jun 21, 2016 at 06:50:51PM +0800, Wei Hu (Xavier) wrote:
>>>>>> On 2016/6/20 21:33, Leon Romanovsky wrote:
>>>>>>> On Thu, Jun 16, 2016 at 10:35:14PM +0800, Lijun Ou wrote:
>>>>>>>> This patch added the operation for cmd, and added some functio=
ns
>>>>>>>> for initializing eq table and selecting cmd mode.
>>>>>>>>
>>>>>>>> Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>>>>> Signed-off-by: Nenglong Zhao <zhaonenglong-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
>>>>>>>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>>>>> ---
>>>>>>>> PATCH v9/v8/v7/v6:
>>>>>>>> - No change over the PATCH v5
>>>>>>>>
>>>>>>>> PATCH v5:
>>>>>>>> - The initial patch which was redesigned based on the second p=
atch
>>>>>>>>    in PATCH v4
>>>>>>>> ---
>>>>>>> <...>
>>>>>>>
>>>>>>>> +#define CMD_MAX_NUM		32
>>>>>>>> +
>>>>>>>> +int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
>>>>>>>> +{
>>>>>>>> +	struct device *dev =3D &hr_dev->pdev->dev;
>>>>>>>> +
>>>>>>>> +	mutex_init(&hr_dev->cmd.hcr_mutex);
>>>>>>>> +	sema_init(&hr_dev->cmd.poll_sem, 1);
>>>>>>>> +	hr_dev->cmd.use_events =3D 0;
>>>>>>>> +	hr_dev->cmd.toggle =3D 1;
>>>>>>>> +	hr_dev->cmd.max_cmds =3D CMD_MAX_NUM;
>>>>>>> <...>
>>>>>>>
>>>>>>>> +	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->=
max_cmds;
>>>>>>>> +	     hr_cmd->token_mask <<=3D 1)
>>>>>>>> +		;
>>>>>>>> +	--hr_cmd->token_mask;
>>>>>>> It doesn't look that you dynamically change max_cmds supported.
>>>>>>> Why do you need to calculate token_mask dynamically?
>>>>>> Hi, Leon
>>>>>>
>>>>>>      1. The four lines above are in the function named
>>>>>> hns_roce_cmd_use_events.
>>>>>>           and now this function is only called once in hns_roce_=
probe.
>>>>>>      2. In hns_roce_cmd_use_events,
>>>>>>          we use these 4 lines to achieve the value of hr_cmd->to=
ken_mask
>>>>>> according to hr_cmd->max_cmds dynamically,
>>>>>>          then we only define one marco for hr_cmd->max_cmds as b=
elow:
>>>>>>
>>>>>> 	#define CMD_MAX_NUM		32
>>>>>>
>>>>>>         And it looks more flexible.
>>>>> It is called over engineering.
>>>>> I would recommend to you to remove it.
>>>>>
>>>>> We don't need over complicated code which is executed
>>>>> once with need to maintain with zero benefit.
>>>>>
>>>>> The other places need such simplification too.
>>>> Hi, Leon
>>>>
>>>>          We will modify this place as below:
>>>>          In hns_roce_hw_v1.c(for hip06 soc) file:
>>>>
>>>>              void hns_roce_v1_profile(struct hns_roce_dev *hr_dev)
>>>>              {
>>>>                  <snip>
>>>>                  caps->max_cmds =3D 32;
>>>>                  <snip>
>>>>              }
>>>>
>>>>          In hns_roce_cmd.c file:
>>>>
>>>>    	  int hns_roce_cmd_init(struct hns_roce_dev *hr_dev)
>>>> 	  {
>>>> 	     <snip>
>>>> 	     hr_dev->cmd.max_cmds =3D hr_dev->caps->max_cmds;
>>>>       		<snip>
>>>>            }
>>>>
>>>>         Can you give more suggestions?
>>> I would be happy to do it if I had enough time to review this code.
>>>
>>> General suggestion will be to ask yourself, if value is going to be
>>> changed during the runtime. In case the answer is no, there is no r=
oom
>>> to additional logic which translate constant to different value whi=
ch
>>> will be other constant.
>>>
>>> You should do it across all the patchset.
>>>
>>> So, in this specific case, the proposed change is not enough, you a=
re
>>> not solving an issue, but hiding it.
>>>
>>> Thanks
>> We will modify this place as below=EF=BC=9A
>>
>>      #define CMD_TOKEN_MASK      0x1f
>>
>>     hr_cmd->token_mask =3D CMD_TOKEN_MASK;
>>
>>     delete these four lines:
>>
>> 	for (hr_cmd->token_mask =3D 1; hr_cmd->token_mask < hr_cmd->max_cmd=
s;
>> 	     hr_cmd->token_mask <<=3D 1)
>> 		;
>> 	--hr_cmd->token_mask;
> Thanks,
>
> While you are changing that file, please remove hns_roce_status_to_er=
rno
> function and embed it directly into hns_roce_cmd_event, so it will lo=
ok
> more compact.
>
> 	context->result =3D (status =3D=3D HNS_ROCE_CMD_SUCCESS)?0:-EIO;
ok, we will do it.
Thanks very much for your suggestions!
>>   =09
>> Thanks
>>
>>>> Regards
>>>> Wei Hu
>>>>>> Regards
>>>>>> Wei Hu
>>>>>>
>>>>>>
>>>>>>
>>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
