From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Thu, 26 Nov 2009 09:26:31 +0200
Message-ID: <4B0E2DA7.7060809@voltaire.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>	<4B0CDBEC.1030203@voltaire.com>	<10904370-1D66-4013-BB3F-0F4B5EE581EE@cisco.com>	<4B0D4660.5060701@voltaire.com> <4B0D8FD2.9000702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0D8FD2.9000702-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pasha-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Pavel Shamis (Pasha) wrote:
> The patch is attached
Thanks, this patch basically replaces checks for the device transport 
type to be IB to a check that makes sure either the former happens or 
the port transport type is rdmaoe. As Jason, Tziporet and noted, the 
port transport type seems to be bad and non-comapatible/operable idea, 
so it should and probably could be avoided.

I see another patch @ 
http://www.open-mpi.org/community/lists/devel/2009/11/7063.php
can you send that one as well. The you sent patch isn't signed so I 
can't address the author in further replies (unless you are the author), 
also it wasn't generated with the -p option of diff which would show for 
each change what is the effected function, doing so would help in the 
review.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
