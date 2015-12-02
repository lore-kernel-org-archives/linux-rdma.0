From: ira.weiny@intel.com
Subject: [PATCH v3 00/13] Fix hfi1_ioctl locking
Date: Wed,  2 Dec 2015 00:43:25 -0500
Message-ID: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
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
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

It was identified that hfi1_ioctl may sleep with a spin lock held.

This was identified publicly here:

http://www.spinics.net/lists/linux-rdma/msg29926.html

As well as by our internal development.

This series cleans up the code and parameter checks, as well as fixing the
locking.

---
Changes from v1
        Alter switch to just ignore set link state and default to return -ENOTTY
	Remove patch which introduced an intermediate bug and squash it in the
	final patch
		Series was 7 patches rather than 8

Changes from v2
	Split patch 1 (diag.c Correct code style issues) into 7 patches which
	each fix a specific checkpatch issue.
		Series is now 13 patches
	

Dennis Dalessandro (2):
  staging/rdma/hfi1: Reduce snoop locking scope in IOCTL handler.
  staging/rdma/hfi1: Return immediately on error

Ira Weiny (11):
  staging/rdma/hfi1: diag.c use BIT macros
  staging/rdma/hfi1: diag.c fix alignment
  staging/rdma/hfi1: diag.c fix logical continuations
  staging/rdma/hfi1: diag.c fix white space errors
  staging/rdma/hfi1: diag.c change null comparisons
  staging/rdma/hfi1: diag.c add missing braces
  staging/rdma/hfi1: diag.c correct sizeof parameter
  staging/rdma/hfi1: Fix camel case variables
  staging/rdma/hfi1: Return early from hfi1_ioctl parameter errors
  staging/rdma/hfi1: hfi1_ioctl remove setlink state
  staging/rdma/hfi1: Further clean up hfi1_ioctl parameter checks

 drivers/staging/rdma/hfi1/diag.c | 464 +++++++++++++++++++--------------------
 1 file changed, 220 insertions(+), 244 deletions(-)

-- 
1.8.2
