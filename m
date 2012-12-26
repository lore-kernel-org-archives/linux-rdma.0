From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] IB/rds: suppress incompatible protocol when
 version is known
Date: Wed, 26 Dec 2012 15:18:10 -0800 (PST)
Message-ID: <20121226.151810.1691248733680271193.davem@davemloft.net>
References: <20121221175857.23716.46975.stgit@phlsvslse11.ph.intel.com>
	<20121221180154.23716.44540.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20121221180154.23716.44540.stgit@phlsvslse11.ph.intel.com>
Sender: netdev-owner@vger.kernel.org
To: mike.marciniszyn@intel.com
Cc: venkat.x.venkatsubra@oracle.com, linux-rdma@vger.kernel.org, roland@kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Date: Fri, 21 Dec 2012 13:01:54 -0500

> Add an else to only print the incompatible protocol message
> when version hasn't been established.
> 
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Applied.
