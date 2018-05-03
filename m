From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] rds: do not leak kernel memory to user land
Date: Thu, 03 May 2018 11:26:50 -0400 (EDT)
Message-ID: <20180503.112650.2294706854339589223.davem@davemloft.net>
References: <20180502215339.117702-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180502215339.117702-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
To: edumazet@google.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  2 May 2018 14:53:39 -0700

> syzbot/KMSAN reported an uninit-value in put_cmsg(), originating
> from rds_cmsg_recv().
> 
> Simply clear the structure, since we have holes there, or since
> rx_traces might be smaller than RDS_MSG_RX_DGRAM_TRACE_MAX.
 ...
> Fixes: 3289025aedc0 ("RDS: add receive message trace used by application")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
