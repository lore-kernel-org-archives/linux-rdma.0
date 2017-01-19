From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Thu, 19 Jan 2017 08:51:22 -0800
Message-ID: <7f728991-3bc6-b3ce-ebee-094a6439c369@intel.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111181042.GC22783@obsidianresearch.com>
 <1484773260.2406.58.camel@redhat.com>
 <20170118210831.GA7590@obsidianresearch.com>
 <934eb6c4-fbba-28d0-d6bb-f036cc9ced5c@intel.com>
 <1484785071.2406.69.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1484785071.2406.69.camel@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

On 01/18/2017 04:17 PM, Doug Ledford wrote:
>>> EPROBE_DEFER is intended when waiting on other components the
>>> driver
>>> may need, not for setting stable names.
>> Also EPROBE_DEFER only works during boot time.
>> After boot when a module gets rmmod/insmod EPROBE_DEFER has no
>> effect.
> Are you positive about this?  And even if you are, my answer is to fix
> the core to honor EPROBE_DEFER post boot.

Yes, the driver_deferred_probe_trigger() function is called from
late_initcall(). After boot there is nothing to call it again.
I'm investigating the udev path now as Jason suggested, but
udev has its own limitations.
I will see what it would take to extend the EPROBE_DEFER
functionality after boot.
Thanks,
-- 
Tadeusz
