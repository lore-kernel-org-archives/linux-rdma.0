From: "Wei Hu (Xavier)" <xavier.huwei@tom.com>
Subject: Re: [PATCH for-next 05/20] RDMA/hns: Add command queue support for
 hip08 RoCE driver
Date: Thu, 28 Sep 2017 12:34:38 +0800
Message-ID: <05bebc4c-eabf-a21b-cf5a-79a09fe71e02@tom.com>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-6-git-send-email-xavier.huwei@huawei.com>
 <1506359213.120853.75.camel@redhat.com>
 <20170925171821.GQ25094@mtr-leonro.local>
 <1506361015.120853.81.camel@redhat.com> <59CA5261.80209@huawei.com>
 <81dd332d-e060-d7e3-bec9-1791511c5470@redhat.com>
 <9172f8c5-3dd6-a573-8e28-1b3ae4b1726b@tom.com>
 <1b8bda3b-c514-7e46-08bf-3ea50ea68096@redhat.com>
 <1506516105.82712.0.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506516105.82712.0.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, "Wei Hu (Xavier)" <xavier.huwei@huawei.com>, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2017/9/27 20:41, Doug Ledford wrote:
> On Wed, 2017-09-27 at 08:21 -0400, Doug Ledford wrote:
>>> And if you argee, after this patchset has been accepted we will
>> send a
>>> following up patch :
>>>      In hns_roce_cmq_send function, replace
>>>          usleep_range(1000, 2000);
>>>      with the following statement:
>>>           udelay(1);
>>>      And if so, we can avoid using usleep_range function in
>> spin_lock_bh
>>> spin region,
>>>      because it probally cause calltrace.
>> Ok, I'm fine with that.  I'll pull these in.
> OK, these are in my tree, thanks.
Thanks a lot.

     Regards
Wei Hu
