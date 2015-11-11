From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] staging/rdma/hfi1: set Gen3 half-swing for integrated
 devices
Date: Wed, 11 Nov 2015 10:37:08 +0300
Message-ID: <20151111073708.GY18797@mwanda>
References: <1447112288-28327-1-git-send-email-ira.weiny@intel.com>
 <20151110095929.GW18797@mwanda>
 <20151110235126.GA347@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151110235126.GA347@phlsvsds.ph.intel.com>
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

That's fine.  I feel like the first option is better because those long
names really are cumbersome.  I sometimes cut and paste bugs caused by
using really long names because it's hard to spot the differences
between two really long names which are 80% the same filler text.  (I'm
using a static checker so the checker finds the bugs and I have to stare
at it for a very long time to spot the characters which are different).

regards,
dan carpenter
