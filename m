From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 09:14:53 -0800
Message-ID: <20091215091453.a3c315ae.weiny2@llnl.gov>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	<20091215170317.GV5262@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215170317.GV5262@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2009 19:03:17 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> On 16:43 Mon 14 Dec     , Ira Weiny wrote:
> > 
> > I have found that the following patch caused our SRP connected storage to
> > break.
> > 
> > patch: 3d20f82edd3246879063b77721d0bcef927bdc48
> > 
> >     opensm/osm_sa_path_record.c: separate router guid resolution code
> >     
> >     Move off subnet destination (router address) resolution code to separate
> >     function to improve readability.
> >     
> >     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > 
> > I further traced the problem to pr_rcv_build_pr and the patch below fixes the
> > bug.
> 
> Nice catch and great investigation!
> 
> > 
> > 16:03:34 > git diff 
> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> > index be0cd71..32c889f 100644
> > --- a/opensm/opensm/osm_sa_path_record.c
> > +++ b/opensm/opensm/osm_sa_path_record.c
> > @@ -800,7 +800,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
> >  
> >         /* Only set HopLimit if going through a router */
> >         if (is_nonzero_gid)
> > -               p_pr->hop_flow_raw |= cl_hton32(IB_HOPLIMIT_MAX);
> > +               p_pr->hop_flow_raw |= IB_HOPLIMIT_MAX;
> >  
> >         p_pr->pkey = p_parms->pkey;
> >         ib_path_rec_set_sl(p_pr, p_parms->sl);
> > 
> > 
> > "hop_flow_raw" is not really a 32bit value but rather 4 fields:
> > Component     Length(bits)   Offset(bits)
> > RawTraffic    1              352
> > Reserved      3              353
> > FlowLabel     20             356
> > HopLimit      8              384
> 
> This patch doesn't look correct for me. Instead of placing
> IB_HOPLIMIT_MAX in proper place this will put it in RawTraffic and
> Reserved fields on little-endian machines (such as x86). And this
> changes nothing on a big-endian machine. Right?

Yea I think this is wrong.  As I said perhaps the FW on the other side is
interpreting the fields wrong.  I will check with the vendor.

> 
> Following your investigation it seems that SRP target breaks when
> IB_HOPLIMIT_MAX is set in SA PR query responses for intra-subnet DGIDs.

Yes

> 
> > However, I don't understand the comment "Only set HopLimit if going through a
> > router"?
> 
> This is from '#ifdef ROUTER_EXP' days - as far as I could understand
> HopLimit should be set to IB_HOPLIMIT_MAX for inter-subnet MADs.

But I have not found where that is stated.

> 
> > 
> > Was the intent to only set p_dgid in pr_rcv_get_end_points if we are heading
> > through a router?
> 
> Seems that this was an original logic.
> 
> > I don't think it matters if we are going through a router
> > or not does it?
> 
> I thought so too, but as we can see it triggers the bug you discovered.
> 
> So immediate fix for this is to move p_dgid setup back to router
> section, like this:
> 
> 
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> index 7855be5..fbeef03 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -1236,6 +1236,8 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
>  				sa_status = IB_SA_MAD_STATUS_INVALID_GID;
>  				goto Exit;
>  			}
> +			if (p_dgid)
> +				*p_dgid = p_pr->dgid;
>  		} else
>  			dest_guid = p_pr->dgid.unicast.interface_id;
>  
> @@ -1253,9 +1255,6 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
>  			sa_status = IB_SA_MAD_STATUS_INVALID_GID;
>  			goto Exit;
>  		}
> -
> -		if (p_dgid)
> -			*p_dgid = p_pr->dgid;
>  	} else {
>  		*pp_dest_port = 0;
>  		if (comp_mask & IB_PR_COMPMASK_DLID) {
> 
> 
> BTW, could you test this? Unfortunately I don't have SRP target :(

Yes this works and was my original fix.  However, it did not seem right and I
think Hal agrees.

> 
> And seems that as more solid solution we need to cleanup some logic in
> osm_sa_path_record.c code.

I think so.

Ira

> 
> Sasha


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
