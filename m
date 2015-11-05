From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/rdma/hfi1: set Gen3 half-swing for integrated
 devices
Date: Thu, 5 Nov 2015 10:34:48 +0300
Message-ID: <20151105073448.GQ18797@mwanda>
References: <1446689168-21620-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1446689168-21620-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ira.weiny@intel.com
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, Dean Luick <dean.luick@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 04, 2015 at 09:06:08PM -0500, ira.weiny@intel.com wrote:

> +#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK 0x1ull

There is absolutely no point to having a variable name which is nine
bajillion characters long since we are not able to use it and have to
instead use macro majic to hide the first twelve zillion characters.  If
we can't even see the name when it is used, then why does it exist? Also
macro magic breaks grep and cscope.  Just think of a better name to
begin with and get rid of the PC macro.

regards,
dan carpenter
