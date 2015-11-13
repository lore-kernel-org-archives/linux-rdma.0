From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: srp state in current mainline
Date: Thu, 12 Nov 2015 17:12:14 -0800
Message-ID: <564538EE.3050805@sandisk.com>
References: <20151110171509.GA27781@infradead.org>
 <5643AE20.7040003@sandisk.com> <20151112175924.GA26612@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151112175924.GA26612@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2015 09:59 AM, Christoph Hellwig wrote:
> [  108.998574] WARNING: CPU: 0 PID: 1258 at kernel/sched/core.c:7389 __might_sleep+0xa7/0xb0()
> [  108.998580] do not call blocking ops when !TASK_RUNNING; state=1 set

Although this is most likely unrelated to the issue reported at the 
start of this thread, I have started working on a patch for this warning.

Bart.
