From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] ofa_kernel/infiniband node description patch
Date: Wed, 16 Jun 2010 15:38:08 +0300
Message-ID: <201006161538.09029.jackm@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E79E8@MNEXMB1.qlogic.org> <20100615201000.GD4630@obsidianresearch.com> <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A00@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A00-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 15 June 2010 23:20, Mike Heinz wrote:
> Well, the feedback from you was about making sure the description was null terminated.
Actually, that feedback was from me :).

> This *is* settable through sysfs, and still is even when the patch is applied. The problem is that the current model is to set the description once, at boot time, through an init script. This will often cause the description to be set incorrectly, because the host name has not been set at the time the script is run.
> 
> The reason I changed the default behavior for the various HCAs was because it simply seems like a smarter default behavior than simply setting it to the model of the HCA.
> 
> So, basically, if you have an init script to set the node descriptions it will still work - but this patch makes it unlikely you will need such a script in the first place.
> 
Actually, you will still need the install-script setting.  If you have several HCA's of the same type installed on a single host,
they will all get the same node description.
If you wish to differentiate between the different HCA's (which openibd does), you will still need the install script.

Finally, I'm not convinced that changing the default behavior (to have utsname: <fw burned description>) is necessary.
I think it is redundant, since the sysfs-interface is always available (which can make use of the "@" improvement).  

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
