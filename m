From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: NVMe over Fabrics RDMA transport drivers V2
Date: Fri, 8 Jul 2016 08:40:20 -0600
Message-ID: <577FBB54.2010204@kernel.dk>
References: <1467809752-31320-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467809752-31320-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/06/2016 06:55 AM, Christoph Hellwig wrote:
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
> Changes since V1:
>   - updates for req_op changes in for-next (me)
>   - validate adrfam in nvmet-rdma (Ming)
>   - don't leak rsp structures on connect failure in nvmet-rdma (Steve)
>   - don't use RDMA/CM errors codes in reject path in nvmet-rdma (Steve)
>   - fix nvmet_rdma_delete_ctrl (me)
>   - invoke fatal error on error completion in nvmet-rdma (Sagi)
>   - don't leak rsp structure on disconnected queue in nvmet-rdma (Ming)
>   - properly set the SGL flag on AERs in nvme-rdma (me)
>   - correctly stop the keep alive timer on reconnect in nvme-rdma (Ming)
>   - stop and drain queues before freeing the tagset in nvet-rdma (Steve)

Added for 4.8, thanks.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
