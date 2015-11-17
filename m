From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-next 06/10] iser-target: Remove unused file
 iser_proto.h
Date: Tue, 17 Nov 2015 01:00:46 -0800
Message-ID: <20151117090046.GD19578@infradead.org>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-7-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447691861-3796-7-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

Sorry for the nitpicking, but:

> +/*Constant PDU lengths calculations */

This really needs a space before the 'C'.

> +#define ISER_HEADERS_LEN	(sizeof(struct iser_ctrl) + sizeof(struct iscsi_hdr))

Also fixing lines over 8- characters would be nice.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
