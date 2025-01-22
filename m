Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4626F219FC;
	Wed, 22 Jan 2025 02:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737514387; cv=none; b=YwE/XIyTcUngpfH4KBu/vDFgf0/6Ea0oBO7h24H0jVk2340GwbfEEsO9aYeDv6f3sj6DEDqh5xYWBpX19p6YO/eNwg9VZDQtVUZ5kbg1kWCJ0Bc+R38l0YLJ5/eZXbKYfBpcSx5qqn8FFRtLGpL2b/o0oD3gTkx7jftxJqxAXs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737514387; c=relaxed/simple;
	bh=jMEZUEmyc5inTd+hFkXBvRzNFgvJvTNvNBMipEL3upg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s+7gbmcwDCxovTK/tSKbbzRQkfQKnZyB7KPSi89My5i50aNpk8L5o8MAgVKrcSs8IuovjSA3mDAH8HFlUb6NVU1pKZpRilD9ZbfQBMHRt3TUbAHeI1wCNsCjIV7aMjFRHhaum2uSMLGb/g1l5xzFTaPfg3AyvKBHqlHke6/tuJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Yd7pP6tHZzgc1c;
	Wed, 22 Jan 2025 10:49:49 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B8E1140159;
	Wed, 22 Jan 2025 10:53:01 +0800 (CST)
Received: from kwepemn100009.china.huawei.com (7.202.194.112) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Jan 2025 10:53:00 +0800
Received: from [10.67.121.59] (10.67.121.59) by kwepemn100009.china.huawei.com
 (7.202.194.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 22 Jan
 2025 10:52:58 +0800
Message-ID: <fd412ce2-ec40-fe73-6b1b-284a99a39f12@huawei.com>
Date: Wed, 22 Jan 2025 10:52:58 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 00/21] hwmon: Fix the type of 'config' in struct
 hwmon_channel_info to u64
To: Guenter Roeck <linux@roeck-us.net>, Armin Wolf <W_Armin@gmx.de>,
	<linux-hwmon@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <arm-scmi@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-rtc@vger.kernel.org>,
	<oss-drivers@corigine.com>, <linux-rdma@vger.kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <linuxarm@huawei.com>,
	<jdelvare@suse.com>, <kernel@maidavale.org>, <pauk.denis@gmail.com>,
	<james@equiv.tech>, <sudeep.holla@arm.com>, <cristian.marussi@arm.com>,
	<matt@ranostay.sg>, <mchehab@kernel.org>, <irusskikh@marvell.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <tariqt@nvidia.com>, <louis.peens@corigine.com>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <kabel@kernel.org>,
	<hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<alexandre.belloni@bootlin.com>, <krzk@kernel.org>,
	<jonathan.cameron@huawei.com>, <zhanjie9@hisilicon.com>,
	<zhenglifeng1@huawei.com>, <liuyonglong@huawei.com>
References: <20250121064519.18974-1-lihuisong@huawei.com>
 <03b138e9-688f-4ebc-bd01-3d54fd20e525@gmx.de>
 <9add68ac-7d10-4011-9da8-1f2de077d3e9@roeck-us.net>
From: "lihuisong (C)" <lihuisong@huawei.com>
In-Reply-To: <9add68ac-7d10-4011-9da8-1f2de077d3e9@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemn100009.china.huawei.com (7.202.194.112)

Hi Guenter,

在 2025/1/21 22:50, Guenter Roeck 写道:
> On 1/21/25 06:12, Armin Wolf wrote:
>> Am 21.01.25 um 07:44 schrieb Huisong Li:
>>
>>> The hwmon_device_register() is deprecated. When I try to repace it with
>>> hwmon_device_register_with_info() for acpi_power_meter driver, I 
>>> found that
>>> the power channel attribute in linux/hwmon.h have to extend and is more
>>> than 32 after this replacement.
>>>
>>> However, the maximum number of hwmon channel attributes is 32 which is
>>> limited by current hwmon codes. This is not good to add new channel
>>> attribute for some hwmon sensor type and support more channel 
>>> attribute.
>>>
>>> This series are aimed to do this. And also make sure that 
>>> acpi_power_meter
>>> driver can successfully replace the deprecated hwmon_device_register()
>>> later.
>>
>
> This explanation completely misses the point. The series tries to make 
> space
> for additional "standard" attributes. Such a change should be independent
> of a driver conversion and be discussed on its own, not in the context
> of a new driver or a driver conversion.
Making space for new attributes later.
After all hwmon core have ability to do that.
>
>> Hi,
>>
>> what kind of new power attributes do you want to add to the hwmon API?
>>
>> AFAIK the acpi-power-meter driver supports the following attributes:
>>
>>      power1_accuracy            -> HWMON_P_ACCURACY
>>      power1_cap_min            -> HWMON_P_CAP_MIN
>>      power1_cap_max            -> HWMON_P_CAP_MAX
>>      power1_cap_hyst            -> HWMON_P_CAP_HYST
>>      power1_cap            -> HWMON_P_CAP
>>      power1_average            -> HWMON_P_AVERAGE
>>      power1_average_min        -> HWMON_P_AVERAGE_MIN
>>      power1_average_max        -> HWMON_P_AVERAGE_MAX
>>      power1_average_interval        -> HWMON_P_AVERAGE_INTERVAL
>>      power1_average_interval_min    -> HWMON_P_AVERAGE_INTERVAL_MIN
>>      power1_average_interval_max    -> HWMON_P_AVERAGE_INTERVAL_MAX
>>      power1_alarm            -> HWMON_P_ALARM
>>      power1_model_number
>>      power1_oem_info
>>      power1_serial_number
>>      power1_is_battery
>>      name                -> handled by hwmon core
>>
>> The remaining attributes are in my opinion not generic enough to add 
>> them to the generic
>> hwmon power attributes. I think you should implement them as a 
>> attribute_group which can
>> be passed to hwmon_device_register_with_info() using the 
>> "extra_groups" parameter.
>>
>
> I absolutely agree. More specifically, it looks like this is about the 
> following
> attributes.
>
> >      power1_model_number
> >      power1_oem_info
> >      power1_serial_number
> >      power1_is_battery
>
> Those are not hwmon attributes and should not be (or have been) exposed
> as sysfs attributes in the first place, but (if really wanted/needed)
> through debugfs files. Even _if_ exposed as sysfs attributes they should
> not have the power1_ prefix (except maybe for the last one).
I plan to accept the suggestion Armin proposed that acpi_power_meter can 
use the "extra_groups" parameter for these "not generic hwmon power 
attributes".
Should we drop the power1_ prefix? But this will lead to the change of 
these attributes.
Do you mean 'power1_is_battery' can be added to hwmon power attributes 
in hwmon.h?
>
> On top of that, doubling the size of configuration bits for everything
> because one sensor type needs more than 32 bits seems excessive.
> If we ever get to that point I think I'd rather introduce a second
> sensor type for power sensor attributes.
>
The bigest obstacle is that drivers which not use HWMON_CHANNEL_INFO 
hwmon provided need to be modifyed.🙁
>
> .
