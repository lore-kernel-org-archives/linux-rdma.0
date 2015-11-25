From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v1 08/10] iser-target: Support the remote invalidation exception
Date: Wed, 25 Nov 2015 10:41:42 +0200
Message-ID: <CAJ3xEMhiktX7tGe55esggTCoMy4WvipVyTNMNPaB4rBKk4bZHA@mail.gmail.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
	<1448382234-24806-9-git-send-email-sagig@mellanox.com>
	<CAJ3xEMjPwD3X-B+56-+sZ9RqMrcNgr_Y060nR3wLMhi_O0MgqA@mail.gmail.com>
	<5655698A.4020306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5655698A.4020306@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2015 at 9:55 AM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> For NO_DATA commands the iser specification explicitly states that
> read_stag and write_stag should be 0 which means that inv_rkey is 0
> too. We don't do remote invalidate in case inv_rkey is 0.

I see, so if this is case,  can you eliminate one the checks here

>>> +       if (isert_conn->snd_w_inv && isert_cmd->inv_rkey) {
