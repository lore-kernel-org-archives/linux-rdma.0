From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 3/6] RDMA/core: expose affinity mappings per
 completion vector
Date: Fri, 28 Apr 2017 18:48:05 -0400
Message-ID: <1493419685.3041.174.camel@redhat.com>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
         <1491474998-16423-4-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491474998-16423-4-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-06 at 13:36 +0300, Sagi Grimberg wrote:
> This will allow ULPs to intelligently locate threads based
> on completion vector cpu affinity mappings. In case the
> driver does not expose a get_vector_affinity callout, return
> NULL so the caller can maintain a fallback logic.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> 

Acked-by: Doug Ledford <dledford@redhat.com>

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
