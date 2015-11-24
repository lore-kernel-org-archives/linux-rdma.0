From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v1 09/10] IB/iser: Increment the rkey when registering and
 not when invalidating
Date: Tue, 24 Nov 2015 21:12:32 +0200
Message-ID: <CAJ3xEMgpXb-9B53pLCO3thyLd-u84LYUpT6Wh5N3Gwy3fgdQgg@mail.gmail.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
	<1448382234-24806-10-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1448382234-24806-10-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 6:23 PM, Sagi Grimberg <sagig@mellanox.com> wrote:
> With remote invalidate we won't local invalidate
> but we still want to increment the rkey.

nit, better to phrase is as "we won't do local invalidate"
