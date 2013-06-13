From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: ibstat fix strncpy coverity check and
 -l bug
Date: Wed, 12 Jun 2013 21:10:09 -0700
Message-ID: <20130612211009.45e17c65026cb41e552b9aa1@intel.com>
References: <20130612170307.8eb7f51c4b68512db703615a@intel.com>
	<51B922B2.3020404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B922B2.3020404-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 12 Jun 2013 21:38:58 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 6/12/2013 8:03 PM, Ira Weiny wrote:
> 
> This seems like 2 different patches to me.

Not really...

> 
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  src/ibstat.c |    9 ++-------
> >  1 files changed, 2 insertions(+), 7 deletions(-)
> > 
> > @@ -324,12 +325,6 @@ int main(int argc, char *argv[])
> >  		return 0;
> >  	}
> >  
> > -	if (!list_only && argc) {
> 
> I think I see the issue. Rather than eliminate this if clause, I think
> the line above should be:
> 
> 	if (!list_only && argc > 1) {
> 
> so that this properly handles the case when the port option is supplied.

V2 on the way.  I think we should still get rid of that if clause but your right I broke the "port" parameter.

Ira

> 
> -- Hal
> 
> > -		if (ca_stat(argv[0], dev_port, short_format) < 0)
> > -			IBPANIC("stat of IB device '%s' failed", argv[0]);
> > -		return 0;
> > -	}
> > -
> >  	for (i = 0; i < n; i++) {
> >  		if (list_only)
> >  			printf("%s\n", names[i]);
> 


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
