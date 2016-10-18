From: "ira. weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH TRIVIAL infiniband-diags] ibaddr.c: Fix LID printfs to be unsigned rather than signed
Date: Tue, 18 Oct 2016 12:27:08 -0400
Message-ID: <20161018162707.GB16254@phlsvsds.ph.intel.com>
References: <b0f11628-e2ef-15d9-5a9e-68edbc81ca77@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b0f11628-e2ef-15d9-5a9e-68edbc81ca77-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 26, 2016 at 07:38:46AM -0400, Hal Rosenstock wrote:
> 
> %u is what's used in other places for unicast LIDs
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/ibaddr.c b/src/ibaddr.c
> index 5845b4e..1a721d0 100644
> --- a/src/ibaddr.c
> +++ b/src/ibaddr.c
> @@ -83,7 +83,7 @@ static int ib_resolve_addr(ib_portid_t * portid, int portnum, int show_lid,
>  		printf("LID start 0x%x end 0x%x", portid->lid,
>  		       portid->lid + (1 << lmc) - 1);
>  	else if (show_lid < 0)
> -		printf("LID start %d end %d", portid->lid,
> +		printf("LID start %u end %u", portid->lid,
>  		       portid->lid + (1 << lmc) - 1);
>  	printf("\n");
>  	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
