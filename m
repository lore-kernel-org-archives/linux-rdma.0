From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Thu, 19 Nov 2015 09:16:55 +0200
Message-ID: <564D7767.1010104@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com> <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com> <564B00C3.1030506@dev.mellanox.co.il>
 <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
 <564C6347.3040501@dev.mellanox.co.il>
 <CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
 <564C884C.8020006@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564C884C.8020006@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <gerlitz.or@gmail.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Pete Wyckoff <pw@padd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/18/2015 4:16 PM, Sagi Grimberg wrote:
>> Sagi, it works in TGT and AFAIR with the initiator too.
>>
>> Looking on this paper of Pete Wyckoff  [1] I see that he says that
>> few changes to the initiator were needed, not sure which.
>
> I see. I wasn't aware that TGT supports bidi. However, AFAICT the
> initiator support was never fully introduced upstream nor in our mlnx
> backports (perhaps in an off-tree implementation). As I see it, bidi
> functionality, is broken for a long time (if it was ever supported).

Sounds like we weren't communicating enough while reviewing the patches
since you joined as maintainer... lets improve.

> So I'd suggest we (you and me Or) look at bidi separately and try to
> find out if someone wants it (not for academic research).

I didn't follow on the comment, what's wrong with having the upstream 
kernel serve
for academics? features used for academics today might turn to 
production tomorrow.
It's not that we're writing a whole new driver for that, there's one 
piece in our
design/code which is good for that purpose, this is perfectly fine.


> Would you mind if we don't include bidi considerations in this patchset? 

You should not further break it, whatever is still there should remain.  
As for breakages
that were introduced over the last few cycles, we should think that to do.

Or.
