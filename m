From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix bug when
 attempting a sub-fabric scan
Date: Tue, 29 Sep 2009 10:25:56 -0700
Message-ID: <20090929102556.140506c7.weiny2@llnl.gov>
References: <20090923144555.9efa2c75.weiny2@llnl.gov>
	<20090929154145.GA9465@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090929154145.GA9465@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: OpenFabrics <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 29 Sep 2009 17:41:45 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 14:45 Wed 23 Sep     , Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Wed, 23 Sep 2009 14:26:55 -0700
> > Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: fix bug when attempting a sub-fabric scan
> > 
> > 	Also ibd_sm_id is never valid in this tool as the "-s" option is used
> > 	for "suppress"

To answer your question below:

Because the ibd_sm_id is never going to be overridden because the "-s" option is used for "suppress".  So NULL should used for the default for now.  I did not want to change the -s option now.  Some day I can fix this up to be consistent with the other tools.  Sorry.

> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  infiniband-diags/src/ibqueryerrors.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
> > index f73ca6f..892e539 100644
> > --- a/infiniband-diags/src/ibqueryerrors.c
> > +++ b/infiniband-diags/src/ibqueryerrors.c
> > @@ -441,8 +441,8 @@ int main(int argc, char **argv)
> >  	} else if (switch_guid_str) {
> >  		if ((resolved =
> >  		     ib_resolve_portid_str_via(&portid, switch_guid_str,
> > -					       IB_DEST_GUID, ibd_sm_id,
> > -					       ibmad_port)) >= 0)
> > +					       IB_DEST_GUID, NULL,
> 
> BTW, why should 'ibd_sm_id' be replaced by NULL?

See above,
Ira

> 
> Sasha
> 
> > +					       ibmad_port)) < 0)
> >  			IBWARN("Failed to resolve %s; attempting full scan\n",
> >  			       switch_guid_str);
> >  	}
> > -- 
> > 1.5.4.5
> > 


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
