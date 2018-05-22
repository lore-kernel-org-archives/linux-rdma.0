From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 15:54:49 -0600
Message-ID: <20180522215449.GG7502@mellanox.com>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
 <20180522205612.GD7502@mellanox.com>
 <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
 <20180522213334.GE7502@mellanox.com>
 <2fcc22b088fd04dafbdc1582d03c4bca21eefade.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2fcc22b088fd04dafbdc1582d03c4bca21eefade.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 02:50:32PM -0700, Jeff Kirsher wrote:
> On Tue, 2018-05-22 at 15:33 -0600, Jason Gunthorpe wrote:
> > On Tue, May 22, 2018 at 02:04:06PM -0700, Jeff Kirsher wrote:
> > > On Tue, 2018-05-22 at 14:56 -0600, Jason Gunthorpe wrote:
> > > > On Tue, May 22, 2018 at 01:38:31PM -0700, Jeff Kirsher wrote:
> > > > > From: Sindhu Devale <sindhu.devale@intel.com>
> > > > > 
> > > > > Currently i40iw is dependent on i40e symbols
> > > > > i40e_register_client and i40e_unregister_client due to
> > > > > which i40iw cannot be loaded without i40e being loaded.
> > > > > 
> > > > > This patch allows RDMA driver to build and load without
> > > > > linking to LAN driver and without LAN driver being loaded
> > > > > first. Once the LAN driver is loaded, the RDMA driver
> > > > > is notified through the netdevice notifiers to register
> > > > > as client to the LAN driver. Add function pointers to IDC
> > > > > register/unregister in the private VSI structure. This
> > > > > allows a RDMA driver to build without linking to i40e.
> > > > 
> > > > Why would you want to do this? The rdma driver is non-functional
> > > > without the ethernet driver, so why on earth would we want to
> > > > defeat
> > > > the module dependency mechanism?
> > > 
> > > This change is driven by the OSV's like Red Hat, where customer's
> > > were
> > > updating the i40e driver, which in turn broke i40iw.
> > 
> > So that isn't a reason to put something into the main line kernel,
> > and
> > I'm deeply skeptical this change is even sane.
> > 
> > It has been a while since I've looked at RH's kernel, but AFAIK,
> > breakage should only happen if the ABIs around
> > i40e_unregister_client/etc change..
> > 
> > So if the i40e module updates breaks the ABI, then stuffing that same
> > broken ABI through a function pointer is *totally* wrong.
> > 
> > Looks like a NAK for the RDMA side.
> 
> The ABI rarely changes, if at all.  The issue OSV's are seeing is that
> upgrading i40e, requires that i40iw be recompiled even though there
> were no updates/changes to the ABI.

Why does it need recompiling? Details please.

Jason
