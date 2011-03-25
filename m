From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH/infiniband-diags] Fix missing $IBPATH in ibdatacounts
Date: Thu, 24 Mar 2011 17:47:04 -0700
Message-ID: <20110324174704.44f4787d.weiny2@llnl.gov>
References: <20110322212559.GA4954@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110322212559.GA4954-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks applied.
Ira

On Tue, 22 Mar 2011 14:25:59 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Otherwise it blows up if smpquery is not in the search path.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  scripts/ibdatacounts.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/ibdatacounts.in b/scripts/ibdatacounts.in
> index a9e94c0..b64547b 100644
> --- a/scripts/ibdatacounts.in
> +++ b/scripts/ibdatacounts.in
> @@ -106,7 +106,7 @@ else
>  	fi
>  fi
>  
> -nodename=`smpquery $ca_info nodedesc $lid | sed -e "s/^Node Description:\.*\(.*\)/\1/"`
> +nodename=`$IBPATH/smpquery $ca_info nodedesc $lid | sed -e "s/^Node Description:\.*\(.*\)/\1/"`
>  
>  text="`eval $IBPATH/perfquery $ca_info $lid $portnum`"
>  rv=$?
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
