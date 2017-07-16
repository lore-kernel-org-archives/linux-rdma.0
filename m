From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] i40iw: Simplify code
Date: Sun, 16 Jul 2017 08:11:20 -0700
Message-ID: <1500217880.4457.90.camel@perches.com>
References: <20170716110923.14907-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170716110923.14907-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-07-16 at 13:09 +0200, Christophe JAILLET wrote:
> Axe a few lines of code and re-use existing error handling path to avoid
> code duplication.

unrelated:

> diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
[]
> @@ -280,8 +278,7 @@ static enum i40iw_status_code add_bp_pages(struct i40iw_sc_dev *dev,
>  						     (info->pages << PBLE_512_SHIFT));
>  		if (status) {
>  			i40iw_pr_err("allocate PBLEs in the PF.  Error %i\n", status);

It'd be nice if i40iw_pr_<err|warn|info> were removed and
converted into dev_<err|warn|info> or netdev_<err|warn|info>.
