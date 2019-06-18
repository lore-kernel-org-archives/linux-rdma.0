From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
Date: Tue, 18 Jun 2019 10:40:37 -0700 (PDT)
Message-ID: <20190618.104037.359105025150148890.davem@davemloft.net>
References: <20190617085341.51592-4-dkirjanov@suse.com>
        <20190618.100801.2026737630386139646.davem@davemloft.net>
        <bd0b0a87b8bc459e172ad9396931bb69697da6c9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bd0b0a87b8bc459e172ad9396931bb69697da6c9.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com
Cc: kda@linux-powerpc.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

From: Doug Ledford <dledford@redhat.com>
Date: Tue, 18 Jun 2019 13:29:59 -0400

> On Tue, 2019-06-18 at 10:08 -0700, David Miller wrote:
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Date: Mon, 17 Jun 2019 10:53:41 +0200
>> 
>> > in IPoIB case we can't see a VF broadcast address for but
>> > can see for PF
>> 
>> I just want to understand why this need to see the VF broadcast
>> address is IPoIB specific?
> 
> A VF might or might not have the same security domain (P_Key) as the
> parent, and the P_Key is encoded in the broadcast address.  In the
> event that two vfs or a vf and a pf can't see each other over the IPoIB
> network, it is necessary to be able to see the broadcast address in use
> by each to make sure they are the same and not that they shouldn't be
> able to see each other because they are on different P_Keys and
> therefore different broadcast multicast groups.

Thanks for explaining.

I'll apply these to net-next right now then.

Thanks again.
