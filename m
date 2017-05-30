From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rdma-next] IB/iser: Fix connection teardown race condition
Date: Tue, 30 May 2017 14:50:16 +0300
Message-ID: <fa976fe5-be25-1c6a-5997-8fa7524e89d8@grimberg.me>
References: <20170521161731.22223-1-leon@kernel.org>
 <98334f53-a7ff-d465-989f-a5ee7add2291@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <98334f53-a7ff-d465-989f-a5ee7add2291@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Vladimir Neyelov <vladimirn@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi,
>
> what do you think on this approach ?
> we must somehow defend on the NULL deref in case dd_data in iscsi_conn
> (the iser_conn) already NULL due to conn_stop call.

Sounds like we get conn_stop duing lun scanning. Generally speaking I
don't like a global lock for this, but given the non trivial iscsi state 
machine
we can do with that.

Reviewed-by: Sagi Grimberg <sagi@grimbeg.me>
