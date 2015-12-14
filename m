From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/3] staging/rdma/hfi1: consolidate kmalloc_array+memset
 into kcalloc
Date: Mon, 14 Dec 2015 21:09:54 +0300
Message-ID: <20151214180954.GZ5284@mwanda>
References: <y> <1450104189-2653-1-git-send-email-hofrat@osadl.org>
 <32E1700B9017364D9B60AED9960492BC259CD82D@fmsmsx120.amr.corp.intel.com>
 <20151214174123.GB22987@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151214174123.GB22987@osadl.at>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Nicholas Mc Guire <hofrat@osadl.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2015 at 05:41:23PM +0000, Nicholas Mc Guire wrote:
> I obviously made a real mess here.
> I incorrectly concluded that rxcontext is 0 which it is not in some cases

Yep.  Plus you build tested it but assumed that the unused variable
warning must have been there in the original...  I've done that for
static checker warnings.  Lesson learned, hopefully.

regards,
dan carpenter
