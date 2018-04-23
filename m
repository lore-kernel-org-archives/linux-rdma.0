From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH for-rc] uapi: Fix SPDX tags for files referring to the
 'OpenIB.org' license
Date: Sun, 22 Apr 2018 21:08:23 -0400 (EDT)
Message-ID: <20180422.210823.1454088204642743739.davem@davemloft.net>
References: <20180420154910.GA2519@ziepe.ca>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420154910.GA2519@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@mellanox.com
Cc: linux-rdma@vger.kernel.org, kstewart@linuxfoundation.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, tglx@linutronix.de, swinslow@linuxfoundation.org, santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davejwatson@fb.com
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>
Date: Fri, 20 Apr 2018 09:49:10 -0600

> Based on discussion with Kate Stewart this license is not a
> BSD-2-Clause, but is now formally identified as Linux-OpenIB
> by SPDX.
> 
> The key difference between the licenses is in the 'warranty'
> paragraph.
> 
> if_infiniband.h refers to the 'OpenIB.org' license, but
> does not include the text, instead it links to an obsolete
> web site that contains a license that matches the BSD-2-Clause
> SPX. There is no 'three clause' version of the OpenIB.org
> license.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Acked-by: David S. Miller <davem@davemloft.net>
