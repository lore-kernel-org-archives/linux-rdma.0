From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/4] RDMA/cma: Add IPv6 support for iWARP.
Date: Fri, 07 Jun 2013 15:01:14 -0700 (PDT)
Message-ID: <20130607.150114.1324134043100965304.davem@davemloft.net>
References: <1370505201-29961-1-git-send-email-vipul@chelsio.com>
	<1370505201-29961-2-git-send-email-vipul@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1370505201-29961-2-git-send-email-vipul@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: vipul@chelsio.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, roland@purestorage.com, divy@chelsio.com, dm@chelsio.com, swise@opengridcomputing.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, tom@opengridcomputing.com, faisal.latif@intel.com, akpm@linux-foundation.org, sasha.levin@oracle.com
List-Id: linux-rdma@vger.kernel.org


Please use local variables for the sockaddr_in{,6} pointers instead of
casting over and over and over and over again.

Thanks.
