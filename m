From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v2 8/8] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Tue, 25 Oct 2016 18:46:58 +0530
Message-ID: <CAHv-k__yPiQOeZxDjvaSzG6A8Qs32to9MnKiPpHAvbXMxqE5EA@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org> <20161025122609.GQ25013@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161025122609.GQ25013@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 25 October 2016 at 17:56, Leon Romanovsky <leon@kernel.org> wrote:
> On Tue, Oct 25, 2016 at 05:31:59PM +0530, Binoy Jayan wrote:

> In case of success (err == 0), you will call to unmap_dma instead of
> normal flow.
>
> NAK,
> Leon Romanovsky <leonro@mellanox.com>

Hi Loen,

Even in the original code, the regular flow seems to reach 'unmap_dma' after
returning from 'wait_for_completion'().

-Binoy
