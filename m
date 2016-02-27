From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 12/12] iser-target: Use ib_drain_qp
Date: Sat, 27 Feb 2016 15:36:30 -0800
Message-ID: <1456616190.1750.54.camel@haakon3.risingtidesystems.com>
References: <201602250232.0MaJNmx5%fengguang.wu@intel.com>
	 <56CEC01A.1050806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56CEC01A.1050806@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: kbuild test robot <lkp@intel.com>, Sagi Grimberg <sagig@mellanox.com>, kbuild-all@01.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-02-25 at 10:49 +0200, Sagi Grimberg wrote:
> > Hi Sagi,
> >
> > [auto build test ERROR on target/master]
> > [also build test ERROR on v4.5-rc5 next-20160224]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> OK, this patch depends on a new API that is expected to be included from
> doug's tree, and that is why compilation fails.
> 

Er, missed this earlier message..

> Nic, should we just push this in rc1 after doug pull request landed?

Sure, I'll plan to include in the post -rc1 fixes PULL request.
