From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [patch] IB/core: missing curly braces in ib_find_gid()
Date: Sat, 29 Aug 2015 21:59:15 -0700
Message-ID: <CAJ3xEMgSQHvATJjydeLQbvOXSuS1LNwvf7hs-tvmP77_EJ12BQ@mail.gmail.com>
References: <20150818092210.GE3965@mwanda>
	<20150829011040.GA2713@phlsvsds.ph.intel.com>
	<55E12EEB.9070207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <55E12EEB.9070207@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Michael Wang <yun.wang@profitbricks.com>, Yotam Kenneth <yotamke@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 28, 2015 at 9:02 PM, Doug Ledford <dledford@redhat.com> wrote:
> On 08/28/2015 09:10 PM, ira.weiny wrote:
>> On Tue, Aug 18, 2015 at 12:22:10PM +0300, Dan Carpenter wrote:
>>> Smatch says that, based on the indenting, we should probably add curly
>>> braces here.
>>>
>>> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>
> I've picked this patch up (earlier today), so I missed your reviewed-by:
> tag.  Added.

wait, Doug, when the offending patch goes upstream, their commit ID
will not be the one
denoted here, right? I would suggest that you either hold off with
this fix till the other patch
goes upstream in 4,3-rc1 and you have a proper ID or squash it there
now. BTW - the way
net-next is organized/managed, pre-linus-tree commit ID remain the
same also after they land there,
so in that respect and other linux-rdma maintenance related aspects we
discussed during LPC  - it
would be good if you can talk to Dave and see how he gets things going
for net-next

Or
