From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/1] timecounter: Make cyclecounter struct part of
 timecounter struct
Date: Fri, 1 Dec 2017 07:56:05 -0800
Message-ID: <20171201155605.7c7oiq5we4n7wdum@localhost>
References: <1512114454-26958-1-git-send-email-sagar.a.kamble@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512114454-26958-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Chris Wilson <chris@chris-wilson.co.uk>, John Stultz <john.stultz@linaro.org>, intel-wired-lan@lists.osuosl.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 01, 2017 at 01:17:34PM +0530, Sagar Arun Kamble wrote:
> There is no real need for the users of timecounters to define cyclecounter
> and timecounter variables separately. Since timecounter will always be
> based on cyclecounter, have cyclecounter struct as member of timecounter
> struct.

Could you please put the PTP maintainer onto CC?

Thanks,
Richard
