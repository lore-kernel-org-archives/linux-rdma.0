From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: NVMe over Fabrics RDMA transport drivers
Date: Tue, 7 Jun 2016 14:57:09 +0300
Message-ID: <5756B695.5020305@grimberg.me>
References: <1465248215-18186-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465248215-18186-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, keith.busch@intel.com
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

We forgot to CC Linux-rdma, CC'ing...

On 07/06/16 00:23, Christoph Hellwig wrote:
> This patch set implements the NVMe over Fabrics RDMA host and the target
> drivers.
>
> The host driver is tied into the NVMe host stack and implements the RDMA
> transport under the NVMe core and Fabrics modules. The NVMe over Fabrics
> RDMA host module is responsible for establishing a connection against a
> given target/controller, RDMA event handling and data-plane command
> processing.
>
> The target driver hooks into the NVMe target core stack and implements
> the RDMA transport. The module is responsible for RDMA connection
> establishment, RDMA event handling and data-plane RDMA commands
> processing.
>
> RDMA connection establishment is done using RDMA/CM and IP resolution.
> The data-plane command sequence follows the classic storage model where
> the target pushes/pulls the data.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
