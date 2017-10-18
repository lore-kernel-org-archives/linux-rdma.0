From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [PATCH] RDMA/i40iw: Convert timers to use timer_setup() (part 2)
Date: Wed, 18 Oct 2017 15:57:54 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A75BA3ABCD@fmsmsx116.amr.corp.intel.com>
References: <20171017183754.GA108519@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171017183754.GA108519@beast>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Doug Ledford <dledford@redhat.com>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH] RDMA/i40iw: Convert timers to use timer_setup() (part 2)
> 
> In preparation for unconditionally passing the struct timer_list pointer to all timer
> callbacks, switch to using the new timer_setup() and from_timer() to pass the timer
> pointer explicitly.
> 
> This includes the remaining timers missed in the earlier i40iw patch.
> 
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks!

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
