From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH v3] staging/rdma/hfi1: set Gen3 half-swing for
 integrated devices
Date: Fri, 20 Nov 2015 15:14:19 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259BD75C@fmsmsx120.amr.corp.intel.com>
References: <1447711429-10389-1-git-send-email-ira.weiny@intel.com>
 <20151120011215.GI11695@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151120011215.GI11695@kroah.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>, "Weiny, Ira" <ira.weiny@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "Luick,
 Dean" <dean.luick@intel.com>
List-Id: linux-rdma@vger.kernel.org

> > +	dd_dev_info(dd, "%s: program XMT margin, CcePcieCtrl 0x%llx\n",
> > +		    fname, pcie_ctrl);
> 
> Why spam the log with this all the time?  Shouldn't this be a debug line
> instead?

The current implementation is layered on dev_info().

Are you saying dev_dbg() is a better choice?

Mike
