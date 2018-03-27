From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 18:35:34 -0400
Message-ID: <afcdcbdb-5caa-6ea3-d3ed-d26237f0968f@codeaurora.org>
References: <CAKgT0UfZKBTYPCqWtBF=N5TPFrbsv0ZU+2GHMqF3J4BM9Hw4yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKgT0UfZKBTYPCqWtBF=N5TPFrbsv0ZU+2GHMqF3J4BM9Hw4yw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/27/2018 5:54 PM, Alexander Duyck wrote:
> I view the wmb() + writel_relaxed() as more of a driver owning and
> handling this itself. Besides in the Intel Ethernet driver case it is
> better performance as our wmb() placement for us also provides a
> secondary barrier so we don't need to add a separate smp_wmb() to deal
> with a potential race we have with the Tx cleanup.

Thanks for the reminder. 

I forgot about the double barrier optimization. wmb() + writel_relaxed()
seems to be the best option for Intel network drivers at this moment. 
Otherwise, we'll have to remove wmb() and throw in smp barriers there
like you mentioned.

I'll leave the changes in the Intel drivers alone.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
