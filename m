From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC 08/11] iser-target: Add base + proto includes
Date: Thu, 14 Mar 2013 13:26:42 +0200
Message-ID: <5141B3F2.50401@mellanox.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-9-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362707116-31406-9-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2013 03:45, Nicholas A. Bellinger wrote:
> +++ b/drivers/infiniband/ulp/isert/isert_base.h
> @@ -0,0 +1,123 @@
> +#include <linux/socket.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_fmr_pool.h>

you include rdma/ib_fmr_pool.h in multiple places but never use it, remove
