From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: enable perfmgr build by default
Date: Sun, 10 Jul 2011 11:54:18 +0300
Message-ID: <20110710085418.GA8520@localhost.localdomain>
References: <20110706151116.79c187ea.weiny2@llnl.gov>
 <20110708104927.GC7420@calypso.voltaire.com>
 <20110708090658.f15b95b0.weiny2@llnl.gov>
 <4E172F16.1000708@dev.mellanox.co.il>
 <20110708101313.60512582.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110708101313.60512582.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 10:13 Fri 08 Jul     , Ira Weiny wrote:
> On Fri, 8 Jul 2011 09:23:50 -0700
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> > Ira,
> > 
> > On 7/8/2011 12:06 PM, Ira Weiny wrote:
> > > However, when we first put the PerfMgr in OpenSM there was some concern for developers who may be using OpenSM in an embedded environment.
> > 
> > Do you recall the specific concerns ? I forget and would rather not dig
> > them out unless really necessary...
> 
> If I recall there was no "specific" concern just that someone _may_ do this.
> 
> Also I think there was some concern about the PerfMgr taking too much processing time with it's threads.  But I think that is configurable by the number of SMP's on the wire and turning it off if one prefers a different model.
> 

PerfMgr adds ~200K to opensm binary (34K when stripped).
During runtime PerfMgr adds ~270K to opensm memory allocation, when running
with PerfMgr disabled.

During the opensm initialization, osm_perfmgr_init() and osm_perfmgr_bind()
are called even if PerfMgr is disabled. I guess it's needed, if we want to
enable PerfMgr later on the fly.
I'm not sure though, how calling to osm_perfmgr_bind() affects performance.

One more thing, perfmgr_sweep() is called each (pm->sweep_time_s * 1000) no
matter if PerfMgr is enabled or disabled. Though it does nothing, I think it's
better to execute perfmgr_sweep() only when PerfMgr is enabled.


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
