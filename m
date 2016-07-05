From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: NVMe over Fabrics target implementation V2
Date: Tue, 5 Jul 2016 11:31:10 -0600
Message-ID: <577BEEDE.8060607@kernel.dk>
References: <1466525061-3686-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466525061-3686-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/21/2016 10:04 AM, Christoph Hellwig wrote:
> This patch set adds a generic NVMe over Fabrics target. The
> implementation conforms to the NVMe 1.2b specification (which
> includes Fabrics) and provides the NVMe over Fabrics access
> to Linux block devices.
>
> The target implementation consists of several elements:
>
> - NVMe target core: defines and manages the NVMe entities (subsystems,
>    controllers, namespaces, ...) and their allocation, responsible
>    for initial commands processing and correct orchestration of
>    the stack setup and tear down.
>
> - NVMe admin command implementation: responsible for parsing and
>    servicing admin commands such as controller identify, set features,
>    keep-alive, log page, ...).
>
> - NVMe I/O command implementation: responsible for performing the actual
>    I/O (Read, Write, Flush, Deallocate (aka Discard).  It is a very thin
>    layer on top of the block layer and implements no logic of it's own.
>    To support exporting file systems please use the loopback block driver
>    in direct I/O mode, which gives very good performance.
>
> - NVMe over Fabrics support: responsible for servicing Fabrics commands
>    (connect, property get/set).
>
> - NVMe over Fabrics discovery service: responsible to serve the Discovery
>    log page through a special cut down Discovery controller.
>
> The target is configured using configfs, and configurable entities are:
>
>   - NVMe subsystems and namespaces
>   - NVMe over Fabrics ports and referrals
>   - Host ACLs for primitive access control - NVMe over Fabrics access
>     control is still work in progress at the specification level and
>     will be implemented once that work has finished.
>
> To configure the target use the nvmetcli tool from
> http://git.infradead.org/users/hch/nvmetcli.git, which includes detailed
> setup documentation.
>
> In addition to the Fabrics target implementation we provide a loopback
> driver which also conforms the NVMe over Fabrics specification and allows
> evaluation of the target stack with local access without requiring a real
> fabric.
>
> Various test cases are provided for this implementation: nvmetcli
> contains a python testsuite that mostly stresses the configfs interface
> of the target, and we have various integration tests prepared for the
> kernel host and target which are available at:
>
> 	git://git.infradead.org/nvme-fabrics.git nvmf-submit.2
>
> Gitweb:
>
> 	http://git.infradead.org/nvme-fabrics.git/shortlog/refs/heads/nvmf-submit.2
>
> This series depends on the "generic NVMe over Fabrics library support V2"
> series submitted last week.
>
> Changes since V1:
>   - rebased to the req_op changes in the block tree (me)
>   - fix a 64-bit division (me)
>   - properly set the SGL flag for AER requests in nvme-loop (me)
>   - fix use of ERR_PTR (buildbot)

Applied for 4.8, thanks.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
