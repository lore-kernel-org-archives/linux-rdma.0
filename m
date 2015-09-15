From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [patch] IB/hfi1: fix copy_to/from_user() error handling
Date: Tue, 15 Sep 2015 14:01:15 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC257C176C@fmsmsx120.amr.corp.intel.com>
References: <20150915103525.GA20813@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150915103525.GA20813@mwanda>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [patch] IB/hfi1: fix copy_to/from_user() error handling
> 
> copy_to/from_user() returns the number of bytes which we were not able to
> copy.  It doesn't return an error code.
> 
> Also a couple places had a printk() on error and I removed that because
> people can take advantage of it to fill /var/log/messages with spam.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
