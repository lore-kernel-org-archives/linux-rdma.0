From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 12:56:56 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA816B75308F7@MNEXMB2.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>
 <20100618172216.GK4630@obsidianresearch.com>
 <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>
 <20100618174650.GL4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100618174650.GL4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason wrote:
> You cannot easily change the broadcast GID after starting. It gets
> into places, and this patch does not address that. I suspect that
> un-doing all the places the GID gets into is fairly hard..

We have successfully tested this patch by bouncing the SM with a new partition table config and IPoIB successfully moved to the new Pkey and continued working.  Within IPoIB this code was the only remaining place which incorrectly used the stale Pkey which the hardware initialized to prior to the SM programming the PKey table.

In any case, that particular requirement is less important than the ability for a server to boot to the correct pkey once at boot time, without needing specific configuration files created on the server which match the SM's configuration.

This patch clear addresses the more important requirement and has been observed in our test team to successfully handle the Partition table change case as well.

Todd Rimmer
Chief Architect 
QLogic Network Systems Group
Voice: 610-233-4852     Fax: 610-233-4777
Todd.Rimmer-8votvDbAKxjQT0dZR+AlfA@public.gmane.org  www.QLogic.com
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
