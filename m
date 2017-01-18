From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 18 Jan 2017 14:03:57 -0800
Message-ID: <934eb6c4-fbba-28d0-d6bb-f036cc9ced5c@intel.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111181042.GC22783@obsidianresearch.com>
 <1484773260.2406.58.camel@redhat.com>
 <20170118210831.GA7590@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170118210831.GA7590@obsidianresearch.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

On 01/18/2017 01:08 PM, Jason Gunthorpe wrote:
> EPROBE_DEFER is intended when waiting on other components the driver
> may need, not for setting stable names.

Also EPROBE_DEFER only works during boot time.
After boot when a module gets rmmod/insmod EPROBE_DEFER has no effect.
Thanks,
-- 
Tadeusz
