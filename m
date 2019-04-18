From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/hfi1: Failed to drain send queue when QP is put into
 error state
Date: Thu, 18 Apr 2019 03:22:53 -0300
Message-ID: <20190418062253.GD3206@ziepe.ca>
References: <20190416130904.22423.32305.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190416130904.22423.32305.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Kaike Wan <kaike.wan@intel.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 16, 2019 at 06:09:07AM -0700, Kaike Wan wrote:
> commit 662d66466637862ef955f7f6e78a286d8cf0ebef upstream.
> 
> When a QP is put into error state, all pending requests in the send
> work queue should be drained. The following sequence of events could
> lead to a failure, causing a request to hang:
> (1) The QP builds a packet and tries to send through SDMA engine.
> However, PIO engine is still busy. Consequently, this packet is put
> on the QP's tx list and the QP is put on the PIO waiting list. The
> field qp->s_flags is set with HFI1_S_WAIT_PIO_DRAIN;
> (2) The QP is put into error state by the user application and
> notify_error_qp() is called, which removes the QP from the PIO waiting
> list and the packet from the QP's tx list. In addition, qp->s_flags
> is cleared of RVT_S_ANY_WAIT_IO bits, which does not include
> HFI1_S_WAIT_PIO_DRAIN bit;
> (3) The hfi1_schdule_send() function is called to drain the QP's send
> queue. Subsequently, hfi1_do_send() is called. Since the flag bit
> HFI1_S_WAIT_PIO_DRAIN is set in qp->s_flags, hfi1_send_ok() fails.
> As a result, hfi1_do_send() bails out without draining any request
> from the send queue;
> (4) The PIO engine completes the sending and tries to wake up any QP
> on its waiting list. But the QP has been removed from the PIO waiting
> list and therefore is kept in sleep forever.
> 
> The fix is to clear qp->s_flags of HFI1_S_ANY_WAIT_IO bits in step (2).
> HFI1_S_ANY_WAIT_IO includes RVT_S_ANY_WAIT_IO and HFI1_S_WAIT_PIO_DRAIN.

Why are you sending this to stable with a different commit message
than upstream has for the same commit?

Jason
