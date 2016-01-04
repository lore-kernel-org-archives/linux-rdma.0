From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v2 00/10] iSER support for remote invalidate
Date: Mon, 4 Jan 2016 08:38:15 +0200
Message-ID: <CAJ3xEMjGLgSt1LOawWxF1o4M8i9-bCMrWGrmt4gieycREO_FQA@mail.gmail.com>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
	<1450671628.25674.27.camel@haakon3.risingtidesystems.com>
	<CAJ3xEMi58s6bWv7cyb+3v3H7e=4t6hRaOX0TvTyXRXLiUjxq+g@mail.gmail.com>
	<5677FEBB.7080904@dev.mellanox.co.il>
	<CAJ3xEMjDpmQgt1RLnRuOP6b2EW=WQrER5d7A2NfQ6t5y4KCgMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMjDpmQgt1RLnRuOP6b2EW=WQrER5d7A2NfQ6t5y4KCgMw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 10:53 PM, Or Gerlitz <gerlitz.or@gmail.com> wrote:
> On Mon, Dec 21, 2015 at 3:29 PM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>
>>> Sagi, are you going to spin an increment in the initiator version?
>
>> I don't know if it's worth a driver version update?
>
> yes, I think it does. Finally we're getting real close to the visions
> of the spec authors...  do you have some performance data showing the
> gain of remote invalidation on certain HWs and IO benchmarks patterns.
> Did we make sure to interoperate between patched initiator to
> unpatched LIO or other targets which don't have this now (SCST, TGT)
> and the other way around (unpatched initiator, patched LIO)?


Sagi?


>> In case we do increment, I can send an incremental patch instead of
>> re-spinning the entire series.
>
> lets do that.

lets
