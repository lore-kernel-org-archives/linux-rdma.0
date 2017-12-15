From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 0/8] Hisilicon Network Subsystem 3 VF
 Ethernet Driver
Date: Fri, 15 Dec 2017 10:55:49 -0500 (EST)
Message-ID: <20171215.105549.166620447634202.davem@davemloft.net>
References: <20171214180309.14480-1-salil.mehta@huawei.com>
        <CAOFm3uGEwqVN1zLDRBWcZ+nctqwvVbVc-5cH8wFHPs+POkvBVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOFm3uGEwqVN1zLDRBWcZ+nctqwvVbVc-5cH8wFHPs+POkvBVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: pombredanne@nexb.com
Cc: salil.mehta@huawei.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil.lnk@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 15 Dec 2017 11:28:15 +0100

> Salil,
> 
> On Thu, Dec 14, 2017 at 7:03 PM, Salil Mehta <salil.mehta@huawei.com> wrote:
>> This patch-set contains the support of the HNS3 (Hisilicon Network Subsystem 3)
>> Virtual Function Ethernet driver for hip08 family of SoCs. The Physical Function
>> driver is already part of the Linux mainline.
>>
>> This VF driver has its Hardware Compatibility Layer and has commom/unified ENET
>> layer/client/ethtool code with the PF driver. It also has support of mailbox to
>> communicate with the HNS3 PF driver. The basic architecture of VF driver is
>> derivative of the PF driver. Just like PF driver, this driver is also PCI
>> Express based.
>>
> <snip>
> 
>> Change Log Summary:
>> Patch V4: Addressed SPDX related comment by Philippe Ombredanne
>> Patch V3: Addressed SPDX change requested by Philippe Ombredanne
> 
> Thank you.
> 
> For the use of SPDX tags (and this only!) you have my cheerful ack for
> the whole patch set.
> 
> Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

Series applied.
