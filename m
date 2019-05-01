From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2] rds: ib: force endiannes annotation
Date: Wed, 01 May 2019 17:15:56 -0400 (EDT)
Message-ID: <20190501.171556.558136305355226946.davem@davemloft.net>
References: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hofrat@osadl.org
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>
Date: Tue, 30 Apr 2019 05:12:57 +0200

> While the endiannes is being handled correctly as indicated by the comment
> above the offending line - sparse was unhappy with the missing annotation
> as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
> all involved variables are changed to a consistent __le64 and the
>  conversion to uint64_t delayed to the call to rds_cong_map_updated().
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Applied.
