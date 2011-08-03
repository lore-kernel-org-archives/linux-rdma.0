From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: What is the current version of mstflint?
Date: Tue, 2 Aug 2011 18:38:13 -0700
Message-ID: <20110802183813.274552b5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Kladnitsky <orenk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, Ben Woodard <woodard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Oren,

What is the current version of mstflint?  Looking through the git tree I see that you fixed a bug which resulted in kernel messages like this:

        2011-07-31 08:38:43 mstflint:3792 freeing invalid memtype fe900000-fe910000

I am trying to point RedHat to this fixed version (So that they can include it in RHEL 6.2) but I don't see any tags in the git tree.  Is the fix from commit 771c3d04c9a09a83c182037663032b1f53dbf87b "Fix unmap typo bug" in a tagged and/or released version?

>From the comments in the most recent commit it looks like the most current version is "MFT 2.7.0 build 20 (final)"?

Thanks,
Ira

-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
