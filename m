From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 02/10] IB/iser: Default to fastreg instead of fmr
Date: Tue, 17 Nov 2015 12:46:14 +0200
Message-ID: <564B0576.4060300@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-3-git-send-email-sagig@mellanox.com>
 <564ADA1C.4090905@mellanox.com> <564AF4CB.9060302@dev.mellanox.co.il>
 <564AFCD6.309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564AFCD6.309@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org


> Why? the invalidate is just one part of the story, we are doing a
> mapping on IO submission
> and CX3 has strong ordering on FRWRs, right?

Yes, this is correct.
We'll test on CX3 to see if this introduces a regression.

> We should make sure not to introduce performance regression for HW which
> has such a big existing install base and is well selling in 2015/16

You are right.
