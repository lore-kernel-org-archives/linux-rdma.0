From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 0/3] RDMA/hns: Updates for reset process of roce
 device in hip08
Date: Sat, 24 Nov 2018 21:14:58 +0800
Message-ID: <5BF94ED2.7070701@huawei.com>
References: <1542986065-44265-1-git-send-email-xavier.huwei@huawei.com>
 <20181123204256.GK3395@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181123204256.GK3395@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, xavier_huwei@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/11/24 4:42, Jason Gunthorpe wrote:
> On Fri, Nov 23, 2018 at 11:14:22PM +0800, Wei Hu (Xavier) wrote:
>> Hi, Doug and Janson
>>
>> This series mainly include updates for reset process of roce device
>> in hip08.
>> One patch adds support for reset and loading or unloading driver occur
>> simultaneously to ensure work normally, one stops sending mailbox&cmq&
>> doorbell when reset occured or reset is occuring, the last one modifies
>> the name of hns RoCE device's name in order to ensure that the name is
>> consistent before and after reset.
>>
>> This series relies on the the new interfaces in hns NIC driver those
>> had been accepted by David, the related commit as below:
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 
>> commit cb7ea80c6dfda472a068d40f4f9755d034b2dfde
> Then you can't send patches to RDMA until the next cycle. Please
> reasend after v4.21-rc1 is out.
>
> We can only coordinate with Dave's tree if you are able to setup a
> shared branch like Mellanox does.
>
> Also, I don't even see cb7ea80c6dfda472a068d40f4f9755d034b2dfde in
> that tree???
Hi, Jason

    Sorry, this is my mistake.
    The dependent patch of hns NIC driver as below:
    https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
    commit    4d60291b6b53afd246a57817fdae0c61a4655182

    We will try to setup the branch, Thanks.

    Best Regards
Xavier
> Jason
>
> .
>
