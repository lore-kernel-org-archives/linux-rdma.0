From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/i40iw: Convert timers to use timer_setup()
Date: Mon, 09 Oct 2017 12:25:24 -0400
Message-ID: <1507566324.46071.37.camel@redhat.com>
References: <20171005004541.GA22645@beast>
         <20171006231723.GA22568@ssaleem-MOBL4.amr.corp.intel.com>
         <20171007141255.GA2536@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171007141255.GA2536-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-10-07 at 09:12 -0500, Shiraz Saleem wrote:
> Hi Kees,
> 
> Sorry, I didnt notice this earlier, but, you made the change only to
> the stats timer
> to use the new timer init APIs. Can you do the same for the cm_timer
> and terminate_timer
> too for i40iw; so that things are consistent?
> 
> [ssaleem@linbuild6081 i40iw]$ grep "setup_timer" *
> i40iw_cm.c:     setup_timer(&cm_core->tcp_timer, i40iw_cm_timer_tick,
> i40iw_utils.c:  setup_timer(&iwqp->terminate_timer,
> i40iw_terminate_timeout,
> i40iw_utils.c:  setup_timer(&devstat->stats_timer,
> i40iw_hw_stats_timeout,

Since I took the first patch, this will need to be as an incremental
change.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
