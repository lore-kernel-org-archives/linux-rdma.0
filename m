From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Thu, 30 Nov 2017 00:46:25 +0200
Message-ID: <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Amrani, Ram" <Ram.Amrani@cavium.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org


> If it's not already committed, can you add a "Fixes:" so stable maintainers will catch it?

I'm not sure at all that there is a clear cut commit that this fixes,
both the target code and the rdma interface code changed a lot so I
can't find any clear indication which broke this.

I can send a separate patch to stable from when we introduced
ib_drain_qp though.
