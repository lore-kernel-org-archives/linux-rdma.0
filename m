From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 00/18] Mellanox, mlx5 E-Switch and low level updates
Date: Mon, 1 Jul 2019 16:46:29 -0700
Message-ID: <CALzJLG-LEPqr3kDTYRKq8V-URsdTS2F87mV_qO9HaCX6CY7VZQ@mail.gmail.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 28, 2019 at 3:35 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi All,
>
> This series includes some low level updates mainly in the E-Switch
> netdev and rdma vport representors areas.
>
> From Parav and Huy:
>  1) Added hardware bits and structures definitions for sub-functions
>  2) Small code cleanup and improvement for PF pci driver.
>
> From Bodong:
>  3) Use the correct name semantics of vport index and vport number
>  4) Cleanup the rep and netdev reference when unloading IB rep.
>  5) Bluefield (ECPF) updates and refactoring for better E-Switch
>     management on ECPF embedded CPU NIC:
>     5.1) Consolidate querying eswitch number of VFs
>     5.2) Register event handler at the correct E-Switch init stage
>     5.3) Setup PF's inline mode and vlan pop when the ECPF is the
>          E-Swtich manager ( the host PF is basically a VF ).
>     5.4) Handle Vport UC address changes in switchdev mode.
>
> From Shay:
>  6) Add support for MCQI and MCQS hardware registers.
>
> In case of no objections these patches will be applied to mlx5-next and
> will be sent later as pull request to both rdma-next and net-next trees.

Applied to mlx5-next,

Thanks!
