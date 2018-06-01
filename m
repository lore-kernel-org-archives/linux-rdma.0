From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Fri, 01 Jun 2018 11:45:58 -0400 (EDT)
Message-ID: <20180601.114558.569563972122502762.davem@davemloft.net>
References: <20180530175950.9488-1-saeedm@mellanox.com>
        <20180531.153603.45475041396194381.davem@davemloft.net>
        <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com
Cc: saeedm@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Doug Ledford <dledford@redhat.com>
Date: Fri, 01 Jun 2018 11:08:24 -0400

> On Thu, 2018-05-31 at 15:36 -0400, David Miller wrote:
>> From: Saeed Mahameed <saeedm@mellanox.com>
>> Date: Wed, 30 May 2018 10:59:48 -0700
>> 
>> > The following series is for mlx5-next tree [1], it adds the support of two
>> > new device events, from Ilan Tayari:
>> > 
>> > 1. High temperature warnings.
>> > 2. FPGA QP error event.
>> > 
>> > In case of no objection this series will be applied to mlx5-next tree
>> > and will be sent later as a pull request to both rdma and net trees.
>> > 
>> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next
>> > 
>> > v1->v2:
>> >   - improve commit message of the FPGA QP error event patch.
>> 
>> Series applied, thanks.
> 
> Hi Dave,
> 
> Although in this case it doesn't really matter and we can work around
> it, this was supposed to be a case of the new methodology that Saeed and
> Jason had worked out with you.  Specifically, when Saeed says in the
> cover letter:
> 
>> In case of no objection this series will be applied to mlx5-next tree>
>> and will be sent later as a pull request to both rdma and net trees.
> 
> then it is intended for you to ack the original patch series, not apply
> it, and when acks from both the net and rdma side have been received,
> then we will get a pull request of just that series.

Sorry, I saw your ACK and misinterpreted the situation.

I'll be more careful next time.
