From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 10/10] target: Use non-selective polling
Date: Tue, 21 Mar 2017 13:35:05 +0200
Message-ID: <cd47b4c3-34fb-039c-ffb1-b9702701576f@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-11-git-send-email-sagi@grimberg.me>
 <1489881481.27336.23.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489881481.27336.23.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Hey Sagi,

Hey Nic

> Let's make 'batch' into a backend specific attribute so it can be
> changed on-the-fly per device, instead of a hard-coded value.
>
> Here's a quick patch to that end.  Feel free to fold it into your
> series.

I will, thanks!
