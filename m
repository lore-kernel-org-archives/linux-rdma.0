From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH/infiniband-diags] Fix ibdatacounters
Date: Thu, 24 Mar 2011 17:47:14 -0700
Message-ID: <20110324174714.b132d947.weiny2@llnl.gov>
References: <20110322221145.GB4954@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110322221145.GB4954-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, applied.
Ira

On Tue, 22 Mar 2011 15:11:45 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Commit fb3b1e753d527faa08f863a55f7f8392fb01f2ed switched the call
> to ibdatacounts with ibcheckerrs which breaks the point of the script,
> put it back.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  scripts/ibdatacounters.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/ibdatacounters.in b/scripts/ibdatacounters.in
> index 1abaaf2..8fad62e 100644
> --- a/scripts/ibdatacounters.in
> +++ b/scripts/ibdatacounters.in
> @@ -85,7 +85,7 @@ function check_node(lid, port)
>  		print "\n# " ntype ": nodeguid 0x" nodeguid " failed"
>  		return 1;
>  	}
> -	return system("'$IBPATH'/ibcheckerrs '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
> +	return system("'$IBPATH'/ibdatacounts '"$ca_info"' '$gflags' '$verbose' '$brief' " lid " " port);
>  }
>  
>  /^Ca/ || /^Switch/ || /^Rt/ {
> -- 
> 1.7.1
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
