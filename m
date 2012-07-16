From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Rebasing your for-next branch to 3.5-rc7
Date: Mon, 16 Jul 2012 15:31:37 +0300
Message-ID: <201207161531.37600.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Roland,

I am back from vacation.  Hopefully, you are progressing with your review of
the huge patch set I submitted -- please let me know if there is anything
I can do to help.

I noticed that the KVM group submitted a fix for the SRIOV IRQ guest problem
(Point #3 of the "Some Limitations" section of the patch set cover letter):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a76beb14123a69ca080f5a5425e28b786d62318d

This fix is incorporated in 3.5-rc7.  If you rebase, we can get rid of the workaround.

Thanks!

-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
