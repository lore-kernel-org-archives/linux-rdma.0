From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] IB/hfi1: info leak in get_ctxt_info()
Date: Wed, 16 Sep 2015 09:42:25 +0300
Message-ID: <20150916064225.GI5004@mwanda>
References: <alpine.DEB.2.02.1509160824370.2049@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1509160824370.2049@localhost6.localdomain6>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

The cinfo struct has a hole after the last struct member so we need to
zero it out.  Otherwise we disclose some uninitialized stack data.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: typo in changelog

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 4698617..2c43ca5 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1181,6 +1181,7 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 	struct hfi1_filedata *fd = fp->private_data;
 	int ret = 0;
 
+	memset(&cinfo, 0, sizeof(cinfo));
 	ret = hfi1_get_base_kinfo(uctxt, &cinfo);
 	if (ret < 0)
 		goto done;
