From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Tue, 11 Sep 2012 18:23:48 +0300
Message-ID: <504F5784.5080709@dev.mellanox.co.il>
References: <502AC3DC.9090102@mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com> <20120814215413.GA29245@obsidianresearch.com> <503A2814.6030709@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237346A8B2AD@ORSMSX101.amr.corp.intel.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8B2AD-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> I would not abstract the 'if' statement.  If CL_PREDICT_FALSE/TRUE are not readable, then shorten those.
> 
> if (PF(...))
> 
> is just as readable as
> 
> if_PF(...)

OK, agree.
I'll issue a v2 shortly - the only difference would be
change in this macro and rebase to the updated trunk.

-- YK

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
