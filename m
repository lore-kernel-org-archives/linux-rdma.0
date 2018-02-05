From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 23/24] ibnbd: a bit of documentation
Date: Mon, 5 Feb 2018 14:03:35 +0100
Message-ID: <CAJrWOzCVu_UNgMxNUuf0m9szYgRP88dGepKLbtMCtZUxOW75Vw@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-24-roman.penyaev@profitbricks.com> <1517586918.2675.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517586918.2675.3.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "hch@infradead.org" <hch@infradead.org>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 2, 2018 at 4:55 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-02-02 at 15:09 +0100, Roman Pen wrote:
>> +Entries under /sys/kernel/ibnbd_client/
>> +=======================================
>> [ ... ]
>
> You will need Greg KH's permission to add new entries directly under /sys/kernel.
> Since I think that it is unlikely that he will give that permission: have you
> considered to add the new client entries under /sys/class/block for the client and
> /sys/kernel/configfs/ibnbd for the target, similar to what the NVMeOF drivers do
> today?

/sys/kernel was chosen ages ago and I completely forgot to move it to configfs.
IBTRS is not a block device, so for some read-only entries (statistics
or states)
something else should be probably used, not configfs.  Or it is fine
to read state
of the connection from configfs?  For me sounds a bit weird.

--
Roman
