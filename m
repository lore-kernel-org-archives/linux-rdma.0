From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 2/5] irq-am: add some debugfs exposure on tuning state
Date: Mon, 12 Feb 2018 21:42:56 +0200
Message-ID: <0feb8bda-5334-6415-89ac-9791f6d29103@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
 <20180205220316.30236-3-sagi@grimberg.me> <1518053080.2870.93.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1518053080.2870.93.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "idanb@mellanox.com" <idanb@mellanox.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-rdma@vger.kernel.org


>> +static int irq_am_register_debugfs(struct irq_am *am)
>> +{
>> +	char name[20];
>> +
>> +	snprintf(name, sizeof(name), "am%u", am->id);
>> +	am->debugfs_dir = debugfs_create_dir(name,
>> +				irq_am_debugfs_root);
> 
> How is a user expected to figure out which driver am%u is associated with?
> Please make sure that these directories have a name that makes it easy for
> users to figure out what driver the moderation settings apply to.

You're right... It was just for me for local debugging at this point and
had every intention to get the debugfs into shape once I collect an
initial round of reviews.
