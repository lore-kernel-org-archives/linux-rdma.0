From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v1 00/10] iSER support for remote invalidate
Date: Tue, 24 Nov 2015 10:55:40 -0600
Message-ID: <00e401d126d8$f3650390$da2f0ab0$@opengridcomputing.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>, 'Or Gerlitz' <ogerlitz@mellanox.com>, 'Jenny Derzhavetz' <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Sagi Grimberg
> Sent: Tuesday, November 24, 2015 10:24 AM
> To: linux-rdma@vger.kernel.org; target-devel@vger.kernel.org
> Cc: Nicholas A. Bellinger; Or Gerlitz; Jenny Derzhavetz; Steve Wise
> Subject: [PATCH v1 00/10] iSER support for remote invalidate
> 
> This patchset adds remote invalidation support to iser initiator and
> target. The support negotiation for this feature is based on IBTA
> annex 12 "Support for iSCSI Extensions for RDMA" carried in rdma_cm
> private data.
> 
> Remote invalidation allows a peer host to invalidate a remote key
> as part of a SEND operation. This feature allows a host to avoid
> invalidating an rkey locally. By supporting this feature iser initiator
> can save extra latency and processing time yielded by invalidating
> the memory key locally.
> 
> The initiator feature support is dependent on:
> - fastreg is used (not FMR)
> - always_register=Y
> 
> In this case the initiator will expose support for remote invalidation,
> however it will not blindly rely on the target to do so and will verify
> that in the work completion information. The iser target now looks into
> the iser header in the CM request and in case the initiator supports
> remote invalidation it will respond it will use remote invalidation for
> provided remote keys.
>

Series looks ok to me.

Reviewed-by: Steve Wise <swise@opengridcomputing.com> 
