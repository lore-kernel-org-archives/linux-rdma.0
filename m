From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 16 May 2018 19:39:08 +0200
Message-ID: <20180516173908.GA21169@asgard.redhat.com>
References: <20180406160541.GA28094@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180406160541.GA28094@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 06, 2018 at 10:05:41AM -0600, Jason Gunthorpe wrote:
>       RDMA: Change all uapi headers to use __aligned_u64 instead of __u64
Looks like this change changed the size of struct hfi1_ctxt_info and the
value of HFI1_IOCTL_CTXT_INFO ioctl number as a result.

>       IB/uverbs: Extend uverbs_ioctl header with driver_id
This patch changed the value of the RDMA_VERBS_IOCTL ioctl number.

(see https://lists.strace.io/pipermail/strace-devel/2018-May/008196.html
for the reference)
