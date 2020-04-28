Return-Path: <SRS0=o1Ax=6M=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5C6C83000
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 08:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74426206D7
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Apr 2020 08:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD1IAt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:00:49 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbgD1IAt (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 28 Apr 2020 04:00:49 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 775114EBC60F729861DD;
        Tue, 28 Apr 2020 16:00:47 +0800 (CST)
Received: from DGGEML522-MBX.china.huawei.com ([169.254.7.242]) by
 DGGEML401-HUB.china.huawei.com ([fe80::89ed:853e:30a9:2a79%31]) with mapi id
 14.03.0487.000; Tue, 28 Apr 2020 16:00:30 +0800
From:   liweihang <liweihang@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "devesh.sharma@broadcom.com" <devesh.sharma@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "sleybo@amazon.com" <sleybo@amazon.com>,
        "faisal.latif@intel.com" <faisal.latif@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "neescoba@cisco.com" <neescoba@cisco.com>,
        "pkaustub@cisco.com" <pkaustub@cisco.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "monis@mellanox.com" <monis@mellanox.com>,
        "kamalheib1@gmail.com" <kamalheib1@gmail.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "markz@mellanox.com" <markz@mellanox.com>,
        "rd.dunlab@gmail.com" <rd.dunlab@gmail.com>,
        "dennis.dalessandro@intel.com" <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next] RDMA/core: Assign the name of device when
 allocating ib_device
Thread-Topic: [PATCH for-next] RDMA/core: Assign the name of device when
 allocating ib_device
Thread-Index: AQHWG62Z7/BNGudzR0CivwFowafwZQ==
Date:   Tue, 28 Apr 2020 08:00:29 +0000
Message-ID: <B82435381E3B2943AA4D2826ADEF0B3A0232A133@DGGEML522-MBX.china.huawei.com>
References: <1587893517-11824-1-git-send-email-liweihang@huawei.com>
 <20200427114734.GC134660@unreal> <20200427115201.GN26002@ziepe.ca>
 <20200427120337.GD134660@unreal>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.40.168.149]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2020/4/27 20:03, Leon Romanovsky wrote:
>>>>  /**
>>>>   * _ib_alloc_device - allocate an IB device struct
>>>>   * @size:size of structure to allocate
>>>> + * @name: unique string device name. This may include a '%' which will
>>> It looks like all drivers are setting "%" in their name and "name" can
>>> be changed to be "prefix".
>> Does hfi? I thought the name was forced there for some port swapped
>> reason?
> This patch doesn't touch HFI, nothing prohibits from us to make this
> conversion work for all drivers except HFI and for the HFI add some
> different callback. There is no need to make API harder just because
> one driver needs it.
> 
> Thanks
> 
>> Jason

Hi Jason and Leon,

I missed some codes related to assign_name() in this series including
hfi/qib as Shiraz pointed. And I found a "name" without a "%" in following
funtions in core/nldev.c, and ibdev_name will be used for rxe/siw later.

	static int nldev_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
				  struct netlink_ext_ack *extack)
	{
		...
	
		nla_strlcpy(ibdev_name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
			    sizeof(ibdev_name));
		if (strchr(ibdev_name, '%') || strlen(ibdev_name) == 0)
			return -EINVAL;
	
		...
	}

I'm not familiar with these codes, but I think the judgment in assign_name()
is for the situaion like above.

	if (strchr(name, '%'))
		ret = alloc_name(device, name);
	else
		ret = dev_set_name(&device->dev, name);

So is it a better idea to keep using "name" instead of "prefix"?

Thanks
Weihang
