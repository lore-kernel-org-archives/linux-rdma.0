From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Fri, 5 Apr 2013 13:43:49 -0700
Message-ID: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <515F3160.4020007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
<mrhines@linux.vnet.ibm.com> wrote:
> I also removed the IBV_*_WRITE flags on the sender-side and activated
> cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
> with RDMA also succeeded without any problems (both with *and* without GIFT
> also worked).

Not sure I'm interpreting this correctly.  Are you saying that things
worked without actually setting the GIFT flag?   In which case why are
we adding this flag?

 - R.
