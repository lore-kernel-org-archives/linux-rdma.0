From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Wed, 18 Nov 2015 05:52:37 -0800
Message-ID: <20151118135237.GA3214@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com>
 <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com>
 <564B00C3.1030506@dev.mellanox.co.il>
 <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
 <564C6347.3040501@dev.mellanox.co.il>
 <CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Pete Wyckoff <pw@padd.com>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 18, 2015 at 03:33:01PM +0200, Or Gerlitz wrote:
> Sagi, it works in TGT and AFAIR with the initiator too.
> 
> Looking on this paper of Pete Wyckoff  [1] I see that he says that
> few changes to the initiator were needed, not sure which.

Or, can you please stop it?

Fortunately neither the iSER target or initiator ever support the
nightmare called bidi commands, and I'be happy o kill of that cruft
entirely if we could.

Did you buy shares in a defunct T10 OSD vendor or why do you even care?
