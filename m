From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Tue, 6 Oct 2009 12:05:02 -0700
Message-ID: <D61F37041B6F49ACB0AC64FBF2DC4D00@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <20091005175656.GK5191@obsidianresearch.com> <F7D418716F3A4A0DACE42CC449624298@amr.corp.intel.com> <20091005181525.GL5191@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA8168EFD82BA@MNEXMB2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5AEC2602AE03EB46BFC16C6B9B200DA8168EFD82BA-e4KNYiSEog6Xx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Todd Rimmer' <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Ideally the best approach would be to have a mux at the ib_mad level.  We could
>allow a user space application to intercept all outbound MADs for a given class
>and/or attribute.  Unlike the present "snooping" of mads, this would literally
>be a interception.  This would provide a number of key advantages:

I agree that this is a good idea, and I mentioned something similar to this
before on the list.  The idea was rejected in favor of using standard SA
redirection.

That said, it may not be the best approach in all situations.  It restricts any
solution to the MAD layer only.  If you look at how IB ACM approaches the
problem, it combines the name/address resolution (ARP) with route resolution (PR
query) without sending QP 1 traffic.  A solution limited to snooping MADs would
be less efficient.

For these two patches, if user space can determine the address mapping that they
want for their connection and/or the path that should be used, do we allow the
user to specify either or both?  I'd like to keep this discussion somewhat
separate from how those were obtained.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
