From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v7 04/23] IB/Verbs: Reform IB-core cm
Date: Tue, 28 Apr 2015 22:02:21 +0300
Message-ID: <CAJ3xEMhOg1xh5dXburjavqcy3crwWs6OoF2qEojiDxDhT-MCDw@mail.gmail.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
	<1430233823-7075-5-git-send-email-yun.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-5-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Devesh Sharma <Devesh.Sharma@emulex.com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 28, 2015 at 6:10 PM, Michael Wang <yun.wang@profitbricks.com> wrote:
> Use raw management helpers to reform IB-core cm.
>
> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  drivers/infiniband/core/cm.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

Hi Michael,

I don't really see the benefit (e.g for someone doing bisection
1/2/5/10 years from now and landing here) of listing all the group of
reviewers for each of the ~30 patches that make this series, any
special reason that caused you doing so?

Or.
