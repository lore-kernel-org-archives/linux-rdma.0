From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 17:42:13 +0200
Message-ID: <ae4630ba-8a3e-8f30-0ea9-a8a177da0bd1@grimberg.me>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <20170215071449.GM6989@mtr-leonro.local>
 <20170215081945.GP6989@mtr-leonro.local>
 <90797260.31671071.1487165615598.JavaMail.zimbra@redhat.com>
 <152629651.31673945.1487166218360.JavaMail.zimbra@redhat.com>
 <20170215134707.GQ6989@mtr-leonro.local>
 <242820990.31706010.1487170436012.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <242820990.31706010.1487170436012.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Artemy Kovalyov <artemyko@mellanox.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Hello Leon
> I pulled your tree, ran git checkout rdma-next
> I applied the patch manually, built the kernel and started the tests.
>
> Pretty soon I ran into
>
> ibclient login: [  132.640142] mlx5_1:dump_cqe:262:(pid 11417): dump error cqe
> [  132.640185] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd86a97b0
> [  132.718106] 00000000 00000000 00000000 00000000
> [  132.743616] 00000000 00000000 00000000 00000000
> [  132.767790] 00000000 00000000 00000000 00000000
> [  132.793626] 00000000 0f007806 2500002a 8ad015d1

Not surprising given that the ib_map_mr_sg code never visits there...
