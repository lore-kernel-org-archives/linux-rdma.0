From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/cma: Make CM response timeout and # CM retries
 configurable
Date: Fri, 12 Apr 2019 16:30:24 -0300
Message-ID: <20190412193024.GB4690@ziepe.ca>
References: <20190217170909.1178575-1-haakon.bugge@oracle.com>
 <20190222163637.GA9819@ziepe.ca>
 <afadc799-b547-5c20-64d2-75fa0f64cd9e@opengridcomputing.com>
 <C7922E85-CA43-479A-8021-DADD59FF5BE7@redhat.com>
 <20190223084930.GJ23561@mtr-leonro.mtl.com>
 <VI1PR0501MB2271E8A704DD21EF81C7DC24D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB2271E8A704DD21EF81C7DC24D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Steve Wise <swise@opengridcomputing.com>, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 04, 2019 at 06:27:26AM +0000, Parav Pandit wrote:

> I think we should use rdma_nl_register(RDMA_NL_RDMA_CM, cma_cb_table) which was removed as part of ID stats removal.
> Because of below reasons.
> 1. rdma netlink command auto loads the module

This is probably the best argument to stay away from sysctl for module
parameters.. It is tricky to make sure the rdma module is loaded
before sysctl runs in boot, and I don't think sysctl autoloads missing
modules, or somehow copes with dynamic module loading, does it?

To that end we should probably have the entire sysctl configurable
available in netlink

Jason
