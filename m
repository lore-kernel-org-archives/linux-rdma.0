From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Write Packets to InfiniBand HCA
Date: Tue, 3 Jan 2012 08:53:24 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CCCCCFB63@MNEXMB1.qlogic.org>
References: <CANtVascW3aRunBOSevwJgv8vN6gnNjmZM=8vLii=pUsDaFam3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANtVascW3aRunBOSevwJgv8vN6gnNjmZM=8vLii=pUsDaFam3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

That would depend on which HCA you are using. I know that you can use QLogic's iPath interface to do what you want, but I don't think it is possible through the verbs interface available through stock OFED.

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Greg I Kerr
Sent: Monday, January 02, 2012 9:50 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Write Packets to InfiniBand HCA

Hi,

Does anyone know if it is or isn't possible to put the HCA in some kind of "raw" mode where I can compose a packet in software and write it to the card? This is obviously in comparison to calling ibv_post_send and having a work request converted into a packet.

Thanks,

Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
