From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 09/11] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Tue, 3 May 2016 14:16:08 -0700
Message-ID: <57291518.7050508@sandisk.com>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
 <1462291273-22403-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1462291273-22403-10-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com
Cc: swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/03/2016 09:01 AM, Christoph Hellwig wrote:
> Replace the homegrown RDMA READ/WRITE code in srpt with the generic API.
> The only real twist here is that we need to allocate one Linux scatterlist
> per direct buffer in the SRP command, and chain them before handing them
> off to the target core.
>
> As a side-effect of the conversion the driver will also chain the SEND
> of the SRP response to the RDMA WRITE WRs for a DATA OUT command, and
> properly account for RDMA WRITE WRs instead of just for RDMA READ WRs
> like the driver previously did.
>
> We now allocate half of the SQ size to RDMA READ/WRITE contexts, assuming
> by default one RDMA READ or WRITE operation per command.  If a command
> has multiple operations it will eat into the budget but will still succeed,
> possible after waiting for WQEs to be available.
>
> Also ensure the QPs request the maximum allowed SGEs so that RDMA R/W API
> works correctly.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
