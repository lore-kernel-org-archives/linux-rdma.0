From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/3] Initial conversions over to dst_neigh_lookup()
Date: Tue, 24 Jan 2012 18:15:47 -0500 (EST)
Message-ID: <20120124.181547.254158756396281234.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: roland@kernel.org
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


We'll be moving to a model wherein dst_entry route objects do not
have a precomputed neighbour entry attached to them, instead they
are looked up efficiently on an as-needed basis.

Most of the covnersions consist of simply using dst_neigh_lookup() to
find the neigh (using dst_entry and IPV4/IPV6 destination address as
the necessary arguments) and then explicitly releasing the neigh entry
once we are with it.

I intend to toss these into net-next, thanks.
