From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-rc 1/3] RDMA/hns: Fix the Oops during rmmod or insmod
 ko when reset occurs
Date: Tue, 15 Jan 2019 09:48:01 +0800
Message-ID: <5C3D3BD1.4000508@huawei.com>
References: <1547128663-69220-1-git-send-email-xavier.huwei@huawei.com>
 <1547128663-69220-2-git-send-email-xavier.huwei@huawei.com>
 <20190111213411.GA22310@ziepe.ca> <5C399D73.5000902@huawei.com>
 <20190114220655.GD1208@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190114220655.GD1208@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, liudongdong3@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org



On 2019/1/15 6:06, Jason Gunthorpe wrote:
> On Sat, Jan 12, 2019 at 03:55:31PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2019/1/12 5:34, Jason Gunthorpe wrote:
>>> On Thu, Jan 10, 2019 at 09:57:41PM +0800, Wei Hu (Xavier) wrote:
>>>> +	/* Check the status of the current software reset process, if in
>>>> +	 * software reset process, wait until software reset process finished,
>>>> +	 * in order to ensure that reset process and this function will not call
>>>> +	 * __hns_roce_hw_v2_uninit_instance at the same time.
>>>> +	 * If a timeout occurs, it indicates that the network subsystem has
>>>> +	 * encountered a serious error and cannot be recovered from the reset
>>>> +	 * processing.
>>>> +	 */
>>>> +	if (ops->ae_dev_resetting(handle)) {
>>>> +		dev_warn(dev, "Device is busy in resetting state. waiting.\n");
>>>> +		end = msecs_to_jiffies(HNS_ROCE_V2_RST_PRC_MAX_TIME) + jiffies;
>>>> +		while (ops->ae_dev_resetting(handle) &&
>>>> +		       time_before(jiffies, end))
>>>> +			msleep(20);
>>> Really? Does this have to be so ugly? Why isn't there just a simple
>>> lock someplace that is held during reset?
>>>
>>> I'm skeptical that all this strange looking stuff is properly locked
>>> and concurrency safe.
>> Hi, Jason
>>
>> The hns3 NIC driver notifies the hns RoCE driver to perform
>> reset related processing by calling the .reset_notify() interface
>> registered by the RoCE driver.
>>
>> There is a constraint on the hip08 chip, the NIC driver needs to
>> stop the flow before hardware startup reset, otherwise the chip
>> may hang up.
>>
>> We've also thought about using locks, but found using locks can
>> lead to more serious problems because of that restriction of the
>> chip.
>> If using locks here, reset processing may wait for uninstallation
>> to complete, this may lead that NIC driver fails to stop the flow
>> in time in the reset process, thus causing the chip to hang up.
> If you are sleeping then I'm sure a lock can be used instead, how
> would it be any different?
Hi, Jason
    If using locks here, reset process may wait until uninstallation to
complete,
        it may trigger the chip constraint, causing chip to hang up.
    But if using sleeping here, there will notthe case that reset
process wait until
       uninstallation to complete, then will not trigger the chip
constraint.     
    Thanks

    reset process
            lock
            ....
            unlock

    uninitallation
           lock
            ...
           unlock


    Regards
Xavier
> Jason
>
> .
>
