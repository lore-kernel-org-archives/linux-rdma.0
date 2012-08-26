From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Sun, 26 Aug 2012 16:43:48 +0300
Message-ID: <503A2814.6030709@dev.mellanox.co.il>
References: <502AC3DC.9090102@mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com> <20120814215413.GA29245@obsidianresearch.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120814215413.GA29245-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry for the delay with a response - just got back from a long vacation.

On 8/15/2012 12:54 AM, Jason Gunthorpe wrote:
> On Tue, Aug 14, 2012 at 09:39:23PM +0000, Hefty, Sean wrote:
>>> +#define if_PF(cond)		if(CL_PREDICT_FALSE(cond))
>>> +#define if_PT(cond)		if(CL_PREDICT_TRUE(cond))
>>
>> If CL_PREDICT_TRUE/FALSE are too long, why not just shorten those,
>> rather than abstract if statements behind a macro?

It's not the size - it's just the readability of the macro.
First macro (CL_PREDICT_*) is close to the GCC's way to define
it. Second macro (if_PF/T) is close to the usual 'if' statement
syntax.

If you think it's a deal breaker, I can lose the first macro and
have everything in one macro.

> If you are typing these so often (ie more than in some datastructure
> kernels) that the length is a problem then you really should be using
> profile guided optimization instead...

I'm trying to optimize all the 'if' conditions in the SM.
As I described in patch 3/8 (next patch in these series),
I don't touch all the non-fatal cases. The goal is not to
help SM to perform better in general (in which case I agree
than PGO would be the right way to go), but to make sure
that the fatal cases will never be predicted wrong, so any
fatal check (existing or a newly added one) won't affect
the SM performance.

Also, the plan is to define a new ASSERT macro that will
use this if_PF thing to make sure that ASSERT statement
doesn't cost much (if any).

-- YK

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
