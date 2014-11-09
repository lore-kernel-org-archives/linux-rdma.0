From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 1/5] IB/core: Add DC transport support
Date: Sun, 9 Nov 2014 10:02:42 +0200
Message-ID: <20141109080242.GA2698@mtldesk30>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
 <1415289159-4376-2-git-send-email-eli@mellanox.com>
 <545BA435.2010209@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <545BA435.2010209-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 06, 2014 at 06:39:17PM +0200, Or Gerlitz wrote:
> On 11/6/2014 5:52 PM, Eli Cohen wrote:
> >ib_modify_qp_ex - is an extension to ib_modify_qp which allows to pass the 64
> >bit DC key.
> 
> we don't add new such kernel verb, probably just left over in the
> change-log from earlier internal version, right?

Right, but it is available for userspace through
ib_uverbs_ex_modify_qp.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
