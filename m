From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V1 net-next] IB/ipoib: Fix ndo_get_iflink
Date: Mon, 20 Apr 2015 12:27:54 -0400 (EDT)
Message-ID: <20150420.122754.195978139684006950.davem@davemloft.net>
References: <1429191274-11600-1-git-send-email-erezsh@mellanox.com>
	<20150417.152133.1818018053733533978.davem@davemloft.net>
	<5534B5E2.6060804@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5534B5E2.6060804@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: haggaie@mellanox.com
Cc: dledford@redhat.com, roland@kernel.org, erezsh@mellanox.com, netdev@vger.kernel.org, nicolas.dichtel@6wind.com, linux-rdma@vger.kernel.org, honli@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Haggai Eran <haggaie@mellanox.com>
Date: Mon, 20 Apr 2015 11:16:34 +0300

> On 17/04/2015 22:21, David Miller wrote:
>> From: Erez Shitrit <erezsh@mellanox.com>
>> Date: Thu, 16 Apr 2015 16:34:34 +0300
>> 
>>> Currently, iflink of the parent interface was always accessed, even 
>>> when interface didn't have a parent and hence we crashed there.
>>>
>>> Handle the interface types properly: for a child interface, return
>>> the ifindex of the parent, for parent interface, return its ifindex.
>>>
>>> For child devices, make sure to set the parent pointer prior to
>>> invoking register_netdevice(), this allows the new ndo to be called
>>> by the stack immediately after the child device is registered.
>>>
>>> Fixes: 5aa7add8f14b ('infiniband/ipoib: implement ndo_get_iflink')
>>> Reported-by: Honggang Li <honli@redhat.com>
>>> Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
>>> Signed-off-by: Honggang Li <honli@redhat.com>
>> 
>> Applied, thanks.
> 
> Doug, Roland,
> 
> You might want to include this patch in your for-next / for-4.1 trees,
> or merge net-next again. Currently they contain the issue it fixes, and
> it can prevent some systems with IPoIB from booting.

I put this into 'net', not 'net-next'.  'net-next' is dormant after I do
my first push to Linus of the merge window.  After that everything goes
via 'net' until the merge window closes and I open 'net-next' up again.
