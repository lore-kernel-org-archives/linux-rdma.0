From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: fix insert
 of invalid lid 0xFFFF into lid_port hash_table
Date: Sat, 25 Jan 2014 01:22:39 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04ADA4C4@CRSMSX101.amr.corp.intel.com>
References: <52C18853.8080107@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E04A93D22@CRSMSX101.amr.corp.intel.com>
 <52D3E42C.4030201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52D3E42C.4030201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Monday, January 13, 2014 5:04 AM
> To: Weiny, Ira
> Cc: Ira Weiny; linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Dan Ben-Yosef
> Subject: Re: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: fix insert of
> invalid lid 0xFFFF into lid_port hash_table
> 
> On 1/12/2014 10:34 AM, Weiny, Ira wrote:
> > Good catch some comments below.
> >
> >> -----Original Message-----
> >> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> >> Sent: Monday, December 30, 2013 6:51 AM
> >> To: Ira Weiny
> >> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Dan Ben-Yosef
> >> Subject: [PATCH infiniband-diags] libibnetdisc/ibnetdisc.c: fix
> >> insert of invalid lid 0xFFFF into lid_port hash_table
> >>
> >> From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  libibnetdisc/src/ibnetdisc.c |   12 +++++++-----
> >>  1 files changed, 7 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/libibnetdisc/src/ibnetdisc.c
> >> b/libibnetdisc/src/ibnetdisc.c index
> >> 9d120dd..121fe35 100644
> >> --- a/libibnetdisc/src/ibnetdisc.c
> >> +++ b/libibnetdisc/src/ibnetdisc.c
> >> @@ -647,11 +647,13 @@ void add_to_portlid_hash(ibnd_port_t * port,
> >> GHashTable *htable)
> >>  	uint16_t base_lid = port->base_lid;
> >>  	uint16_t lid_mask = ((1 << port->lmc) -1);
> >>  	uint16_t lid = 0;
> >> -
> >> -	/* We add the port for all lids
> >> -	 * so it is easier to find any "random" lid specified */
> >> -	for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> >> -		g_hash_table_insert(htable, GINT_TO_POINTER(lid), port);
> >> +	/* 0 < valid lid <= 0xbfff */
> >> +	if (base_lid > 0 && base_lid <= 0xbfff) {
> >
> > Shouldn't we check the "max LID" (based on LMC) here to make sure they
> are all vaild?
> 
> I guess it depends how strict we want to be for this check and whether it's
> consistent with other such checks in the library.

As this fixes a bug I'll apply it.

Thanks applied.

> 
> I think that the check of the base LID based on the LMC should be a separate
> additional check. Is this currently done anywhere else in the library ?

The library does not perform any checks as it does not rely on the lids for any processing.  It is simply reporting what is out there.  So things like duplicate LID's could be checked for.

Ira

> 
> -- Hal
> 
> >
> > Ira
> >
> >> +		/* We add the port for all lids
> >> +		 * so it is easier to find any "random" lid specified */
> >> +		for (lid = base_lid; lid <= (base_lid + lid_mask); lid++) {
> >> +			g_hash_table_insert(htable, GINT_TO_POINTER(lid),
> >> port);
> >> +		}
> >>  	}
> >>  }
> >>
> >> --
> >> 1.7.8.2
> >
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
