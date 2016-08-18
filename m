From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 00/22] Add Hisilicon RoCE driver
Date: Thu, 18 Aug 2016 20:23:52 +0800
Message-ID: <57B5A8D8.1000209@huawei.com>
References: <1469099217-26071-1-git-send-email-oulijun@huawei.com>
 <1470155196.18081.10.camel@redhat.com> <57AD6FFA.1050108@huawei.com>
 <c6bf07c3-769a-aa02-73fa-a623c0fd7bdc@redhat.com>
 <57B2782B.1030908@huawei.com>
 <e91c0b31-c2e0-7167-3775-def0e1d47a2a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e91c0b31-c2e0-7167-3775-def0e1d47a2a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/8/16 20:07, Doug Ledford 写道:
> On 8/15/2016 10:19 PM, Wei Hu (Xavier) wrote:
>>
>>
>> On 2016/8/15 21:55, Doug Ledford wrote:
>>> On 8/12/2016 2:43 AM, Wei Hu (Xavier) wrote:
>>>>
>>>> On 2016/8/3 0:26, Doug Ledford wrote:
>>>>> On Thu, 2016-07-21 at 19:06 +0800, Lijun Ou wrote:
>>>>>> The Hisilicon Network Substem is a long term evolution IP which is
>>>>>> supposed to be used in Hisilicon ICT SoCs. HNS (Hisilicon Network
>>>>>> Sybsystem) also has a hardware support of performing RDMA with
>>>>>> RoCEE.
>>>>>> The driver for Hisilicon RoCEE(RoCE Engine) is a platform driver and
>>>>>> will support mulitple versions of SOCs in future. This version of
>>>>>> driver
>>>>>> is meant to support Hip06 SoC(which confirms to RoCEv1 hardware
>>>>>> specifications).
>>>>> I would like to thank you for being as responsive as you've been during
>>>>> the review process.  I know you have put a lot of effort into
>>>>> addressing people's questions/comments.  You've addressed the review
>>>>> comments I had, as well as other peoples.  At this point, I don't want
>>>>> to say the driver is perfect, because as you continue to look at it you
>>>>> will almost always find something you can nitpick (like this segment in
>>>>> hns_roce_cmd.h:
>>>>>
>>>>> enum {
>>>>>     HNS_ROCE_CMD_TIME_CLASS_A    = 10000,
>>>>>     HNS_ROCE_CMD_TIME_CLASS_B    = 10000,
>>>>>     HNS_ROCE_CMD_TIME_CLASS_C    = 10000,
>>>>> };
>>>>>
>>>>> This is a case where you guys used the mlx4 RoCE driver as a template
>>>>> to help you create your own...and their driver has to have different
>>>>> timeout expectations for different firmware commands because some take
>>>>> a long time and others don't, and you ended up copying this TIME_CLASS
>>>>> stuff to your driver, but it isn't really needed and so they all have
>>>>> the same value).  However, I believe you have brought the driver to a
>>>>> level of quality sufficient for the initial submission to the linux
>>>>> tree.  As such, I have taken v12 of your patchset.  I squashed many of
>>>>> the patches into just one patch, so the series now looks like this:
>>>>>
>>>>> dd778a9920a6 MAINTAINERS: Add maintainers for Hisilicon RoCE driver
>>>>> 51db6bbe7de1 IB/hns: Kconfig and Makefile for RoCE module
>>>>> 5e43122add63 IB/hns: Add driver files for hns RoCE driver
>>>>> c2c3b9d9e463 devicetree: bindings: IB: Add binding document for
>>>>> Hisilicon RoCE
>>>>> c80815c0b214 net: hns: Add reset function support for RoCE driver
>>>>> 92d21ac74a9e Linux 4.7-rc7
>>>>>
>>>>> Thanks for all the hard work in answering review comments, series
>>>>> applied ;-)
>>>> Hi, Doug Ledord
>>>>
>>>>     Thank you very much!
>>>>
>>>>     If we prepare to add new feature for HNS driver, which repo can we
>>>> send patchset against?
>>>>     :)
>>> You'll have to send it against my hns branch.  I didn't submit the
>>> driver this merge window because it had merge conflicts between your
>>> code and other patches going in through Dave Miller's net tree.  I've
>>> already been down this road with Mellanox where Dave gets some patches
>>> and I get others and they have merge conflicts and then Linus yells at
>>> me.  So, before I submit your driver, it has to go in without merge
>>> conflicts in files touched by both you and other people at Huawei.
>>>
>> Hi, Doug Ledord
>>
>>     I am very sorry about it.  I have dissucsed with pepole responsible
>> for NiC HNS driver,
>> and we will do our best to ensure no confilct again.
>>    Can you give me suggestion how we should solve problem this time?
>> Maybe we send
>> patch aginst your hns branch to solve confilct,  or other method?
>>
>> Regards
>> Wei Hu
>>
>>
>>
> 
> The only patch that had conflicts in the series above is this one:
> 
> c80815c0b214 net: hns: Add reset function support for RoCE driver
> 
> Send me a new version of that patch that doesn't have conflicts and
> we'll go from there.
> 
Hi, Doug Ledford
  I have send a new version of that patch doesn't have conflicts to you and David Miller.
  Thank you very much!

Regards
Lijun Ou


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
