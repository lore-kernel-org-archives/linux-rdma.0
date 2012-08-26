From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/8] opensm/complib: define "if" statements with branch
 prediction hints
Date: Sun, 26 Aug 2012 16:56:58 +0300
Message-ID: <503A2B2A.8000305@dev.mellanox.co.il>
References: <502AC3DC.9090102@mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237346A892A4@ORSMSX101.amr.corp.intel.com> <20120814215413.GA29245@obsidianresearch.com> <503A2814.6030709@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <503A2814.6030709-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/26/2012 4:43 PM, Yevgeny Kliteynik wrote:
> 
>> If you are typing these so often (ie more than in some datastructure
>> kernels) that the length is a problem then you really should be using
>> profile guided optimization instead...
> 
> I'm trying to optimize all the 'if' conditions in the SM.

Obviously, what I meant is that I'm *not* trying to optimize
all the 'if' conditions in the SM...  :)

-- YK

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
