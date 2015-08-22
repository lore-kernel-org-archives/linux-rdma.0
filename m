From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Sat, 22 Aug 2015 10:25:16 +0200
Message-ID: <20150822082516.GC1857@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de> <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Haggai Eran <haggaie@mellanox.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 22, 2015 at 06:38:47AM +0000, Haggai Eran wrote:
> It looks like the default case in the non-UD branch is currently used to handle plain IB_WR_SEND operations, so the patch would cause these to return an error.

Indeed.  It's handled fine in patch 2 which splits up the case, but
will be incorrectly rejected with just this patch applied.
