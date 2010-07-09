From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Thu, 08 Jul 2010 20:46:14 -0700
Message-ID: <ada4og9z5a1.fsf@roland-alpha.cisco.com>
References: <20100709110427.c05987cc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100709110427.c05987cc.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> (Stephen
	Rothwell's message of "Fri, 9 Jul 2010 11:04:27 +1000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > After merging the infiniband tree, today's linux-next build (x86_64
 > allmodconfig) failed like this:
 > 
 > make[2]: *** No rule to make target `firmware/qlogic/sd7220.fw', needed by `__fw_modbuild'.  Stop.

Sorry, I took the version of the patch that Ralph sent me, instead of
Ben's original patch, and that version dropped the most important part,
namely the actual firmware file.

Should be fixed now.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
