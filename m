Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66C71DED5C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Feb 2026 06:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770879180; cv=none; b=nPvSJJn/7BQhmLCPFizgxeOia6TZAf1/T93tLMAw1O7/LiiZaXJvmxTi+ypo7c7wfdj58CuQv1zcIc8xbkaYflw50QhIZweGWVoQ4FgdkLUIE0qgljf+fxoe/BR8Dv1yNhn2ORUb0VFrAXSK9IyHMk0rwrn26CUKFUivVbscrJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770879180; c=relaxed/simple;
	bh=CbpLpNN5wfeJcXegEF/e67sBpIetlZClp3lL09lxafc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pX4IaYdfS1dHBbQh6eMJ7Hf9spxdQwzhVh/aSpQjofqya9ZwCa7c8bAXz+CLs/JZIL5BdrGR810noFaOvZFnYXQX8FFCTJpewhGxS838YEXaoajYbcpJ+02XmEzx+DKs9v/u1tgRsvWKcN94nXDXvZSatdq01wkg5Eyraq1mkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TWv3yRuf; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TWv3yRuf"
Message-ID: <ef07b718-0198-4f8c-86c1-56149c7fd239@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770879176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IohK9R4CIwFlOy8fUFFaLBzoXEmG7dWkV4tj9GLeH4U=;
	b=TWv3yRuf36SEqJfVrwOgeKzvAvG0+L6l89JtiZgNdzyXCDktAA/5T13xs+41FW5JMcTAAL
	Vv+vravNThCzLKEbRJ1wLEnmmyLeYLu+FSkJyEts9m7bdu7C2hILSLF+Ks1a/SuL8JkXZ3
	SWgxfroYWkS8ANUBvgAmISwwzint+xw=
Date: Thu, 12 Feb 2026 08:52:41 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH for-next] RDMA/efa: Add AH usage counter with sysfs
 exposure
To: Jason Gunthorpe <jgg@nvidia.com>, Tom Sela <tomsela@amazon.com>
Cc: mrgolin@amazon.com, leon@kernel.org, linux-rdma@vger.kernel.org,
 sleybo@amazon.com, matua@amazon.com, Yonatan Nachum <ynachum@amazon.com>
References: <20260211131048.36217-1-tomsela@amazon.com>
 <20260211131338.GA1218606@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Gal Pressman <gal.pressman@linux.dev>
Content-Language: en-US
In-Reply-To: <20260211131338.GA1218606@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 11/02/2026 15:13, Jason Gunthorpe wrote:
> On Wed, Feb 11, 2026 at 01:10:48PM +0000, Tom Sela wrote:
>> +static ssize_t ah_count_show(struct device *dev, struct device_attribute *attr, char *buf)
>> +{
>> +	struct efa_dev *efa_dev = pci_get_drvdata(to_pci_dev(dev));
>> +
>> +	return sysfs_emit(buf, "%lld\n", atomic64_read(&efa_dev->ah_count));
>> +}
>> +
>> +static DEVICE_ATTR_RO(ah_count);
>> +
>> +int efa_sysfs_init(struct efa_dev *dev)
>> +{
>> +	struct device *device = &dev->pdev->dev;
>> +
>> +	if (device_create_file(device, &dev_attr_ah_count))
>> +		dev_err(device, "Failed to create AH count sysfs file\n");
> 
> This is not the right way to use sysfs in rdma drivers.
> 
> Also we have netlink counters as the prefered approach why are you
> using sysfs?

Yes, and EFA already supports stats reporting, the sysfs choice is strange..

BTW, isn't this something that can be added to restrack?
