From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v4 2/2] IB/qib: use arch_phys_wc_add()
Date: Tue, 21 Apr 2015 16:17:18 -0600
Message-ID: <20150421221718.GA10836@obsidianresearch.com>
References: <1429653035-19424-1-git-send-email-mcgrof@do-not-panic.com>
 <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429653035-19424-3-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, luto@amacapital.net, mst@redhat.com, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Roland Dreier <roland@purestorage.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Dave Hansen <dave>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 02:50:35PM -0700, Luis R. Rodriguez wrote:
> -	if (qib_wc_pat) {
> -		resource_size_t vl15off;
> -		/*
> -		 * We do not set WC on the VL15 buffers to avoid
> -		 * a rare problem with unaligned writes from
> -		 * interrupt-flushed store buffers, so we need
> -		 * to map those separately here.  We can't solve
> -		 * this for the rarely used mtrr case.
> -		 */
> -		ret = init_chip_wc_pat(dd, 0);
> -		if (ret)
> -			goto bail;
> +	/*
> +	 * We do not set WC on the VL15 buffers to avoid
> +	 * a rare problem with unaligned writes from
> +	 * interrupt-flushed store buffers, so we need
> +	 * to map those separately here.  We can't solve
> +	 * this for the rarely used mtrr case.
> +	 */

This is a small change in behavior, but it doesn't seem important..

Mike, what do you think about adding:

 if (dd->wc_cookie)
    dev_err(.., "Using this device without CPU PAT support is known to be broken");

or similar..

Jason
