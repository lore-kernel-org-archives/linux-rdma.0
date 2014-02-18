From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1 00/12] T10-DIF Initial support for iSER target
Date: Tue, 18 Feb 2014 12:05:41 -0800
Message-ID: <1392753941.28946.27.camel@haakon3.risingtidesystems.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Sun, 2014-02-16 at 19:38 +0200, Sagi Grimberg wrote:
> Hey Nic and folks,
> 
> This patchset introduces target side T10-PI offload support over
> RDMA. Currently the implementation is for iSER transport but can
> be easily extended to SRP (or FCoE in the future).
> 
> Should mention that this patchset depends on RDMA signature
> verbs making it for inclusion which will hopefully happen in
> near future.
> 
> This code was tested against iSER legacy initiator, and also
> initiator that uses T10-PI offload as well. I'll clean up the
> initiator code in the following days and submit that as well.
> 

Looking forward to seeing the initiator code in action.

> This code works under medium loads using backstores:
> - FileIO with DIF emulation.
> - RD with DIF emulation.
> - iBLOCK (scsi_debug with DIF support).
> 
> Nic, Can you take this code to rdma_dif branch until RDMA
> Signature verbs set will pass submission? (after review of
> course...).
> 

Ok, a few mostly minor comments on this series.  Please address these
and repost.

Also, target-pending/rdma-dif has been updated to v3.14-rc2 from the
last RDMA Signature verbs patch series.  Please take a moment to verify
that it's update to date.

Thanks!

--nab
