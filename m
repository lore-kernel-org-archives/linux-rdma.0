From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 4/9] IB/core: refactor ib_create_qp
Date: Tue, 8 Mar 2016 11:33:43 -0800
Message-ID: <56DF2917.309@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-5-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "sagig@mellanox.com" <sagig@mellanox.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2016 10:16 AM, Christoph Hellwig wrote:
> +	if (IS_ERR(qp))
> +		real_qp->device->destroy_qp(real_qp);
> +	else
> +		__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
> +	return qp;
> +}

My preference is to handle the "success" case first as in the original code:

-			if (!IS_ERR(qp))
-				__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
-			else
-				real_qp->device->destroy_qp(real_qp);

Even if this does not get addressed:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
