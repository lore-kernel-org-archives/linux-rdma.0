From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH RFC] IB/mad: remove obsolete snoop interface
Date: Wed, 30 Sep 2015 08:54:47 -0400
Message-ID: <560BDB97.8010908@dev.mellanox.co.il>
References: <1443592864-32019-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443592864-32019-1-git-send-email-ira.weiny@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: dledford@redhat.com, xerofoify@gmail.com, linux-rdma@vger.kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, jgunthorpe@obsidianresearch.com, yun.wang@profitbricks.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 9/30/2015 2:01 AM, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> This interface has no current users and is obsolete.

There are no in tree users of this but there is Sean's madeye tool
(which is out of tree). This is still a useful debug tool for MADs.

> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> 
> This has undergone a medium level of testing.  I have run it against
> mlx4, qib, and OPA hardware and it does not seem to cause any regressions.
> 
>  drivers/infiniband/core/mad.c      | 226 +------------------------------------
>  drivers/infiniband/core/mad_priv.h |  13 ---
>  2 files changed, 5 insertions(+), 234 deletions(-)

There are also snoop changes needed in include/rdma/ib_mad.h.

Is it correct to assume that OPA_CAP_MASK3_IsSnoopSupported in
opa_port_info.h is not related to this ?

-- Hal
