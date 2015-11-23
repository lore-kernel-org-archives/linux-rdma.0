From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 3/3] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Sun, 22 Nov 2015 18:41:48 -0800
Message-ID: <20151123024148.GA11706@kroah.com>
References: <1447112084-12532-1-git-send-email-ira.weiny@intel.com>
 <20151120005444.GA32083@kroah.com>
 <20151123021501.GC3304@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151123021501.GC3304@phlsvsds.ph.intel.com>
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
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, Vennila Megavannan <vennila.megavannan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 09:15:02PM -0500, ira.weiny wrote:
> On Thu, Nov 19, 2015 at 04:54:44PM -0800, Greg KH wrote:
> > On Mon, Nov 09, 2015 at 06:34:44PM -0500, ira.weiny@intel.com wrote:
> > > From: Vennila Megavannan <vennila.megavannan@intel.com>
> > > 
> > > Add a module paramter to toggle prescan/Fast ECN Detection and remove the
> > > Kconfig option which used to control this.
> > 
> > Ick, no, not a module parameter, that's horrid (hint, it isn't a
> > per-device option...)
> 
> This is a good point.  Previous to this patch we had a compile time option
> which would have affected all devices and I think we just continued that.  I do
> like the idea of making this per port.  I will respin the patch.
> 
> However, I want to be clear on your hint.  Are you saying that sysfs would be a
> better place to put such a flag?

Maybe, if you want it per-device, but really, you don't want to have any
"knobs" a user has to tune.

> > Why can't you do this dynamically?
> 
> ECN is always on.  The key is the reaction time of the individual port.
> Attempting to turn this on and off would affect both the reaction time and the
> processing time in a negative way.
> 
> > Why would anyone ever want to make this "slow"?
> 
> This is a tuning nob for over all fabric performance not individual node
> performance.  ECN controls congestion spreading through the network as is
> explained in this paper.
> 
> http://infocom2003.ieee-infocom.org/papers/28_01.PDF
> 
> As is shown in figure 1 and 2 of that paper congestion at node Bc is affecting
> traffic at node Bv.  The default reaction time of ECN is likely to be
> sufficient for most users based on our experience so far.
> 
> However, should a particular network see system wide degradation, this option
> can be turned on to increase the reaction time at node Bc.  However, node Bc is
> already overloaded so the trade off is likely acceptable.
> 
> Unfortunately, it is hard to predict when a user may need this option as we
> don't have the resources to build extreme scale fabrics for testing.  Nor do we
> know all users workloads or the fabric topologies those workloads may be
> running on.
> 
> We developed the code which this option enables based on lab experiments.  So
> we need this to be an option available to users.

Ok, then make it able to be a per-device option, through sysfs, and
choose the "best" option to set it to be as the default.

thanks,

greg k-h
