From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: BUG: NULL pointer dereference at ib_uverbs_comp_handler+0x20
Date: Tue, 1 Aug 2017 12:35:07 -0600
Message-ID: <39424775-e5e9-c29f-7375-1ae9d35e4685@deltatee.com>
References: <216b770e-fc08-68a6-c1bf-be96d52e325e@deltatee.com>
 <CAAKD3BDFcFDVvYYsimAqqWM9w-qv0Nc4U5Y54eGNhOATSkg0tA@mail.gmail.com>
 <20170801123017.GA19657@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170801123017.GA19657@chelsio.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>, Matan Barak <matanb@dev.mellanox.co.il>
Cc: Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stephen Bates <sbates@raithlin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hey,

On 01/08/17 06:30 AM, Potnuri Bharat Teja wrote:
> Hi Logan,
> Today I sent out a patch to address the issue. Please try it.
> "[PATCH 1/1] RDMA/uverbs: Initialize cq_context appropriately"

Thanks, as I mentioned in my other email this fixes the kernel panic on
the T6 but doesn't solve all my problems. You can add a

Tested-by: Logan Gunthorpe <logang@deltatee.com>

Logan
