From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [v2] infiniband: i40iw, nes: don't use wall time for TCP
 sequence numbers
Date: Thu, 5 Jul 2018 15:15:44 +0200
Message-ID: <CAK8P3a2B-YOsfgomq_ggAM8kzbCe6jB8_K8wiEe5v4Thjm=YJA@mail.gmail.com>
References: <20180627132628.915978-1-arnd@arndb.de> <201807010157.h1EBGb0w%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201807010157.h1EBGb0w%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "David S. Miller" <davem@davemloft.net>, Henry Orosco <henry.orosco@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 30, 2018 at 9:00 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Arnd,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.18-rc2 next-20180629]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/infiniband-i40iw-nes-don-t-use-wall-time-for-TCP-sequence-numbers/20180627-221142
> config: x86_64-randconfig-s2-06302231 (attached as .config)
> compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All errors (new ones prefixed by >>):
>
>    drivers/infiniband/hw/i40iw/i40iw_cm.o: In function `i40iw_make_cm_node':
>>> drivers/infiniband/hw/i40iw/i40iw_cm.c:2232: undefined reference to `secure_tcpv6_seq'
>

Fixed this now by added a

        depends on IPV6 || !IPV6

dependency in Kconfig. This ensures that with IPV6=m, i40iw cannot be built-in.

Will send v3 after a little more build testing.

      Arnd
