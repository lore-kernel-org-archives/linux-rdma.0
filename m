From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: linux-next: Tree for Apr 17 (infiniband/rdma)
Date: Wed, 17 Apr 2013 21:15:54 +0300
Message-ID: <CAJZOPZJHJ0qKJo=HyEiJq1rRPXg+8bNh+8U_2WhX6FKbE2Km7A@mail.gmail.com>
References: <20130417170450.5dd6e5f450de4d5bf197d997@canb.auug.org.au>
	<516EE4BD.3000200@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <516EE4BD.3000200@infradead.org>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 17, 2013 at 9:06 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/17/13 00:04, Stephen Rothwell wrote:
>> Changes since 20130416:

> on x86_64:
> drivers/built-in.o: In function `isert_free_np':
> ib_isert.c:(.text+0x6e8a77): undefined reference to `rdma_destroy_id'
[...]

Nic,

Yep, you need to add

depends on INET &&  INFINIBAND_ADDR_TRANS


to the isert Kconfig entry


This will make sure to get the rdma_cm to be configured and builts
whenever isert is

Or.
