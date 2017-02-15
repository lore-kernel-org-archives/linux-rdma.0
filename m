From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 18:55:52 +0200
Message-ID: <bd732aec-36d9-b53c-1bee-1793fc807a2a@grimberg.me>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
 <1557361565.31861655.1487176647067.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1557361565.31861655.1487176647067.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Started with Linus's tree, applied the change requested by Sagi, built the kernel, rebooted and started the tests.
>
> Linux ibclient 4.10.0-rc8.sagi+ #1 SMP Wed Feb 15 11:09:44 EST 2017 x86_64 x86_64 x86_64 GNU/Linux
>
> Very quickly get to this
>
> [  180.990285] mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> [  181.016899] 00000000 00000000 00000000 00000000
> [  181.040949] 00000000 00000000 00000000 00000000
> [  181.066960] 00000000 00000000 00000000 00000000
> [  181.092030] 00000000 0f007806 2500002a bf1913d0
> [  181.117254] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bdbe88778
> [  196.288933] fast_io_fail_tmo expired for SRP port-2:1 / host2.
> [  197.090886] scsi host2: ib_srp: reconnect succeeded
> [  197.127628] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f09b6f30
>
> So does not help.
> I think my and Barts suggestion to revert for now is the best way forward.
> I have already tested this in-depth from Bart's tree and its been sent to Doug as V2 of Bart'recent 8 patch series.

Yea, probably this is the best way forward.

Bart, I think the change I suggested is still needed regardless,
do you agree?

Max, Leon, is it possible that the max number of klms pr mr is
less than what reported in device capabilities for page_list_len?

If so, this means that either:
1. mlx5 needs to expose the minimum between pages and sg elems (sucks)
2. we need yet another capability for SG_GAPS (sucks^2 because the
whole point was to make it transparent to the user)
3. mlx5 does not support SG_GAPS (sucks^3 because we now have something
thats not supported by any device).
