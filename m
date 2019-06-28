From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 16/27] net: remove unneeded memset
Date: Fri, 28 Jun 2019 08:00:54 +0300
Message-ID: <87v9wqqp6h.fsf@codeaurora.org>
References: <20190628024843.15635-1-huangfq.daxian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ath10k-bounces+gldad-ath10k=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190628024843.15635-1-huangfq.daxian@gmail.com> (Fuqian Huang's
 message of "Fri, 28 Jun 2019 10:48:31 +0800")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/ath10k>,
 <mailto:ath10k-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/ath10k/>
List-Post: <mailto:ath10k@lists.infradead.org>
List-Help: <mailto:ath10k-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/ath10k>,
 <mailto:ath10k-request@lists.infradead.org?subject=subscribe>
Sender: "ath10k" <ath10k-bounces@lists.infradead.org>
Errors-To: ath10k-bounces+gldad-ath10k=m.gmane.org@lists.infradead.org
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: Ronak Doshi <doshir@vmware.com>, Sergey Matyukevich <smatyukevich@quantenna.com>, "VMware,
 Inc." <pv-drivers@vmware.com>, Chris Snook <chris.snook@gmail.com>, Chi-Hsien Lin <chi-hsien.lin@cypress.com>, Arend van Spriel <arend.vanspriel@broadcom.com>, linux-kernel@vger.kernel.org, Vishal Kulkarni <vishal@chelsio.com>, Samuel Chessman <chessman@tux.org>, =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>, netdev@vger.kernel.org, Avinash Patil <avinashp@quantenna.com>, Thomas Gleixner <tglx@linutronix.de>, Manish Chopra <manishc@marvell.com>, linux-rdma@vger.kernel.org, Will Deacon <will@kernel.org>, Guo-Fu Tseng <cooldavid@cooldavid.org>, Rahul Verma <rahulv@marvell.com>, ath10k@lists.infradead.org, brcm80211-dev-list@cypress.com, Saeed Mahameed <saeedm@mellanox.com>, linux-hippi@sunsite.dk, Franky Lin <franky.lin@broadcom.com>, Yang Wei <yang.wei9@zte.com.cn>, Jes
List-Id: linux-rdma@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> writes:

> The memset with 0 after zeroing allocator is unneeded.
>
> pci_alloc_persistent calls dma_alloc_coherent directly.
> In commit af7ddd8a627c
> ("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
> dma_alloc_coherent has already zeroed the memory.
> So the memset after these functions is unneeded.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>  drivers/net/ethernet/atheros/atlx/atl1.c                   | 2 --
>  drivers/net/ethernet/atheros/atlx/atl2.c                   | 1 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c                  | 2 --
>  drivers/net/ethernet/chelsio/cxgb4/sched.c                 | 1 -
>  drivers/net/ethernet/freescale/fec_main.c                  | 2 --
>  drivers/net/ethernet/jme.c                                 | 5 -----
>  drivers/net/ethernet/marvell/skge.c                        | 2 --
>  drivers/net/ethernet/mellanox/mlx4/eq.c                    | 2 --
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 1 -
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 --
>  drivers/net/ethernet/mellanox/mlxsw/pci.c                  | 1 -
>  drivers/net/ethernet/neterion/s2io.c                       | 1 -
>  drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c        | 3 ---
>  drivers/net/ethernet/ti/tlan.c                             | 1 -
>  drivers/net/hippi/rrunner.c                                | 2 --
>  drivers/net/vmxnet3/vmxnet3_drv.c                          | 1 -
>  drivers/net/wireless/ath/ath10k/ce.c                       | 5 -----
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 2 --
>  drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 2 --
>  drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   | 2 --

For the wireless part:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

I assume Dave will take this.

-- 
Kalle Valo
