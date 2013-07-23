From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: infiniband build warning
Date: Tue, 23 Jul 2013 21:40:17 +0300
Message-ID: <CAJZOPZ+AUacLM_3u4tRMdRWOiW1=CgObwRe_3KnQCTmMgVtZRA@mail.gmail.com>
References: <20130722013758.GA14337@google.com>
	<1828884A29C6694DAF28B7E6B8A82373805BA08A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805BA08A@ORSMSX109.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Michel Lespinasse <walken@google.com>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 22, 2013 at 8:40 AM, Hefty, Sean <sean.hefty@intel.com> wrote:
>> I am seeing build warnings in drivers/infiniband/core/cma.c starting with
>> v3.11-rc1. These can be reproduced with gcc 4.6.3.
>> Would you consider applying the following fix ?

> A patch to fix this was submitted to the linux-rdma list last week.

Hi Roland,

There is a nice set of patches (IPoIB virtualization fixes, mlx5
fixes, iser patches to cope with Connect-IB no FMR, etc, etc) posted
to linux-rdma little before && after 3.11-rc1 was out, and we are @
rc2 now. I think we need to get them upstreamed around this time such
that its early enough in the cycle, makes sense?

Or.
