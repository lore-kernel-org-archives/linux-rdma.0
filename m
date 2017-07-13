From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] IB/cxgb3: Fix error codes in iwch_alloc_mr()
Date: Thu, 13 Jul 2017 09:35:48 -0500
Message-ID: <005801d2fbe5$5193d0d0$f4bb7270$@opengridcomputing.com>
References: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
Content-Language: en-us
Sender: kernel-janitors-owner@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>, 'Steve Wise' <swise@chelsio.com>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> We accidentally don't set the error code on some error paths.  It means
> return ERR_PTR(0) which is NULL and results in a NULL dereference in the
> caller.
> 
> Fixes: 13a239330abd ("RDMA/cxgb3: Don't ignore insert_handle() failures")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Acked-by: Steve Wise <swise@opengridcomputing.com>

