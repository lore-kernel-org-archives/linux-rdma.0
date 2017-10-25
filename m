From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/rxe: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 15:26:00 -0400
Message-ID: <1508959560.3325.59.camel@redhat.com>
References: <20171024102827.GA69848@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171024102827.GA69848@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Moni Shoua <monis@mellanox.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-24 at 03:28 -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list
> pointer to
> all timer callbacks, switch to using the new timer_setup() and
> from_timer()
> to pass the timer pointer explicitly.
> 
> Cc: Moni Shoua <monis@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: linux-rdma@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
