From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Thu, 17 Dec 2015 22:40:25 +0200
Message-ID: <20151217204025.GA29716@leon.nu>
References: <20151217195255.334854705@linux.com>
 <20151217195312.334770847@linux.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151217195312.334770847-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There are number of minor issues:
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
                        ^^^^^^^

On Thu, Dec 17, 2015 at 01:52:58PM -0600, Christoph Lameter wrote:
> -	in_mad->data[41] = port_num;	/* PortSelect field */
> +	if (port_num)
> +		in_mad->data[41] = port_num;	/* PortSelect field */
in_mad was created with kzalloc with all fields zeroed by default, so
you can drop if(port_num) condition.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
