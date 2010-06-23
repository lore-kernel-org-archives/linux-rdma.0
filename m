From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2 1/3] RDMA/cxgb4: derive smac_idx from port viid.
Date: Wed, 23 Jun 2010 13:53:38 -0500
Message-ID: <4C225832.1010501@opengridcomputing.com>
References: <20100623154643.22600.20003.stgit@build.ogc.int> <adaiq59two6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq59two6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> what's smac_idx?  what's port viid?
> hard to know what the heck this fixes :)
>   

smac_idx == source mac index:  the index into the HW source mac table. 

viid = Virtual Interface ID: for virtualization, this allows having smac 
tables, among other things, per virtual device.  I was incorrectly 
computing the smac_idx in my previous code.  But it worked until a 
recent FW change I think.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
