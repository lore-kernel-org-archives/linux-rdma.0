From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 03/12] ib_core: IBoE UD packet packing support
Date: Thu, 14 Oct 2010 21:27:40 -0700
Message-ID: <adalj60hygz.fsf@cisco.com>
References: <20100826141756.GD8795@mtldesk30> <adazkugildn.fsf@cisco.com>
	<20101014212658.GC13969@mtldesk30> <adapqvcih6l.fsf@cisco.com>
	<20101014215758.GA15089@mtldesk30>
	<35AAF1E4A771E142979F27B51793A488873ABE0767@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A488873ABE0767-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Ralph Campbell's message of "Thu, 14 Oct 2010 15:34:24 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > >       if (header->immediate_present)
 > 
 > This should be "if (immediate_present)".
 > header->immediate_present is zero due to the memset() above.

Thanks, fixed that up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
