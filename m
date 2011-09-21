From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Wed, 21 Sep 2011 15:32:54 -0700
Message-ID: <20110921153254.06c77ebc.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<20110921151349.140d95f6.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6723E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 15:23:45 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Does this mean "ibstatus" does not work on Windows?
> 
> We do not support any of the scripts on windows.  As far as I could tell, the scripts look like they just do post-processing of available output.
>  

Good to know, thanks.

> > How are you proposing the addition to ibverbs?  It seems this would break ABI
> > there.
> 
> On windows, libibumad uses libibverbs to obtain whatever data it needs.  I'm assuming that a non-MAD application will eventually be able to use ibverbs to determine the rate, without needing to parse data from some file.
> 
> > Does windows have sysfs like capabilities which would make the separate layer
> > clean?
> 
> There's nothing like sysfs on windows.  If the data is available from ibverbs, windows could pull the data from there, even if the diags do not want to rely on ibverbs on the linux side.
> 

To be clear I am not against using ibverbs on the linux side.  It sounds like that would be the best move going forward.

Ira

> - Sean


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
