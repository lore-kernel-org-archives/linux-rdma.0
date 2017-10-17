From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] RDMA/i40iw: Convert timers to use timer_setup()
Date: Tue, 17 Oct 2017 11:37:39 -0700
Message-ID: <CAGXu5jJ+wr77pC_Kcpx2EnfcYG3NqHw2XM+AGHMp2zYC-01mNg@mail.gmail.com>
References: <20171005004541.GA22645@beast> <20171006231723.GA22568@ssaleem-MOBL4.amr.corp.intel.com>
 <20171007141255.GA2536@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171007141255.GA2536@ssaleem-MOBL4.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 7, 2017 at 7:12 AM, Shiraz Saleem <shiraz.saleem@intel.com> wrote:
> On Fri, Oct 06, 2017 at 06:17:23PM -0500, Shiraz Saleem wrote:
>> On Wed, Oct 04, 2017 at 05:45:41PM -0700, Kees Cook wrote:
>> > In preparation for unconditionally passing the struct timer_list pointer to
>> > all timer callbacks, switch to using the new timer_setup() and from_timer()
>> > to pass the timer pointer explicitly.
>> >
>> > Cc: Faisal Latif <faisal.latif@intel.com>
>> > Cc: Shiraz Saleem <shiraz.saleem@intel.com>
>> > Cc: Doug Ledford <dledford@redhat.com>
>> > Cc: Sean Hefty <sean.hefty@intel.com>
>> > Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
>> > Cc: linux-rdma@vger.kernel.org
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > ---
>> > This requires commit 686fef928bba ("timer: Prepare to change timer
>> > callback argument type") in v4.14-rc3, but should be otherwise
>> > stand-alone.
>> > ---
>>
>> Patch looks ok. Did some minimal testing and looks good.
>>
>> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
>>
>
> Hi Kees,
>
> Sorry, I didnt notice this earlier, but, you made the change only to the stats timer
> to use the new timer init APIs. Can you do the same for the cm_timer and terminate_timer
> too for i40iw; so that things are consistent?
>
> [ssaleem@linbuild6081 i40iw]$ grep "setup_timer" *
> i40iw_cm.c:     setup_timer(&cm_core->tcp_timer, i40iw_cm_timer_tick,
> i40iw_utils.c:  setup_timer(&iwqp->terminate_timer, i40iw_terminate_timeout,
> i40iw_utils.c:  setup_timer(&devstat->stats_timer, i40iw_hw_stats_timeout,

Hi! (Sorry for the delay, I missed this email, thanks for the reminder.)

I will send a follow-up with these added. (They were trivial
conversions, so they were originally part of my tree's tree-wide mass
conversion before I started pulling per-subsystem conversions out into
separate patches.)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
