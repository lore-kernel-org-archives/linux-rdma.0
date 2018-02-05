From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 23/24] ibnbd: a bit of documentation
Date: Mon, 5 Feb 2018 16:16:02 +0200
Message-ID: <ce4ea220-301a-d71b-a17f-2f050c1cdfa0@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-24-roman.penyaev@profitbricks.com>
 <1517586918.2675.3.camel@wdc.com>
 <CAJrWOzCVu_UNgMxNUuf0m9szYgRP88dGepKLbtMCtZUxOW75Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJrWOzCVu_UNgMxNUuf0m9szYgRP88dGepKLbtMCtZUxOW75Vw@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Roman Penyaev <roman.penyaev@profitbricks.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "hch@infradead.org" <hch@infradead.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-rdma@vger.kernel.org


> /sys/kernel was chosen ages ago and I completely forgot to move it to configfs.
> IBTRS is not a block device, so for some read-only entries (statistics
> or states)
> something else should be probably used, not configfs.  Or it is fine
> to read state
> of the connection from configfs?  For me sounds a bit weird.

Configs go via configfs, states and alike go to sysfs (but you need your
own class device).
