From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 23:19:22 -0700
Message-ID: <20180523061922.GA4753@infradead.org>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
 <20180522205612.GD7502@mellanox.com>
 <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 02:04:06PM -0700, Jeff Kirsher wrote:
> > Why would you want to do this? The rdma driver is non-functional
> > without the ethernet driver, so why on earth would we want to defeat
> > the module dependency mechanism?
> 
> This change is driven by the OSV's like Red Hat, where customer's were
> updating the i40e driver, which in turn broke i40iw.

Doctor it hurts when I do this..

There is no reason to make a mess of our drivers because people are
doing things they should haver never done and that aren't supported
in Linux.

If Intel didn;t offer any out of tree drivers I'm pretty sure no
customer would even attempt this.  So fix this where the problem is.
