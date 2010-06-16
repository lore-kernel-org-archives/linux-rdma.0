From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] ofa_kernel/infiniband node description patch
Date: Wed, 16 Jun 2010 08:53:05 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A3D@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E79E8@MNEXMB1.qlogic.org>
 <20100615201000.GD4630@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A00@MNEXMB1.qlogic.org>
 <201006161538.09029.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201006161538.09029.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jack Morgerstein wrote:
> Actually, that feedback was from me :).

Oops. Well, that explains why Jason was confused. Sorry Jason.

>  Actually, you will still need the install-script setting.  If you have several HCA's of the same type installed on a single host, they will all get the same node description.
> If you wish to differentiate between the different HCA's (which openibd does), you will still need the install script.

> Finally, I'm not convinced that changing the default behavior (to have utsname: <fw burned description>) is necessary.
I think it is redundant, since the sysfs-interface is always available (which can make use of the "@" improvement).  

Jack,

While I agree the start up script plus this patch provides better results than this patch alone it's important to remember this patch is going into the upstream kernel, not OFED, and the openibd script is not part of the upstream kernel. Thus, I felt it was important that this new capability be useful as-is, rather than having no effect without additional code.

My intent at this point is to get this patch into the upstream kernel and for the similar patch to be accepted by EWG for 1.5.2 along with an additional EWG-only patch to change the openibd script.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
