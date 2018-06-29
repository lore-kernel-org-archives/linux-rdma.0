From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: iscsi_trx oops in 4.18.0-rc2 and potential patch for percpu_ida.c
Date: Fri, 29 Jun 2018 09:49:25 +0200
Message-ID: <20180629074924.pomscnvmi3l42lbm@linutronix.de>
References: <E079A211AAA8AD48953B67A89DB71C856E7DBC38@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E079A211AAA8AD48953B67A89DB71C856E7DBC38@fmsmsx104.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Calciano, Jess" <jess.calciano@intel.com>
Cc: "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 2018-06-28 19:53:21 [+0000], Calciano, Jess wrote:
> So although the problem has already been reported, we're wondering if there are any updates on the status of the fix, or if it will be available in an upcoming mainline build.
In Linus' tree:
4bb6e96ab808 ("lib/percpu_ida.c: don't do alloc from per-CPU list if there is none")

> Thanks,
> Jess

Sebastian
