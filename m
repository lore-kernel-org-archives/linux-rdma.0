From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: How to RoCE v2?
Date: Mon, 13 Jul 2015 11:47:28 +0000
Message-ID: <3CBF78CA47A0D542A0094940BB0205E762D284@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
This is my first e-mail on this list. I have a few questions that I hope you'll answer -

In the latest OFED (3.18-rc3) I don't see any RoCE v2 code, albeit it being introduce in 2014. How come?

I've been unable to track patches from e-mail archives about relevant e-mails such as "[PATCH 0/2] Adding support for RoCE V2 specification". Where can patches be found/tracked? Is there a git repository with log?

I've also tried to build the latest OFED, in the hope that it will contain the RoCE 2 code, but got errors. I followed the instructions in the web (https://www.openfabrics.org/index.php/installation.html) but got errors when applying patches ("./scripts/admin_rdma.sh -n -p") and also when skipping it and running configure and make... are the instructions up-to-date?

Thanks,

Ram


________________________________

This message and any attached documents contain information from the sending company or its parent company(s), subsidiaries, divisions or branch offices that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
