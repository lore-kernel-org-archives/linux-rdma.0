From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/i40iw: Convert timers to use timer_setup()
Date: Mon, 09 Oct 2017 12:24:22 -0400
Message-ID: <1507566262.46071.36.camel@redhat.com>
References: <20171005004541.GA22645@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005004541.GA22645@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-10-04 at 17:45 -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list
> pointer to
> all timer callbacks, switch to using the new timer_setup() and
> from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This requires commit 686fef928bba ("timer: Prepare to change timer
> callback argument type") in v4.14-rc3, but should be otherwise
> stand-alone.

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
