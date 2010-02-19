From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: how to force opensmd to recalculate all paths?
Date: Fri, 19 Feb 2010 09:53:01 -0800
Message-ID: <20100219095301.4fc02e54.weiny2@llnl.gov>
References: <20100219114252.4060E3D1821@f53.poczta.interia.pl>
	<1266600846.22111.199.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1266600846.22111.199.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chu11-i2BcT+NCU+M@public.gmane.org
Cc: kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 19 Feb 2010 09:34:06 -0800
Al Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Hi Kovlensky,
> 
> I'm unsure of what version of Opensm this was added in, but the opensm
> console (see opensm manpage for console info), there is a "resweep
> [heavy|light]" command.  Running "resweep heavy" should do exactly what
> you need.

Alternately, from the man page.

NOTES
       When opensm receives a HUP signal, it starts a new heavy sweep as if a trap was received or a topology change was found.

Ira

> 
> Al
> 
> On Fri, 2010-02-19 at 12:42 +0100, kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org wrote:
> > Hi,
> > 
> > My case is simple - opensm does not recalculate paths unless necessary,
> > i.e. one of physical links on the way disappears. I just introduced
> > significant topology changes and need opensm to take them into
> > consideration. New links were added, a lot of them. Is there any way of
> > telling opensm to recalculate all paths? At the moment all new links are
> > happily ignored and i can find no way of doing that live.
> > 
> > My vendor has bad habit of asking me to add ib link here and there to
> > nullify bottleneck identified and, well, while all new paths are up, I can
> > find no way of rebalancing paths, so they stay unused.
> > 
> > I'm running OFED-1.3.2-20090119-0501, so all ideas for this version or a
> > newer one are welcome.
> > 
> > Regards,
> > 
> > kovlensky
> > 
> > 
> > ----------------------------------------------------------------------
> > Szybkie i niedrogie... Tylko dla mezczyzn!
> > Sprawdz >>> http://**link.interia.pl/f25a7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://**vger.kernel.org/majordomo-info.html
> > 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


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
