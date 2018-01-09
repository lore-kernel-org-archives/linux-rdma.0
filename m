From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH 01/27] timecounter: Make
 cyclecounter struct part of timecounter struct
Date: Tue, 9 Jan 2018 14:31:33 +0530
Message-ID: <af2474d2-edf7-7db3-b14d-3587222daf79@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
 <1513323522-15021-2-git-send-email-sagar.a.kamble@intel.com>
 <309B89C4C689E141A5FF6A0C5FB2118B8C734DF8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <309B89C4C689E141A5FF6A0C5FB2118B8C734DF8@ORSMSX101.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
To: "Brown, Aaron F" <aaron.f.brown@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Richard Cochran <richardcochran@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>, Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <john.stultz@linaro.org>, "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>, Thomas Gleixner <tglx@linutronix.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Aaron.

Regards,
Sagar

On 1/9/2018 3:50 AM, Brown, Aaron F wrote:
>> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
>> Behalf Of Sagar Arun Kamble
>> Sent: Thursday, December 14, 2017 11:38 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: alsa-devel@alsa-project.org; linux-rdma@vger.kernel.org;
>> netdev@vger.kernel.org; Richard Cochran <richardcochran@gmail.com>;
>> Stephen Boyd <sboyd@codeaurora.org>; Chris Wilson <chris@chris-
>> wilson.co.uk>; John Stultz <john.stultz@linaro.org>; intel-wired-
>> lan@lists.osuosl.org; Thomas Gleixner <tglx@linutronix.de>; Kamble, Sagar A
>> <sagar.a.kamble@intel.com>; kvmarm@lists.cs.columbia.edu; linux-arm-
>> kernel@lists.infradead.org
>> Subject: [Intel-wired-lan] [PATCH 01/27] timecounter: Make cyclecounter
>> struct part of timecounter struct
>>
>> There is no real need for the users of timecounters to define cyclecounter
>> and timecounter variables separately. Since timecounter will always be
>> based on cyclecounter, have cyclecounter struct as member of timecounter
>> struct.
>>
>> v2: Rebase.
>>
>> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Richard Cochran <richardcochran@gmail.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: netdev@vger.kernel.org
>> Cc: intel-wired-lan@lists.osuosl.org
>> Cc: linux-rdma@vger.kernel.org
>> Cc: alsa-devel@alsa-project.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com> (Intel drivers)
>> ---
>>   arch/microblaze/kernel/timer.c                     | 20 ++++++------
>>   drivers/clocksource/arm_arch_timer.c               | 19 ++++++------
>>   drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  3 +-
>>   drivers/net/ethernet/amd/xgbe/xgbe-ptp.c           |  9 +++---
>>   drivers/net/ethernet/amd/xgbe/xgbe.h               |  1 -
>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  1 -
>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 20 ++++++------
>>   drivers/net/ethernet/freescale/fec.h               |  1 -
>>   drivers/net/ethernet/freescale/fec_ptp.c           | 30 +++++++++---------
>>   drivers/net/ethernet/intel/e1000e/e1000.h          |  1 -
>>   drivers/net/ethernet/intel/e1000e/netdev.c         | 27 ++++++++--------
>>   drivers/net/ethernet/intel/e1000e/ptp.c            |  2 +-
>>   drivers/net/ethernet/intel/igb/igb.h               |  1 -
>>   drivers/net/ethernet/intel/igb/igb_ptp.c           | 25 ++++++++-------
>>   drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  1 -
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 17 +++++-----
>>   drivers/net/ethernet/mellanox/mlx4/en_clock.c      | 28 ++++++++---------
>>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  1 -
>>   .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 34 ++++++++++----------
>>   drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 20 ++++++------
>>   drivers/net/ethernet/ti/cpts.c                     | 36 ++++++++++++----------
>>   drivers/net/ethernet/ti/cpts.h                     |  1 -
>>   include/linux/mlx5/driver.h                        |  1 -
>>   include/linux/timecounter.h                        |  4 +--
>>   include/sound/hdaudio.h                            |  1 -
>>   kernel/time/timecounter.c                          | 28 ++++++++---------
>>   sound/hda/hdac_stream.c                            |  7 +++--
>>   virt/kvm/arm/arch_timer.c                          |  6 ++--
>>   28 files changed, 163 insertions(+), 182 deletions(-)
>>
> For Intel e1000e and igb drivers:
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
