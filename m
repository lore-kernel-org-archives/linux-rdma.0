From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 02/10] IB/iser: Default to fastreg instead of fmr
Date: Tue, 17 Nov 2015 11:35:07 +0200
Message-ID: <564AF4CB.9060302@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-3-git-send-email-sagig@mellanox.com>
 <564ADA1C.4090905@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564ADA1C.4090905@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org


> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> This is a pre-step before adding remote invalidate support.
>
> Wouldn't that introduce performance regression on ConnectX3 devices?

With remote invalidate it shouldn't make much of a difference. Plus,
I'd really like us to start phasing out from FMRs...
