From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Wed, 21 Sep 2011 15:13:49 -0700
Message-ID: <20110921151349.140d95f6.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E66F5B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 21 Sep 2011 12:06:12 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> commit 1344cb3feacafc462440dabfa5997c5205486d83 added support for FDR10 in a way that is not compatible with Windows support.  Windows does not use files to read attribute information.
> 

Ok, I think you meant commit 1344cb3feacafc462440dabfa5997c5205486d83

> I will probably need to obtain the necessary information using ibverbs on windows by reading port attributes.  I don't think FDR10 support is available through ibverbs on linux yet, but would this be acceptable?  Is there some other way that you'd like to handle this?  The other option I can think of is moving is_fdr10() and sys_read_string() out of ibstat.c and into a linux specific file, so that windows can provide its own implementation.  Thoughts?
> 

Does this mean "ibstatus" does not work on Windows?

I was contemplating getting rid of ibstat as ibstatus (a script which uses sysfs exclusively) gave the same information without the dependency on libibumad.  With this patch we were trying to not break libibumad's ABI with this addition.

How are you proposing the addition to ibverbs?  It seems this would break ABI there.

Does windows have sysfs like capabilities which would make the separate layer clean?

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
