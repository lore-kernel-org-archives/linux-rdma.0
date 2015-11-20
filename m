From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: HFI1 code duplication todo
Date: Sat, 21 Nov 2015 01:25:23 +0300
Message-ID: <20151120222523.GX18797@mwanda>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com>
 <564F3F1C.4020508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <564F3F1C.4020508@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 10:41:16AM -0500, Doug Ledford wrote:
> So, as to the hfi1/qib/rxe transport library.  The qib driver is in the
> rdma tree, and we aren't going to move it to staging just because it
> depends on something in staging, so we need to start adding the library
> in the core tree to avoid dependency issues.  As for the hfi1 driver,
> I'm of the opinion that putting it in staging because of the code
> duplication issue was probably not the right thing to do.  It's
> benefited from the extra eyes on it to help make it a better driver, but
> I think I'm ready to move it to the main RDMA tree and start working on
> it from there where there won't be any cross tree dependency issues.

You could leave it staging but manage it from the same git tree.  It
avoids the cross tree dependencies.  This is what we do for
drivers/staging/media/, all that stuff goes through the linux-media
tree.

regards,
dan carpenter
