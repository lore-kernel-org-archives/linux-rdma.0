From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 13:11:02 -0800
Message-ID: <20130222131102.4280ba70de0e5791a6338833@llnl.gov>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
	<5127B87E.5020907@dev.mellanox.co.il>
	<20130222202314.GB10206@obsidianresearch.com>
	<5127DB75.60709@dev.mellanox.co.il>
	<20130222210117.GB15093@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222210117.GB15093-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Feb 2013 14:01:17 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Fri, Feb 22, 2013 at 03:56:21PM -0500, Hal Rosenstock wrote:
> 
> > >>> +char * umad_class_str(uint8_t mgmt_class)
> > >>> +{
> > >>> +	switch (mgmt_class) {
> > >>> +		case UMAD_CLASS_SUBN_LID_ROUTED:
> > >>> +		case UMAD_CLASS_SUBN_DIRECTED_ROUTE:
> > >>> +			return("Subn");
> > > 
> > > Doesn't this create a compiler warning? 
> > 
> > Not with my setup.
> > 
> > > Is -Wall turned on? 
> > 
> > Yes but maybe it depends on gcc version.
> 
> Looks like gcc needs -Wwrite-strings to get constness warnings for
> strings. 
> 
> I strongly recommend getting constness correct for library entry
> points. It is a huge PITA to use const broken libraries from code that
> is const correct.

You are correct.  Added in V<whatever we are on now>...  :-(

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
