From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/2] infiniband-diags/src/ibqueryerrors.c: fix segv due
 to CA port 0 reference
Date: Tue, 27 Sep 2011 17:29:20 -0700
Message-ID: <20110927172920.ad114c31.weiny2@llnl.gov>
References: <1317163951-25948-1-git-send-email-marcus.r.epperson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317163951-25948-1-git-send-email-marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 27 Sep 2011 15:52:30 -0700
Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> Signed-off-by: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I am curious if you have actually hit this bug.  I have not run into any non-switches which set AllPortSelect which would lead to this condition.[*]  In this case was it your intention to suppress the errors for "all" ports and allow the individual ports to print?  I believe this is the correct behaviour.

Also, I assume this patch and 2/2 must go together.  However, this patch should include the braces from patch 2 to disambiguate the else statement.  Could you redo the series for that?

Thanks,
Ira

[*] but apparently the spec does not limit AllPortSelect to switches...

> ---
>  src/ibqueryerrors.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index fa116a9..230f6b2 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -427,8 +427,9 @@ static int print_results(ib_portid_t * portid, char *node_name,
>  		}
>  
>  		if (portnum == 0xFF)
> -			printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
> -			       node->ports[0]->guid, str);
> +			if (node->type == IB_NODE_SWITCH)
> +				printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
> +				       node->ports[0]->guid, str);
>  		else
>  			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
>  			       node->ports[portnum]->guid, portnum, str);
> -- 
> 1.7.4.1
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
