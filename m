From: Roland Dreier <roland@kernel.org>
Subject: Re: [patch] IB/qib: fix a do nothing for loop
Date: Fri, 20 Feb 2015 09:04:30 -0800
Message-ID: <CAL1RGDWFtMaKwnLWpkoFNWOkZwqGkOg-5XP0d5pEDCncD2QZQQ@mail.gmail.com>
References: <20150220105600.GE7895@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150220105600.GE7895@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 20, 2015 at 2:56 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We accidentally deleted a semi-colon here and changed this do-nothing
> loop into a do-something loop.


Thanks!  I folded this into the original "cleanup" patch.
