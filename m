From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cxgb3: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 11:49:37 -0400
Message-ID: <1508341777.46071.83.camel@redhat.com>
References: <20171016225411.GA98979@beast>
         <08d501d34753$f6205c90$e26115b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <08d501d34753$f6205c90$e26115b0$@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Kees Cook' <keescook@chromium.org>
Cc: 'Steve Wise' <swise@chelsio.com>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-17 at 09:26 -0500, Steve Wise wrote:
> > In preparation for unconditionally passing the struct timer_list
> > pointer to
> > all timer callbacks, switch to using the new timer_setup() and
> > from_timer()
> > to pass the timer pointer explicitly. Also removes an unused timer.
> > 
> > Cc: Steve Wise <swise@chelsio.com>
> > Cc: Doug Ledford <dledford@redhat.com>
> > Cc: Sean Hefty <sean.hefty@intel.com>
> > Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> > Cc: linux-rdma@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Steve Wise <swise@opengridcomputing.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
