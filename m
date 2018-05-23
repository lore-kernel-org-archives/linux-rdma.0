From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 23:20:24 -0700
Message-ID: <20180523062024.GB4753@infradead.org>
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
Cc: Jason Gunthorpe <jgg@mellanox.com>, davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 02:50:32PM -0700, Jeff Kirsher wrote:
> The ABI rarely changes, if at all.  The issue OSV's are seeing is that
> upgrading i40e, requires that i40iw be recompiled even though there
> were no updates/changes to the ABI.

So fscking what.  If you upgrade one part of the kernel you have to
rebuild anbything.  If people try to get away without that that is
their problem, an certainly not something in any way supported by
Linux.
