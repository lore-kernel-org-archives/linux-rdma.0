From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Multicast group pre-creation for TopSpin old stack
Date: Mon, 6 Sep 2010 19:43:27 +0300
Message-ID: <20100906164327.GD11502@me>
References: <4C835DDF.6000809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C835DDF.6000809-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yevgeny,

On 12:07 Sun 05 Sep     , Yevgeny Kliteynik wrote:
> 
> There's a hack in the SM to deal with TopSpin's non-compliant
> join compmask for IPoIB v4 multicast group ff12:401b:<pkey>::1
> The group is pre-defined and maintained as a well-known multicast
> group.
> 
> opensm/osm_prtn.c:
> 
>    232          /* workaround for TS */
>    233          /* FIXME: remove this upon TS fixes */
>    234          mc_rec.mgid = osm_ts_ipoib_mgid;
>    235          memcpy(&mc_rec.mgid.raw[4], &pkey, sizeof(pkey));
>    236          /* Scope in MCMemberRecord (if present) needs to be consistent with MGID */
>    237          mc_rec.scope_state = ib_member_set_scope_state(scope, IB_MC_REC_STATE_FULL_MEMBER);
>    238          ib_mgid_set_scope(&mc_rec.mgid, scope);
>    239
>    240          status = osm_mcmr_rcv_find_or_create_new_mgrp(p_sa, comp_mask, &mc_rec,
>    241                                                        &p_mgrp);
>    242          if (p_mgrp) {
>    243                  p_mgrp->well_known = TRUE;
>    244                  if (!p->mgrp)
>    245                          p->mgrp = p_mgrp;
>    246          }
> 
> As far as I can tell, this was added before git history.
> Any idea if it's still needed?

I don't know, just remember that we have asked about this during
partition manager development (somewhere in 2006), and have got an
answer like "it is probably needed".

Personally I've never seen this used. Maybe Hal may remember more.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
