From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: make loopback console compile on by default.
Date: Mon, 11 Jul 2011 20:54:42 +0300
Message-ID: <20110711175442.GF2084@localhost.localdomain>
References: <20110706155435.ada5fbb6.weiny2@llnl.gov>
 <20110710091410.GB8520@localhost.localdomain>
 <5033C751-5B39-4F08-AB35-C595F17F6B6B@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5033C751-5B39-4F08-AB35-C595F17F6B6B-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 10:23 Mon 11 Jul     , Weiny, Ira K. wrote:
> 
> On Jul 10, 2011, at 2:14 AM, Alex Netes wrote:
> 
> > Hi Ira,
> > 
> > On 15:54 Wed 06 Jul     , Ira Weiny wrote:
> >> 
> >> The console is very useful for debugging and should be available in opensm.conf
> >> as an option.
> >> 
> >> Generic socket is still an option which is off for security reasons.
> >> 
> >> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> >> ---
> > 
> > I was digging a little in a history and one concern that was issued while socket
> > support was introduced is that it requires libwrap devel package, so any one
> > who lacks this package, opensm compilation will fail.
> 
> My intention was to disable console_looback if libwrap was not available.  But as I look at the configure.in I think there may be a bug in that logic.
> 
> I don't have a system without libwrap readily available so give me some time to fix this.
> 

I think though, that lack libwrap support is the only reason that socket
support wasn't included by default in the compilation.

Because the security threat by using sockets can be easily managed by opensm
configuration.

So what do you say regarding enabling all socket support during compilation,
unless libwrap is unavailable?

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
