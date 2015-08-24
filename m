From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Mon, 24 Aug 2015 09:52:14 +0300
Message-ID: <55DABF1E.2050804@mellanox.com>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com>
 <20150822082516.GC1857@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150822082516.GC1857@lst.de>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 22/08/2015 11:25, Christoph Hellwig wrote:
> On Sat, Aug 22, 2015 at 06:38:47AM +0000, Haggai Eran wrote:
>> It looks like the default case in the non-UD branch is currently used to handle plain IB_WR_SEND operations, so the patch would cause these to return an error.
> 
> Indeed.  It's handled fine in patch 2 which splits up the case, but
> will be incorrectly rejected with just this patch applied.

Okay. Maybe you can just add a case for IB_WR_SEND in this patch to
avoid hurting bisectability.

Looking at the uverbs part in patch 2, I think the changes are okay. I
noticed there's a (__be32 __force) cast of the immediate data from
userspace (it was already in the existing code). I wonder, why not
define the field in the uapi struct as __be32 in the first place?

Haggai
