From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/rdma/hfi1: Convert dd_dev_info() to hfi1_cdbg()
 in process startup
Date: Thu, 5 Nov 2015 17:53:34 +0300
Message-ID: <20151105145334.GY18797@mwanda>
References: <1446696897-25892-1-git-send-email-jubin.john@intel.com>
 <20151105075836.GS18797@mwanda>
 <20151105145119.GA16285@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151105145119.GA16285@phlsvsds.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org, jubin.john@intel.com, dledford@redhat.com, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 09:51:20AM -0500, Dennis Dalessandro wrote:
> >/me chants, "delete.  delete.  delete."
> 
> I would tend to agree with that, but in this case we want to keep a
> way to get this information without making code changes. We just
> don't want it to spew to the console/syslog all the time. Instead we
> are using the trace mechanism which lets the user selectively turn
> on the messages when needed.
> 
> Perhaps we should expand on the commit message to make this more clear?
> 

No no.  It's fine.  So long as you aren't just keeping it around because
you are afraid to delete things.

regards,
dan carpenter
