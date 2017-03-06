From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] IB/nes: Delete unnecessary braces
Date: Mon, 06 Mar 2017 10:37:31 -0800
Message-ID: <1488825451.2210.14.camel@perches.com>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
         <c1546de1-468e-12f9-b31d-e6cf9e38d148@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <c1546de1-468e-12f9-b31d-e6cf9e38d148@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-06 at 18:43 +0100, SF Markus Elfring wrote:
> Do not use curly brackets at some source code places
> where a single statement should be sufficient.
[]
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
[]
> @@ -137,11 +136,7 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
>  		nes_put_cqp_request(nesdev, cqp_request);
>  		kfree(nesmr);
>  		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
> -		if (!ret) {
> -			return ERR_PTR(-ETIME);
> -		} else {
> -			return ERR_PTR(-ENOMEM);
> -		}
> +		return ERR_PTR(ret ? -ENOMEM : -ETIME);

Using a goto error label for this block would
probably be more common kernel style ere.

