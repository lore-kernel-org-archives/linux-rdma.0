From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Mon, 27 Aug 2012 17:51:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8B2AD@ORSMSX101.amr.corp.intel.com>
References: <502AC3DC.9090102@mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com>
 <20120814215413.GA29245@obsidianresearch.com>
 <503A2814.6030709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503A2814.6030709-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 8/15/2012 12:54 AM, Jason Gunthorpe wrote:
> > On Tue, Aug 14, 2012 at 09:39:23PM +0000, Hefty, Sean wrote:
> >>> +#define if_PF(cond)		if(CL_PREDICT_FALSE(cond))
> >>> +#define if_PT(cond)		if(CL_PREDICT_TRUE(cond))
> >>
> >> If CL_PREDICT_TRUE/FALSE are too long, why not just shorten those,
> >> rather than abstract if statements behind a macro?
> 
> It's not the size - it's just the readability of the macro.
> First macro (CL_PREDICT_*) is close to the GCC's way to define
> it. Second macro (if_PF/T) is close to the usual 'if' statement
> syntax.

I would not abstract the 'if' statement.  If CL_PREDICT_FALSE/TRUE are not readable, then shorten those.

if (PF(...))

is just as readable as

if_PF(...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
