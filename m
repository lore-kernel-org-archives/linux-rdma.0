From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/ipoib: Convert timers to use timer_setup()
Date: Mon, 09 Oct 2017 12:25:43 -0400
Message-ID: <1507566343.46071.38.camel@redhat.com>
References: <20171005004554.GA22669@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005004554.GA22669@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, "kernel@kyup.com" <kernel@kyup.com>, Paolo Abeni <pabeni@redhat.com>, Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>, Feras Daoud <ferasda@mellanox.com>, Alex Estrin <alex.estrin@intel.com>, Shamir Rabinovitch <shamir.rabinovitch@oracle.com>, linux-rdma@vger.kernel.org, Yuval Shaia <yuval.shaia@oracle.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-10-04 at 17:45 -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list
> pointer to
> all timer callbacks, switch to using the new timer_setup() and
> from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Alex Vesker <valex@mellanox.com>
> Cc: Erez Shitrit <erezsh@mellanox.com>
> Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
> Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.co
> m>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Yuval Shaia <yuval.shaia@oracle.com>
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
