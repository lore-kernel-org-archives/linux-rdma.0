From: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [ewg] [PATCH] pkey fix for ipoib - resubmission
Date: Fri, 18 Jun 2010 12:32:52 -0500
Message-ID: <5AEC2602AE03EB46BFC16C6B9B200DA816B75308EF@MNEXMB2.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>
	<4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C6D@MNEXMB1.qlogic.org>
 <20100618172216.GK4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100618172216.GK4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason wrote:

> What happens if the SM reprograms the pkey table later?
> 
> I'm not sure this is the right approach.. See the recent dicussion
> about using pkey indexes at all.
> 
> Each ipoib interface is assigned a pkey, by number, not index. If the
> SM has not supplied that pkey to the port then the ipoib should not
> come up. If the SM adds it later then it should come up, if it the SM
> removes it later then it should go down.
> 
> The default ipoib interface uses the default pkey. If your network
> need ipoib to use a different pkey then you have to change the pkey
> number assignment when the ipoib interface is created, not magically
> attempt to autoconfigure.
> 
> I believe you cannot safely change the broadcast GID once the ipoib
> interface has started.

The goal for IPoIB should be a mechanism which can mimic the ease of setting up VLANs in Ethernet.  In Ethernet a default VLAN can be programmed into a switch in which case no configuration of the server is needed.  Ethernet switch vendors often provide centralized tools for setting up VLANS in all the switches.  It is only when you want a given server to participate in multiple VLANs that you need to setup specific configuration on the server to do so.

For IB, the centralized tool is the SM and a "VLAN" is an IB Partition.  The present capability of using the 1st PKey table entry is a nice simple and powerful way to mimic the ease of use of Ethernet VLANs.  Only when a user wants IPoIB to run on two different partitions (which is rare) is a server specific configuration needed.

When IPoIB sees a PKey table change, it will reregister with the broadcast GID.  PKey table changes typically also involve a restart of the SM and hence a reregistration request is necessary anyway.

Todd Rimmer
Chief Architect 
QLogic Network Systems Group
Voice: 610-233-4852     Fax: 610-233-4777
Todd.Rimmer-8votvDbAKxjQT0dZR+AlfA@public.gmane.org  www.QLogic.com
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
