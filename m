From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Fri, 6 Nov 2015 17:05:50 -0800
Message-ID: <20151107010550.GA24666@kroah.com>
References: <1446689411-22263-1-git-send-email-ira.weiny@intel.com>
 <1446689411-22263-4-git-send-email-ira.weiny@intel.com>
 <20151105075627.GR18797@mwanda>
 <20151105170224.GB14837@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151105170224.GB14837@phlsvsds.ph.intel.com>
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
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, Vennila Megavannan <vennila.megavannan@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 12:02:25PM -0500, ira.weiny wrote:
> On Thu, Nov 05, 2015 at 10:56:27AM +0300, Dan Carpenter wrote:
> > On Wed, Nov 04, 2015 at 09:10:11PM -0500, ira.weiny@intel.com wrote:
> > > From: Vennila Megavannan <vennila.megavannan@intel.com>
> > > 
> > > Add a module paramter to toggle prescan/Fast ECN Detection.
> > > 
> > > In addition change the PRESCAN_RXQ Kconfig default to "yes".
> > > 
> > > Reviewed-by: Arthur Kepner<arthur.kepner@intel.com>
> > > Reviewed-by: Mike Marciniszyn<mike.marciniszyn@intel.com>
> > > Signed-off-by: Vennila Megavannan<vennila.megavannan@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > Hm...  In the original code we had the config entry but the code to
> > support this was actually disabled.  Now we are turning on the config
> > entry by default but the module parameter defaults to disabled.  I think
> > the documentation is a bit tricky because it should say that actually
> > enabling the config is not enough, it's still disabled.
> 
> We tried to make it clear but obviously missed the mark.
> 
> > 
> > Do we really need the config to be there?  Distros are going to enable it.
> > Who is it who wants to disable the config?
> 
> The config is maintained to be able to fully remove the code to obtain the
> maximum receive performance _if_ the customer knows that they will never need
> the prescanning.  This is the _ultimate_ in performance on this path.  We
> anticipate some HPC customers who build their own kernels may want this option.
> 
> >
> > Also is it better to
> > default to off or on for this code, what are the upsides and downsides
> > of that choice?
> > 
> 
> I'll update the commit message.  But will also explain here.
> 
> Enabling the code with the config option introduces a _slight_ performance
> impact but allows the user to determine if this congestion control fix should
> be active or not at run time.  You are correct that most distros will enable
> the config options (default Yes).  Therefore this becomes a system admin
> control item for the fabric being configured.  After testing we found that this
> was the best compromise for most systems in terms of performance and
> flexibility.  This is because prescanning is not required most of the time.
> Should a customer find that their topology and/or workload requires prescanning
> they can then enable this option at run time.  This will result in a
> significant reduction of performance at the node level but may for those
> customers result in better overall fabric/cluster performance.
> 
> So in conclusion we have 3 performance levels and the combination in this patch
> puts us at the "middle one".

Can't you just make this a dynamic thing, not a build-time thing?  No
one will rebuild their kernels (distros forbid this for obvious support
reasons), so making this work "automatically" is the best thing.  Second
best is having the ability to "tune" it by hand, but you really don't
want that.  Worse case is having a build-time option, which you chose :(

thanks,

greg k-h
