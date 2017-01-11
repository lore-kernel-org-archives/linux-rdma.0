From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 11 Jan 2017 09:20:54 -0800
Message-ID: <dda30e58-41fd-b778-3b6c-6e59d08c41c7@intel.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111071252.GV7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170111071252.GV7218@mtr-leonro.local>
Sender: linux-pci-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

Hi Leon,
On 01/10/2017 11:12 PM, Leon Romanovsky wrote:
> Can't you recognize such device at the initialization phase?

Yes, this is exactly what it does. It checks the device GUID
and reorders the ports during insmod.

> This is definitely specific HW implementation bug/issue/limitation.

Correct. As the commit message says this is to fix a HW issue.

> 
> I always had an impression that module parameters are rarely beneficial
> in upstream kernel for driver modules and adding them for new driver
> code should be explicitly prohibited in CodingStyle guide.
> 
> You are adding new module parameter which will be with us forever to fix
> special HW bug/implementation in some legacy installations. It will be
> insane to add such thing to upstream kernel, errata and out-of-tree
> implementations are best places for such things.

Agree, but the reality is that there are 5505 $(git grep module_param drivers/ | wc -l)
module parameters in the kernel already, and even mlx4 and mlx5 drivers use them.
I really considered every other possible solution, but module parameter is the
only possible way to do such things during insmod.
Thanks,
-- 
Tadeusz
