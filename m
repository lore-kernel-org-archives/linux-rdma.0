From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/uverbs: Support for XRC
Date: Wed, 27 Jan 2010 11:13:22 +0200
Message-ID: <4B6003B2.4040101@voltaire.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>	<1264446094-4460-3-git-send-email-rolandd@cisco.com>	<4B5EFEAD.9040702@Voltaire.com> <aday6jko26n.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6jko26n.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> OK, but we should coordinate this with all the other ABI extensions that OFED has already made
I believe the only thing I need to coordinate with is the XRC patch set.

Jack, can you please direct me to the patch set I should be setting the 
modify_cq patches against? no problem if this is going to take some 
time, but I do want to push cq_modify in the same merge window with XRC, 
I assume we have at least couple of weeks for this to happen.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
