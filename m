From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH for-4.3 00/15] Modify MR allocation API
Date: Thu, 30 Jul 2015 09:56:42 -0500
Message-ID: <55BA3B2A.9010403@opengridcomputing.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, linux-nfs@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 2:32 AM, Sagi Grimberg wrote:
> This patch set is detached from my WIP for modifying our
> fast registration kernel API. I incorporated some comments
> from Jason and Christoph. The current set is a drop-in replacement
> of ib_alloc_fast_reg_mr to ib_alloc_mr which receives a memory
> region type (whcih can be IB_MR_TYPE_MEM_REG for normal memory
> registration, IB_MR_TYPE_SIGNATURE for a data-integrity capable
> memory region and future arbitrary SG support capable memory
> region).
>
>

Series looks good.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
