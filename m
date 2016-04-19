From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 12/12] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Tue, 19 Apr 2016 17:23:53 +0300
Message-ID: <57163F79.9080707@grimberg.me>
References: <1461010463-6603-1-git-send-email-hch@lst.de>
 <1461010463-6603-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1461010463-6603-13-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Oren Duer <oren@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 18/04/16 23:14, Christoph Hellwig wrote:
> Replace the homegrown RDMA READ/WRITE code in isert with the generic API,
> which also adds iWarp support to the I/O path as a side effect.  Note
> that full iWarp operation will need a few additional patches from Steve.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 841 ++++----------------------------
>   drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
>   2 files changed, 85 insertions(+), 825 deletions(-)

Awesome insertion/deletion statistics :)

CC'ing Mellanox folks,

Max, Oren, I think you should get this code into the
regression systems to see that things aren't broken (normal
and T10-PI I/O paths).
