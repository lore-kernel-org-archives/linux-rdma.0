From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] staging/rdma/hfi1: set Gen3 half-swing for integrated
 devices
Date: Tue, 10 Nov 2015 12:59:29 +0300
Message-ID: <20151110095929.GW18797@mwanda>
References: <1447112288-28327-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1447112288-28327-1-git-send-email-ira.weiny@intel.com>
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

Gar...  No.  Please please get rid of the PC() macro.  It makes the code
impossible to understand because instead of hitting CTRL-[ you have
decode it and then manually type out

:cs find g CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT

which is the length of a typical college essay.  I meant just put a
comment like this:

/*
 * In the hardware spec these are prefixed with:
 * CCE_PCIE_CTRL_...
 * But it is too long to use in code.
 */
#define XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK 0x1ull

Or probably even better:

#define CCE_PCIE_CTRL (CCE + 0x0000000000C0)
#define LANE_BUNDLE_MASK	0x3ull /* CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_MASK */
#define LANE_BUNDLE_SHIFT	0      /* CCE_PCIE_CTRL_PCIE_LANE_BUNDLE_SHIFT */
#define LANE_DELAY_MASK		0xFull /* CCE_PCIE_CTRL_PCIE_LANE_DELAY_MASK */
#define LANE_DELAY_SHIFT	2      /* CCE_PCIE_CTRL_PCIE_LANE_DELAY_SHIFT */
#define MARGIN_OVERWRITE_SHIFT	8      /* CCE_PCIE_CTRL_XMT_MARGIN_OVERWRITE_ENABLE_SHIFT */
#define MARGIN_SHIFT		9      /* CCE_PCIE_CTRL_XMT_MARGIN_SHIFT */
#define MARGIN_G1G2_OVERWRITE_MASK 0x1ull /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK */
#define MARGIN_G1G2_OVERWRITE_SHIFT 12    /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_SHIFT */
#define MARGIN_G1G2_MASK	0x7ull /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_MASK */
#define MARGIN_G1G2_SHIFT	13     /* CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_SHIFT */

Those lines go over the 80 character limit but it's fine.

regards,
dan carpenter
