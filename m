From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Wed, 18 Nov 2015 13:38:47 +0200
Message-ID: <564C6347.3040501@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com> <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com> <564B00C3.1030506@dev.mellanox.co.il>
 <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>, Pete Wyckoff <pw@padd.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


> AFAIR, in the past there weren't explicit means to do that.
>
> What's makes iscsi tcp eligible to support bidi's that we don't have @ iser?

In theory, nothing.
In practice, iser is missing customer demands, iser targets that
support bidi and testing...

If someone cared enough about it then I assume we'd hear about it by
now...
