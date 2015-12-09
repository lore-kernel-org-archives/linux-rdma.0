From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 05/10] iser: Have initiator and target to share
 protocol structures and definitions
Date: Wed, 9 Dec 2015 11:33:50 -0800
Message-ID: <20151209193350.GD21477@infradead.org>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449663128-368-6-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

> -/* Constant PDU lengths calculations */
> -#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
> +/*Constant PDU lengths calculations */

Odd whitespace error.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
