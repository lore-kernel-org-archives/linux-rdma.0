From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up users of skb_tx_hash and __skb_tx_hash
Date: Sun, 29 Apr 2018 22:01:48 -0400 (EDT)
Message-ID: <20180429.220148.1239493680371983770.davem@davemloft.net>
References: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
Sender: netdev-owner@vger.kernel.org
To: alexander.h.duyck@intel.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, niranjana.vishwanathapura@intel.com, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>
Date: Fri, 27 Apr 2018 14:06:22 -0400

> I am in the process of doing some work to try and enable macvlan Tx queue
> selection without using ndo_select_queue. As a part of that I will likely
> need to make changes to skb_tx_hash. As such this is a clean up or refactor
> of the two spots where he function has been used. In both cases it didn't
> really seem like the function was being used correctly so I have updated
> both code paths to not make use of the function.
> 
> My current development environment doesn't have an mlx4 or OPA vnic
> available so the changes to those have been build tested only.

Looks good, series applied, thanks.
