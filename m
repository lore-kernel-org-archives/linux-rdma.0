From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [ofw] ib-diags: compatability issue with ibstat
Date: Sun, 25 Sep 2011 23:19:54 -0700
Message-ID: <20110925231954.83ebd00c.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<CAKzyTsyH0rop69rTGUW_+kgfohyN-XiCLV4JsO9NLzyH9KpQAA@mail.gmail.com>
	<CAKzyTszJ8qbPMYgMFhAzkJVnGmgetggSU7BYN+1RxrVB3tBYqA@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E67777@ORSMSX101.amr.corp.intel.com>
	<CAKzyTswr6EMFPn1fBNujP1Lgb8b6MEcJ1uPbVqEt_nE1Er7dPw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E677A9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E677A9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 23 Sep 2011 10:15:04 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > 	1. Remove ibstat and use ibv_devinfo instead
> > 	2. Change ibstat to obtain the fdr10 information using ibverbs
> > 	3. Move the is_fdr10 functionality into OS specific files or code
> > sections of ibstat
> > 	4. Change ibstat to obtain fdr10 data using MADs or some other OS
> > independent mechanism
> > 	5. Change ibumad so that it provides the fdr10 data
> > 	  Note: umad has OS dependent implementation anyway, but the windows
> > umad would
> > 	        depend on the data being available from ibverbs
> > 	6. ???
> > 
> > 	Can someone explain why the information can't come from the
> > umad_port::rate field?
> > 
> > 
> > Because fdr10 is non standard, there's no rate for this; it overloads QDR
> > based rates as both are 10 Gbps but have different link encodings.
> 
> Ok, then for choices 6-8:
> 
> 6. Have ibstat just report the rate without specifying the link encoding
> 7. Use umad_port:rate to encode the rate, link encoding, inter-packet delay, etc.
>    (I'm only partially kidding here.)
> 8. Drop ibstat from windows.  Windows users will be directed to use ibv_devinfo.
> 
> Ira, what are your thoughts on this?

I don't think 6 is really an option.  Reporting FDR10 as QDR will just confuse
people.

Option 7 might be possible.  But I don't think it is really the best way to
proceed, see below.

I think adding link encoding to ibverbs would be nice.  However, this is not
standard.  So it muddy's ibverbs.

Getting the data from a vendor MAD is probably the only _compliant_ way to do
this.  However, this means ibv_devinfo can not be the conical tool for this
information without a dependency on libibumad.

So it looks like option 4 is best.  Since I don't have this hardware I have to
go by the code Hal provided.  It looks like we can see an FDR10 capable HCA is
indicated by the devid.  For the devid's which are FDR10 query the Vendor MAD
and report the special rate.

I think this is really the only solution at this time.  I really wanted to
replace ibstat with ibv_devinfo but it looks like that will not be possible
without mudding ibverbs.[*]

The code to query the "Mellanox extended PortInfo" is in libibnetdisc &
libibmad.  I just want to think a bit about how to make it available to
smpquery, libibnetdisc, and ibstat in a clean manner.  Otherwise I would have
a patch.

Ira

[*] Roland is free to chime in here.

-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
