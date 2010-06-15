From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] ofa_kernel/infiniband node description patch
Date: Tue, 15 Jun 2010 15:20:20 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A00@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E79E8@MNEXMB1.qlogic.org>
 <20100615201000.GD4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100615201000.GD4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, the feedback from you was about making sure the description was null terminated.

This *is* settable through sysfs, and still is even when the patch is applied. The problem is that the current model is to set the description once, at boot time, through an init script. This will often cause the description to be set incorrectly, because the host name has not been set at the time the script is run.

The reason I changed the default behavior for the various HCAs was because it simply seems like a smarter default behavior than simply setting it to the model of the HCA.

So, basically, if you have an init script to set the node descriptions it will still work - but this patch makes it unlikely you will need such a script in the first place.

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Tuesday, June 15, 2010 4:10 PM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz
Subject: Re: [PATCH v2] ofa_kernel/infiniband node description patch

On Tue, Jun 15, 2010 at 02:35:35PM -0500, Mike Heinz wrote:

> This updated patch incorporates feedback from Jason Gunthorpe and Or Gerlitz.

It does? :)

I admit this is puzzling to me, isn't this settable via sysfs?

On the other hand, it does seem quite wrong to me to use utsname in a
static way like it was before, so this is an improvement..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
