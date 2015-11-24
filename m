From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 03/10] IB/iser: Don't register memory for all
 immediatedata writes
Date: Tue, 24 Nov 2015 12:04:36 +0200
Message-ID: <56543634.4090605@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-4-git-send-email-sagig@mellanox.com>
 <564ADB7D.20806@mellanox.com> <564AF653.6060401@dev.mellanox.co.il>
 <20151123181343.GB32085@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151123181343.GB32085@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Jason and Or,

>
> I'm with Or on this, this is really goofy looking.
>
> This routine probably should not be setting the rkey at all, it makes
> no sense to have a routine that returns a lkey and a rkey. Those are
> always different flows.
>
> Once that is fixed then the above if can be hoisted to the actual
> calling code that needs an rkey, at the point where it does something
> different when !iser_always_reg is true..

This change is acceptable to me. However, given that it includes
rework outside the scope of this specific patch which is a performance
regression fix, would it be acceptable to have it incremental and
provide a FIXME comment here?
