From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/53] IB/qib: Add Makefile
Date: Mon, 23 Nov 2009 20:02:12 -0800
Message-ID: <adaiqd0370b.fsf@roland-alpha.cisco.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
	<20091119233706.30356.20051.stgit@chromite.mv.qlogic.com>
	<adaeinu6owu.fsf@roland-alpha.cisco.com>
	<alpine.LFD.1.10.0911191700500.21294@topaz.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.1.10.0911191700500.21294-vxnkQ4oxbxUi9g6yJnKVd0EOCMrvLtNR@public.gmane.org> (Dave
	Olson's message of "Thu, 19 Nov 2009 17:07:45 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Olson <dave.olson-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > | I think the convention is to do this with multiple files per line, ie
 > | 
 > | ib_qib-y :=	qip_cq.o qib_diag.o qib_dma.o ... \
 > 
 > Last time we did that, we got asked to change it to one per line.  If
 > conventions have changed, no problem.

I think whoever told you that was on something.  I can't even find one
example of one-filename-per-line in any Makefile in the kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
