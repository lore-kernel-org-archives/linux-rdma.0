From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/2] mlx4: Expose correct max_sge_rd limit
Date: Tue, 27 Oct 2015 18:03:43 +0200
Message-ID: <562FA05F.4050805@dev.mellanox.co.il>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
 <1445938846-9240-2-git-send-email-sagig@mellanox.com>
 <562F8C8F.8040000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <562F8C8F.8040000@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 27/10/2015 16:39, Or Gerlitz wrote:
> On 10/27/2015 11:40 AM, Sagi Grimberg wrote:
>> mlx4 devices (ConnectX-2, ConnectX-3) can not issue
>> max_sge in a single RDMA_READ request (resulting in
>> a completion error). Thus, expose lower max_sge_rd
>> to avoid this issue.
>
> Sagi,

Hey Or,

> Still, this patch is currently pure WA b/c we didn't do RCA (Root Cause
> Analysis)

So from my discussions with the HW folks a RDMA_READ wqe cannot exceed
512B. The wqe control segment is 16 bytes, the rdma section is 12 bytes
(rkey + raddr) and each sge is 16 bytes so the computation is:

(512B-16B-12B)/16B = 30.

The reason is that the HW needs to fetch the rdma_read wqe on the RX
path (rdma_read response) and it has a limited buffer at that point.

Perhaps a dedicated #define for that is needed here.

I'll add that in the change log in v1.

Cheers,
Sagi.
