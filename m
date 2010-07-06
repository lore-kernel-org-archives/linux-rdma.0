From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 2/4]  New RAW_PACKET QP  type definition
Date: Tue, 06 Jul 2010 09:13:17 +0300
Message-ID: <4C32C97C.6020100@voltaire.com>
References: <4C308E07.7050903@senin.name> <4C3092ED.6000701@senin.name>	<4C3095CB.2000205@senin.name> <4C31E3E4.8020508@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C31E3E4.8020508-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve Wise wrote:
> Would it be better to just put the XRC QP type enum in with this patch? 
You can take a look on the xrc branch @ Roland's kernel.org git tree, it 
has a patch with the XRC QP enum, and I believe what this patch is 
attempting to do, is not introducing a dependency  among the xrc and 
"raw" qp patch sets.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
