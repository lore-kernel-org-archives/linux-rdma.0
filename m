From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] RDMA/srp: Rework SCSI device reset handling
Date: Tue, 22 Jan 2019 08:04:26 -0800
Message-ID: <1548173066.9266.47.camel@acm.org>
References: <20190117002717.84686-3-bvanassche@acm.org>
         <20190122155559.D1DD9217D6@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190122155559.D1DD9217D6@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2019-01-22 at 15:55 +-0000, Sasha Levin wrote:
+AD4 +AFs-This is an automated email+AF0
+AD4 
+AD4 This commit has been processed because it contains a +ACI-Fixes:+ACI tag,
+AD4 fixing commit: 94a9174c630c IB/srp: reduce lock coverage of command completion.
+AD4 
+AD4 The bot has tested the following trees: v4.20.3, v4.19.16, v4.14.94, v4.9.151, v4.4.171, v3.18.132.
+AD4 
+AD4 v4.20.3: Build OK+ACE
+AD4 v4.19.16: Build OK+ACE
+AD4 v4.14.94: Build OK+ACE
+AD4 v4.9.151: Build failed+ACE Errors:
+AD4     drivers/infiniband/ulp/srp/ib+AF8-srp.c:2657:2: error: implicit declaration of function +IBg-blk+AF8-freeze+AF8-queue+AF8-start+IBkAOw did you mean +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-start+IBk? +AFs--Werror+AD0-implicit-function-declaration+AF0
+AD4     drivers/infiniband/ulp/srp/ib+AF8-srp.c:2658:14: error: implicit declaration of function +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-wait+AF8-timeout+IBkAOw did you mean +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-start+IBk? +AFs--Werror+AD0-implicit-function-
+AD4 declaration+AF0
+AD4 
+AD4 v4.4.171: Build failed+ACE Errors:
+AD4     drivers/infiniband/ulp/srp/ib+AF8-srp.c:2612:2: error: implicit declaration of function +IBg-blk+AF8-freeze+AF8-queue+AF8-start+IBkAOw did you mean +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-start+IBk? +AFs--Werror+AD0-implicit-function-declaration+AF0
+AD4     drivers/infiniband/ulp/srp/ib+AF8-srp.c:2613:14: error: implicit declaration of function +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-wait+AF8-timeout+IBkAOw did you mean +IBg-blk+AF8-mq+AF8-freeze+AF8-queue+AF8-start+IBk? +AFs--Werror+AD0-implicit-function-
+AD4 declaration+AF0
+AD4 
+AD4 v3.18.132: Failed to apply+ACE Possible dependencies:
+AD4     205619f2f824 (+ACI-IB/srp: Remove stale connection retry mechanism+ACI)
+AD4     34aa654ecb8e (+ACI-IB/srp: Avoid that I/O hangs due to a cable pull during LUN scanning+ACI)
+AD4     394c595ee8c3 (+ACI-IB/srp: Move ib+AF8-destroy+AF8-cm+AF8-id() call into srp+AF8-free+AF8-ch+AF8-ib()+ACI)
+AD4     509c07bc1850 (+ACI-IB/srp: Separate target and channel variables+ACI)
+AD4     747fe000ef38 (+ACI-IB/srp: Introduce two new srp+AF8-target+AF8-port member variables+ACI)
+AD4     77f2c1a40e6f (+ACI-IB/srp: Use block layer tags+ACI)
+AD4     d92c0da71a35 (+ACI-IB/srp: Add multichannel support+ACI)
+AD4 
+AD4 
+AD4 How should we proceed with this patch?

Hi Sasha,

Patch 2/2 does not have a +ACI-Cc: stable+ACI tag because it definitely should NOT be
backported to older kernels. This patch only works for blk-mq which is fine with
kernel v5.0. Older kernels however support both the legacy block layer and blk-mq.

Bart.
