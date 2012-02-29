From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] opensm: osm_subnet.c: Patch to add error-reporting to
 the parsing of opensm.conf
Date: Wed, 29 Feb 2012 08:36:43 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD9C49@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD9BF4@MNEXMB1.qlogic.org>
 <20120229114532.GA2662@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120229114532.GA2662@calypso>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey, Alex - sounds like a good idea. I'll get that done today.

-----Original Message-----
From: Alex Netes [mailto:alexne-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] On Behalf Of Alex Netes
Sent: Wednesday, February 29, 2012 6:46 AM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Hal Rosenstock; Todd Rimmer
Subject: Re: [PATCH] opensm: osm_subnet.c: Patch to add error-reporting to the parsing of opensm.conf

Hi Mike,

I think it's better also to print the error to the screen, like "Invalid Cached Option Value" messages using log_report().

-- Alex


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
