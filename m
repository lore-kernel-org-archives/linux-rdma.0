From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] IB/hfi1: class_name_user() should be static
Date: Mon, 21 Sep 2015 22:18:14 +0800
Message-ID: <3fc89a14df9bdee0d0eaba7031e533e4f88fc5c6.1442844831.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes the following sparse warning:
  drivers/staging/rdma/hfi1/device.c:127:12:
  warning: symbol 'class_name_user' was not declared. Should it be static?

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/hfi1/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/staging/rdma/hfi1/device.c
index bc26a53..58472e5 100644
--- a/drivers/staging/rdma/hfi1/device.c
+++ b/drivers/staging/rdma/hfi1/device.c
@@ -124,7 +124,7 @@ static char *hfi1_devnode(struct device *dev, umode_t *mode)
 }
 
 static const char *hfi1_class_name_user = "hfi1_user";
-const char *class_name_user(void)
+static const char *class_name_user(void)
 {
 	return hfi1_class_name_user;
 }
-- 
2.5.0
