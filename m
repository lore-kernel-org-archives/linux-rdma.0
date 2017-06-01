From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2] IB/srp: Fix NULL deref at srp_destroy_qp()
Date: Thu, 01 Jun 2017 18:10:32 -0400
Message-ID: <1496355032.7171.58.camel@redhat.com>
References: <1494517956-26669-1-git-send-email-israelr@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1494517956-26669-1-git-send-email-israelr@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Israel Rukshin <israelr@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-11 at 18:52 +0300, Israel Rukshin wrote:
> If srp_init_qp() fails at srp_create_ch_ib() then ch->send_cq
> may be NULL.
> Calling directly to ib_destroy_qp() is sufficient because
> no work requests were posted on the created qp.
> 
> Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying
> a QP")
> Signed-off-by: Israel Rukshin <israelr@mellanox.com>
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
