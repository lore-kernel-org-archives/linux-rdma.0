From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/rdma/hfi1: set Gen3 half-swing for integrated
 devices
Date: Thu, 5 Nov 2015 21:42:58 +0300
Message-ID: <20151105184258.GM7289@mwanda>
References: <1446689168-21620-1-git-send-email-ira.weiny@intel.com>
 <20151105073448.GQ18797@mwanda>
 <20151105164121.GA14837@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151105164121.GA14837@phlsvsds.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "ira.weiny" <ira.weiny@intel.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, Dean Luick <dean.luick@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 11:41:23AM -0500, ira.weiny wrote:
> Is this an example where we should ignore the line lengths of checkpatch to
> preserve the readability of the code?

Honestly, you can't fight checkpatch, especially in staging.  Rejecting
patches is a drain on your emotions and your energy.  We accept all
checkpatch fixes if they are half way decent.

Maybe just put a comment in the header about the full hardware name?

This patch breaks cscope and we don't end up actually using the hardware
name in the end...

regards,
dan carpenter
