From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging/rdma/hfi1: Convert dd_dev_info() to hfi1_cdbg()
 in process startup
Date: Thu, 5 Nov 2015 10:58:36 +0300
Message-ID: <20151105075836.GS18797@mwanda>
References: <1446696897-25892-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1446696897-25892-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: jubin.john@intel.com
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, Sebastian Sanchez <sebastian.sanchez@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 04, 2015 at 11:14:57PM -0500, jubin.john@intel.com wrote:
> From: Sebastian Sanchez <sebastian.sanchez@intel.com>
> 
> Replacing dd_dev_info() for hfi1_cdbg() to avoid generating syslog
> output for every context that is open by PSM.
> 

Just delete it...  People get scared about deleting debug code but you
can add it back if there is really a bug.

/me chants, "delete.  delete.  delete."

regards,
dan carpenter
