From: Corey Minyard <tcminyard@gmail.com>
Subject: Re: [PATCH 0/6] treewide: Add and use dev_fmt similar to pr_fmt
Date: Wed, 9 May 2018 11:47:15 -0500
Message-ID: <4a397208-bd6c-a6c3-c161-4de8579ca17e@gmail.com>
References: <cover.1525878372.git.joe@perches.com>
Reply-To: minyard@acm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525878372.git.joe@perches.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, openipmi-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/09/2018 10:15 AM, Joe Perches wrote:
> The pr_fmt mechanism exists for pr_<level> logging message prefixing,
> but no similar capability exists for dev_<level> message prefixing.
>
> Many uses of dev_<level> have an embedded prefix for logging output.
>
> So add a similar dev_fmt macro that can automatically prefix the
> dev_<level> logging output.
>
> Rename the existing dev_<level> functions to _dev_<level> and add new
> macros that call _dev_<level> with the desired prefix if defined.
>
> The new default #define for dev_fmt is blank.
>
> Convert ipmi and infiniband to use this mechanism.

The IPMI changes look good to me.

There are some conflicts with a patch I have pulling out the proc 
interface that is
destined for 3.18.  I can take the IPMI changes into my tree, if you want.

Thanks,

-corey

> Miscellanea:
>
> o x86/early-quirks uses an internal macro for #define dev_err which conflicts
>   with the existing dev_err macro, so rename it.
>
> Joe Perches (6):
>    x86/early-quirks: Rename duplicate define of dev_err
>    device: Add #define dev_fmt similar to #define pr_fmt
>    ipmi: msghandler: Add and use pr_fmt and dev_fmt, remove PFX
>    ipmi: Use more common logging styles
>    ipmi: Convert printk(KERN_<level> to pr_<level>(
>    infiniband: qplib_fp: Use dev_fmt
>
>   arch/x86/kernel/early-quirks.c           |   8 +-
>   drivers/base/core.c                      |  12 +--
>   drivers/char/ipmi/ipmi_bt_sm.c           |  64 ++++++++--------
>   drivers/char/ipmi/ipmi_devintf.c         |  11 ++-
>   drivers/char/ipmi/ipmi_kcs_sm.c          |   4 +-
>   drivers/char/ipmi/ipmi_msghandler.c      |  53 +++++++------
>   drivers/char/ipmi/ipmi_poweroff.c        |  67 ++++++++---------
>   drivers/char/ipmi/ipmi_si_hardcode.c     |   9 ++-
>   drivers/char/ipmi/ipmi_si_hotmod.c       |  17 +++--
>   drivers/char/ipmi/ipmi_si_intf.c         |  22 +++---
>   drivers/char/ipmi/ipmi_si_pci.c          |  12 +--
>   drivers/char/ipmi/ipmi_si_platform.c     |  20 ++---
>   drivers/char/ipmi/ipmi_smic_sm.c         |  26 +++----
>   drivers/char/ipmi/ipmi_ssif.c            |  73 +++++++++---------
>   drivers/char/ipmi/ipmi_watchdog.c        |  52 +++++++------
>   drivers/infiniband/hw/bnxt_re/qplib_fp.c | 125 ++++++++++++++-----------------
>   include/linux/device.h                   | 103 ++++++++++++++-----------
>   17 files changed, 330 insertions(+), 348 deletions(-)
>
