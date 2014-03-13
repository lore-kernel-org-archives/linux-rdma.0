From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [Patch 1/2] IB/mlx5: Implementation of PCI error handler
Date: Thu, 13 Mar 2014 17:40:02 +0200
Message-ID: <20140313154002.GA28066@mtldesk30>
References: <20140312034219.637916521@linux.vnet.ibm.com>
 <20140312034512.065218504@linux.vnet.ibm.com>
 <1394649252.23624.36.camel@deadeye.wl.decadent.org.uk>
 <20140313064521.GH20224@mtldesk30>
 <5321CAD3.2070301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5321CAD3.2070301@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: Carol Soto <clsoto@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, eli@mellanox.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, brking@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 13, 2014 at 10:12:19AM -0500, Carol Soto wrote:
> 
> In mlx4 code, I do not recall a timeout for commands this big. So
> the reason in mlx5 is 2 hrs is just for
> debugging purposes? So if for any reason a command hang then the
> user can not remove this module
> for the next 2 hrs?
> 
Hi Carol,
well I haven't seen any such case with latest firmware releases.
Anyway, 10 msec is really too short timeout value since there are
commands that can take more than that (e.g. memory registartion of
regions larger then 512 MB - though this will be changed soon). I
wonder what was the original motivation and have you been able to
simulate PCI errors and see this in action.
